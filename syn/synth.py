#!/usr/bin/env python3
"""Automated ASAP7 7 nm Design Compiler synthesis for the StEdge stochastic
edge-detection RTL (sobel_stochastic + prewitt_stochastic).

The StEdge sources are a flat set of Verilog leaf modules that are wired
together inside a Vivado block design (`design_1_wrapper.bit`), so there is no
single RTL top that instantiates the whole system. Following the request to
synthesise "the source files ... separate subfolder for separate source files,
keep log files separate", this driver treats **every RTL source file as its own
synthesis unit** and gives each one a self-contained working folder:

    syn/designs/<design>/<module>/      one folder per source file
        <module>.v                      local copy of the RTL
        dc_<module>.tcl                 the per-file synthesis script
        test.log                        full DC run log (stdout)
        timing.log                      report_timing (worst setup paths)
        area.log / areahier.log         report_area (flat / -hierarchy)
        power.log / powerhier.log       report_power (flat / -hierarchy)
        reports/                        check_design, qor, drc, hold, refs, cg
        <module>.mapped.v               gate-level netlist

`<design>` is sobel_stochastic or prewitt_stochastic; `<module>` is the source
file stem (address_mux, capture, sobel_stoch, ...). Only sobel_stoch.v differs
between the two designs; the other eight modules are byte-identical but are kept
per-design so each design folder is fully self-contained.

Clock handling is automatic (the modules use different clock-port names --
clk, clk_100mhz, pclk, p_clk, vsync, and the generated halfclk -- and some are
purely combinational). Real clocks are found by scanning `posedge/negedge`
edges (comments stripped first) and intersecting with the port list; a virtual
clock is used for combinational modules so timing.log is still meaningful.

Tool : Synopsys Design Compiler W-2024.09-SP4 (latest installed)  -- dc_shell
PDK  : ASAP7 7 nm, RVT, TT 0.70 V 25 C (5 .db cell families)
Clock: 1 GHz (period 1000 ps; ASAP7 Liberty time unit = 1 ps)

Usage:
    python3 synth.py --list                # print the source-file table
    python3 synth.py --gen-only            # just write folders + tcl scripts
    python3 synth.py --jobs 4              # generate + synthesise all (4 parallel)
    python3 synth.py --designs sobel_stochastic         # subset by design
    python3 synth.py --modules sobel_stoch frame_buffer # subset by module
"""
import argparse
import os
import re
import shutil
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)                       # StEdge/
DESIGNS_DIR = os.path.join(HERE, "designs")

# The two StEdge design source trees (each has an RTL/ folder of .v files).
DESIGNS = ["sobel_stochastic", "prewitt_stochastic"]

DC_SHELL = "/package/eda/synopsys/syn/W-2024.09-SP4/bin/dc_shell"
SYNOPSYS = "/package/eda/synopsys/syn/W-2024.09-SP4"
ASAP7_DIR = "/home/min/a/das169/das169/asap7"

SYNTH_TIMEOUT = 1200        # seconds per normal module
HEAVY_TIMEOUT = 300         # seconds for memory-heavy modules (e.g. frame_buffer);
                            # a 614 kb register array will not converge -- this
                            # just bounds the attempt before it is marked TIMEOUT
HEAVY_DEPTH = 4096          # reg array deeper than this -> "heavy" (flop blow-up)
DISK_MIN_GB = 8.0           # if free space drops below this, purge netlists

# ---------------------------------------------------------------------------
# RTL analysis: module name, ports, clocks, memory size
# ---------------------------------------------------------------------------

def strip_comments(text):
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)   # block comments
    text = re.sub(r"//[^\n]*", "", text)                # line comments
    return text


def analyze_rtl(path):
    """Return dict(module, inputs, outputs, clock_ports, input_clocks,
    out_clock_ports, max_mem_depth) parsed from a single-module .v file."""
    raw = open(path, errors="ignore").read()
    code = strip_comments(raw)

    mods = re.findall(r"\bmodule\s+(\w+)", code)
    module = mods[0] if mods else os.path.splitext(os.path.basename(path))[0]

    # ANSI port header: module <name> ( ... ) ;
    hdr = re.search(r"\bmodule\s+\w+\s*\((.*?)\)\s*;", code, re.S)
    inputs, outputs = [], []
    if hdr:
        last_dir = None
        for chunk in hdr.group(1).split(","):
            c = chunk.strip()
            if not c:
                continue
            m = re.match(r"(input|output|inout)\b", c)
            if m:
                last_dir = m.group(1)
                rest = c[m.end():]
            else:
                rest = c                      # bare continuation of previous dir
            # drop reg/wire/signed and any [..] ranges, keep the trailing name
            rest = re.sub(r"\b(reg|wire|logic|signed|unsigned)\b", " ", rest)
            rest = re.sub(r"\[[^\]]*\]", " ", rest)
            names = re.findall(r"[A-Za-z_]\w*", rest)
            if not names or last_dir is None:
                continue
            name = names[-1]
            if last_dir == "input":
                inputs.append(name)
            elif last_dir == "output":
                outputs.append(name)
            else:                              # inout -> treat as both
                inputs.append(name)
                outputs.append(name)

    ports = inputs + outputs
    # real clocks = signals used on a clock edge (comments already stripped),
    # excluding async set/reset controls (`always @(posedge clk or posedge
    # reset)` lists reset as an edge but it is NOT a clock).
    edges = set(re.findall(r"\b(?:pos|neg)edge\s+(\w+)", code))
    is_reset = lambda n: re.search(r"(?i)(reset|rst|clr|clear|arst|preset)", n)
    clocks = {e for e in edges if not is_reset(e)}
    clock_ports = [p for p in ports if p in clocks]
    input_clocks = [p for p in inputs if p in clocks]
    out_clock_ports = [p for p in outputs if p in clocks]

    # largest declared memory (reg [..] name [hi:lo]) -> flop blow-up risk
    max_depth = 0
    for hi, lo in re.findall(r"\breg\b[^\;]*?\[\s*(\d+)\s*:\s*(\d+)\s*\]\s*;", code):
        max_depth = max(max_depth, abs(int(hi) - int(lo)) + 1)

    return {
        "module": module,
        "inputs": inputs,
        "outputs": outputs,
        "clock_ports": clock_ports,
        "input_clocks": input_clocks,
        "out_clock_ports": out_clock_ports,
        "max_mem_depth": max_depth,
    }


def shim_rtl(text, filename):
    """Apply minimal, semantics-preserving fixes so the strict DC HDL Compiler
    accepts RTL that Vivado synthesises leniently. Returns (patched, notes).
    Applied to the LOCAL synthesis copy only -- the original repo RTL is left
    untouched. Every inserted/changed line is marked `// [synth shim]`.

      1. Implicit continuous-assign nets: a name used in an expression but only
         created by `assign name = ...` is rejected by DC (VER-956) when its
         first textual use precedes the assign (e.g. sobel_stoch's `shift_en`).
         Verilog implicit nets are always 1-bit scalars, so an explicit
         `wire name;` is exact.
      2. sobel_stoch BRAM-fetch sequencer: `always @(posedge clk_100mhz or
         posedge clk or posedge reset)` then tests `clk` as a level and
         `counter` as data -- an illegal multi-clock flop for ASIC synthesis
         (ELAB-300/303; the RTL comment itself notes it "does NOT simulate
         cleanly"). Drop the extra `or posedge clk` edge so it is a normal
         clk_100mhz flop with async reset that samples `clk` as a level.
    """
    notes = []
    # (1) declare implicit continuous-assign nets
    assigned = re.findall(r"\bassign\s+(\w+)\s*=", text)
    decl_kw = re.compile(r"\b(wire|reg|logic|input|output|inout|tri|wand|wor)\b")
    need = []
    for name in dict.fromkeys(assigned):
        declared = any(decl_kw.search(ln) and re.search(r"\b" + re.escape(name) + r"\b", ln)
                       for ln in text.splitlines())
        if not declared:
            need.append(name)
    if need:
        decls = ("// [synth shim] explicit decl(s) for implicit continuous-assign "
                 "net(s) (DC HDL Compiler strictness)\n"
                 + "".join(f"wire {n};" for n in need))
        # insert just after the module port-list `);`. Work line-by-line on
        # comment-stripped lines and anchor on the real module name so a `);`
        # or the word "module" inside the header comment block is not matched.
        mn = re.search(r"\bmodule\s+(\w+)", strip_comments(text))
        mod_name = mn.group(1) if mn else ""
        lines = text.split("\n")
        start = next((i for i, ln in enumerate(lines)
                      if re.search(r"\bmodule\s+" + re.escape(mod_name) + r"\b",
                                   strip_comments(ln))), None)
        if start is not None:
            end = next((i for i in range(start, len(lines))
                        if re.search(r"\)\s*;", strip_comments(lines[i]))), start)
            lines.insert(end + 1, decls)
            text = "\n".join(lines)
            notes.append("declared implicit nets: " + ", ".join(need))
    # (2) targeted multi-clock fix for sobel_stoch's fetch sequencer
    if os.path.basename(filename) == "sobel_stoch.v":
        bad = "always @(posedge clk_100mhz or posedge clk or posedge reset)"
        good = ("always @(posedge clk_100mhz or posedge reset)  "
                "// [synth shim] dropped illegal 2nd clock edge 'or posedge clk' "
                "(ASIC: clk sampled as a level)")
        if bad in text:
            text = text.replace(bad, good)
            notes.append("dropped illegal 2nd clock edge in fetch sequencer")
    return text, notes


def build_units(only_designs=None, only_modules=None):
    units = []
    for design in DESIGNS:
        if only_designs and design not in only_designs:
            continue
        rtl_dir = os.path.join(ROOT, design, "RTL")
        if not os.path.isdir(rtl_dir):
            continue
        for fn in sorted(os.listdir(rtl_dir)):
            if not fn.endswith(".v"):
                continue
            stem = os.path.splitext(fn)[0]
            if only_modules and stem not in only_modules:
                continue
            src = os.path.join(rtl_dir, fn)
            info = analyze_rtl(src)
            units.append({
                "design": design,
                "module": stem,
                "src": src,
                "filename": fn,
                "info": info,
                "heavy": info["max_mem_depth"] > HEAVY_DEPTH,
            })
    return units


# ---------------------------------------------------------------------------
# TCL generation
# ---------------------------------------------------------------------------

def _tcl_list(items):
    return " ".join(items)


def build_clock_block(info):
    """Return the TCL constraint block (clocks + I/O delays) for this module.

    create_clock is issued only on INPUT clock ports -- DC rejects create_clock
    on an output port (UID-391), so an internally-generated clock that also
    leaves the module (capture's `halfclk`) is not redefined here; it is just
    kept out of the data-output delay set. Modules with no input clock get a
    virtual clock so their I/O paths are still timed."""
    input_clocks = info["input_clocks"]
    out_clocks = info["out_clock_ports"]
    L = []
    if input_clocks:
        for c in input_clocks:
            L.append(f'create_clock -name {c} -period $CLK_PERIOD_PS [get_ports {c}]')
        L.append('set_clock_uncertainty -setup 50 [all_clocks]')
        L.append('set_clock_uncertainty -hold  20 [all_clocks]')
        L.append('set_clock_transition  50        [all_clocks]')
        L.append('set_dont_touch_network          [all_clocks]')
        ref_get = f'[get_clocks {input_clocks[0]}]'
        in_coll = (f'[remove_from_collection [all_inputs] '
                   f'[get_ports {{{_tcl_list(input_clocks)}}}]]')
    else:
        # purely combinational -> virtual clock so I/O paths are still timed
        L.append('create_clock -name vclk -period $CLK_PERIOD_PS')
        ref_get = '[get_clocks vclk]'
        in_coll = '[all_inputs]'
    if out_clocks:
        out_coll = (f'[remove_from_collection [all_outputs] '
                    f'[get_ports {{{_tcl_list(out_clocks)}}}]]')
    else:
        out_coll = '[all_outputs]'

    L.append(f'set NONCLK_INPUTS {in_coll}')
    L.append(f'set DELAY_OUTPUTS {out_coll}')
    L.append(f'set_input_delay  -max 100 -clock {ref_get} $NONCLK_INPUTS')
    L.append(f'set_output_delay -max 100 -clock {ref_get} $DELAY_OUTPUTS')
    L.append('set DRV_BUF "BUFx2_ASAP7_75t_R"')
    L.append('if {[sizeof_collection [get_lib_cells -quiet */$DRV_BUF]] > 0} {')
    L.append('    set_driving_cell -lib_cell $DRV_BUF $NONCLK_INPUTS')
    L.append('}')
    return "\n".join(L)


TCL = """\
## ===========================================================================
## Auto-generated Design Compiler synthesis script
## Design   : {design}
## Source   : {filename}     (top module: {top})
## Clocks   : {clk_note}
## PDK      : ASAP7 7nm  RVT  TT 0.70 V 25 C
## Tool     : Synopsys DC W-2024.09-SP4
## Clock    : 1 GHz  (period 1000 ps; ASAP7 Liberty time unit = 1 ps)
## Compile  : compile_ultra (high effort), fallback compile -map_effort high
## ===========================================================================

set DESIGN     "{module}"
set TOP        "{top}"
set ASAP7_DIR  "{asap7}"
set REPORT_DIR "reports"
file mkdir $REPORT_DIR

# --- libraries: 5 ASAP7 RVT cell families ---------------------------------
set ASAP7_DBS [list \\
    "$ASAP7_DIR/db/asap7sc7p5t_AO_RVT_TT_nldm_211120.db" \\
    "$ASAP7_DIR/db/asap7sc7p5t_INVBUF_RVT_TT_nldm_220122.db" \\
    "$ASAP7_DIR/db/asap7sc7p5t_OA_RVT_TT_nldm_211120.db" \\
    "$ASAP7_DIR/db/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.db" \\
    "$ASAP7_DIR/db/asap7sc7p5t_SIMPLE_RVT_TT_nldm_211120.db" ]
set_app_var target_library $ASAP7_DBS
set_app_var link_library   [concat "*" $ASAP7_DBS]
set_app_var search_path    [concat [list "."] $search_path]

# --- read & elaborate RTL --------------------------------------------------
set RTL_FILES [list "{filename}"]
foreach f $RTL_FILES {{
    puts "Analyzing: $f"
    if {{[catch {{analyze -format verilog $f}} e]}} {{
        puts "verilog analyze failed ($e); retrying as sverilog"
        if {{[catch {{analyze -format sverilog $f}} e2]}} {{
            puts "FATAL: analyze failed on $f : $e2"; exit 2
        }}
    }}
}}
if {{[catch {{elaborate $TOP}} e]}} {{
    puts "FATAL: elaborate $TOP failed : $e"; exit 3
}}
current_design $TOP
link
uniquify

# --- ASAP7 don't-use list --------------------------------------------------
source "$ASAP7_DIR/asap7_dontuse.tcl"

# --- timing constraints: 1 GHz --------------------------------------------
set CLK_PERIOD_PS 1000
{clock_block}

check_design > $REPORT_DIR/check_design.log

# --- compile (high effort) -------------------------------------------------
set_max_area 0
set_app_var compile_ultra_ungroup_small_hierarchies false
puts "=== compile_ultra (high effort) ==="
if {{[catch {{compile_ultra -no_autoungroup}} e]}} {{
    puts "compile_ultra failed: $e"
    puts "=== falling back to compile -map_effort high ==="
    if {{[catch {{compile -map_effort high}} e2]}} {{
        puts "FATAL: compile failed : $e2"; exit 4
    }}
}}

# --- reports (kept) --------------------------------------------------------
puts "=== generating reports ==="
report_timing -path_type full -delay_type max -max_paths 5 -nworst 5 \\
    -input_pins -nets -significant_digits 4 > timing.log
report_area                 > area.log
report_area  -hierarchy     > areahier.log
report_power                > power.log
report_power -hierarchy     > powerhier.log
# --- small diagnostics -----------------------------------------------------
report_timing -delay_type min -significant_digits 4 > $REPORT_DIR/timing_hold.log
report_qor                       > $REPORT_DIR/qor.log
report_constraint -all_violators -significant_digits 4 > $REPORT_DIR/drc.log
report_reference                 > $REPORT_DIR/references.log
if {{[catch {{report_clock_gating > $REPORT_DIR/clock_gating.log}} e]}} {{}}

write -format verilog -hierarchy -output ${{DESIGN}}.mapped.v

puts "=== SYNTH_OK $DESIGN ==="
exit 0
"""


def setup_unit_dir(u):
    """Create syn/designs/<design>/<module>/ with a local RTL copy + dc tcl."""
    wd = os.path.join(DESIGNS_DIR, u["design"], u["module"])
    os.makedirs(wd, exist_ok=True)
    src_text = open(u["src"], errors="ignore").read()
    patched, shim_notes = shim_rtl(src_text, u["filename"])
    with open(os.path.join(wd, u["filename"]), "w") as fh:
        fh.write(patched)
    u["shim_notes"] = shim_notes
    info = u["info"]
    clk_note = (", ".join(info["input_clocks"]) if info["input_clocks"]
                else "none (combinational -> virtual clock)")
    if info["out_clock_ports"]:
        clk_note += (" (+ generated clock(s) " + ", ".join(info["out_clock_ports"])
                     + " left unconstrained)")
    tcl = TCL.format(
        design=u["design"], filename=u["filename"], module=u["module"],
        top=info["module"], asap7=ASAP7_DIR, clk_note=clk_note,
        clock_block=build_clock_block(info),
    )
    tcl_path = os.path.join(wd, f"dc_{u['module']}.tcl")
    with open(tcl_path, "w") as fh:
        fh.write(tcl)
    return wd, tcl_path


# ---------------------------------------------------------------------------
# Run + cleanup
# ---------------------------------------------------------------------------

KEEP = {"test.log", "timing.log", "area.log", "areahier.log", "power.log",
        "powerhier.log"}
JUNK_PREFIX = ("default.svf", "command.log")
JUNK_EXT = (".mr", ".pvl", ".syn", ".svf")


def free_gb(path):
    st = os.statvfs(path)
    return st.f_bavail * st.f_frsize / 1e9


def clean_unit_dir(wd, purge_netlist=False):
    for f in os.listdir(wd):
        p = os.path.join(wd, f)
        if os.path.isdir(p):
            if f != "reports":          # alib*, cksum_dir, etc. are DC scratch
                shutil.rmtree(p, ignore_errors=True)
            continue
        if f in KEEP or f == "reports":
            continue
        if f.startswith("dc_") and f.endswith(".tcl"):
            continue
        if f.endswith(".v") and not f.endswith(".mapped.v"):
            continue          # keep local RTL copy (cheap, self-contained)
        if f.startswith(JUNK_PREFIX) or f.endswith(JUNK_EXT):
            os.remove(p); continue
        if f.endswith(".mapped.v"):
            if purge_netlist:
                os.remove(p)
            continue


def run_one(u, do_clean=True):
    wd, tcl_path = setup_unit_dir(u)
    log_path = os.path.join(wd, "test.log")
    env = dict(os.environ, SYNOPSYS=SYNOPSYS)
    timeout = HEAVY_TIMEOUT if u["heavy"] else SYNTH_TIMEOUT
    status = {"design": u["design"], "module": u["module"], "heavy": u["heavy"]}
    try:
        with open(log_path, "wb") as logf:
            res = subprocess.run(
                [DC_SHELL, "-f", os.path.basename(tcl_path)],
                cwd=wd, env=env, stdout=logf, stderr=subprocess.STDOUT,
                timeout=timeout)
        rc = res.returncode
    except subprocess.TimeoutExpired:
        with open(log_path, "a") as logf:
            logf.write(f"\n*** SYNTH TIMEOUT after {timeout}s ***\n")
        rc = -1
    log_txt = open(log_path, errors="ignore").read()
    area_p = os.path.join(wd, "area.log")
    # require a real area report (a broken design can still reach SYNTH_OK with
    # an empty area.log), and no analyze/elaborate error in the log
    area_ok = os.path.exists(area_p) and "Total cell area" in open(
        area_p, errors="ignore").read()
    ok = "SYNTH_OK" in log_txt and area_ok and "VER-956" not in log_txt
    status["rc"] = rc
    status["ok"] = ok
    if do_clean:
        purge = free_gb(wd) < DISK_MIN_GB
        clean_unit_dir(wd, purge_netlist=purge)
        status["disk_low"] = purge
    return status


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--jobs", type=int, default=1)
    ap.add_argument("--designs", nargs="+", default=None)
    ap.add_argument("--modules", nargs="+", default=None)
    ap.add_argument("--gen-only", action="store_true")
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--no-clean", action="store_true")
    args = ap.parse_args()

    os.makedirs(DESIGNS_DIR, exist_ok=True)
    units = build_units(args.designs, args.modules)

    if args.list:
        print(f"{'design':20} {'module':24} {'top':22} {'clocks':28} heavy")
        for u in units:
            info = u["info"]
            clks = ",".join(info["clock_ports"]) or "(comb)"
            print(f"{u['design']:20} {u['module']:24} {info['module']:22} "
                  f"{clks:28} {'YES' if u['heavy'] else ''}")
        print(f"\nTotal: {len(units)} source files")
        return

    if args.gen_only:
        for u in units:
            wd, tcl = setup_unit_dir(u)
            print(f"  generated {tcl}")
        print(f"Generated {len(units)} per-source-file scripts.")
        return

    print(f"Synthesizing {len(units)} source files  (jobs={args.jobs})")
    results = []
    if args.jobs <= 1:
        for u in units:
            print(f"--- {u['design']}/{u['module']} ---", flush=True)
            r = run_one(u, do_clean=not args.no_clean)
            print(f"    {'OK' if r['ok'] else 'FAIL'} rc={r['rc']}", flush=True)
            results.append(r)
    else:
        with ThreadPoolExecutor(max_workers=args.jobs) as ex:
            futs = {ex.submit(run_one, u, not args.no_clean): u for u in units}
            for fut in as_completed(futs):
                r = fut.result()
                print(f"    {r['design']}/{r['module']:24} "
                      f"{'OK' if r['ok'] else 'FAIL'} rc={r['rc']}", flush=True)
                results.append(r)

    ok = [r for r in results if r["ok"]]
    bad = [r for r in results if not r["ok"]]
    print(f"\n=== {len(ok)}/{len(results)} succeeded ===")
    if bad:
        print("FAILED:", ", ".join(f"{r['design']}/{r['module']}" for r in bad))


if __name__ == "__main__":
    main()
