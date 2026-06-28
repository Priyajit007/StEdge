# ASAP7 7 nm Synthesis — StEdge stochastic edge detection

Automated Design Compiler synthesis of every RTL **source file** in the StEdge
project — the `sobel_stochastic` and `prewitt_stochastic` camera-to-VGA
stochastic edge detectors.

The StEdge RTL is a flat set of Verilog leaf modules that are wired together
inside a **Vivado block design** (`*/Bitfile/design_1_wrapper.bit`); there is no
single RTL module that instantiates the whole system. So, following the request
to synthesise "the source files … separate subfolder for separate source files,
keep log files separate", **each source file is synthesised independently as its
own top**, in its own self-contained folder with its own logs.

## Toolchain & settings
| Item            | Value                                                        |
|-----------------|--------------------------------------------------------------|
| Synthesis tool  | Synopsys Design Compiler **W-2024.09-SP4** (`dc_shell`) — latest installed |
| PDK             | **ASAP7** 7 nm, RVT, TT corner, 0.70 V, 25 °C (5 `.db` cell families) |
| Target clock    | **1 GHz** (period 1000 ps; ASAP7 Liberty time unit = 1 ps)   |
| Compile         | `compile_ultra -no_autoungroup` (high effort), fallback `compile -map_effort high` |
| Constraints     | clk uncertainty 50/20 ps, I/O delay 100 ps, BUFx2 driving cell |
| Don't-use       | ASAP7 `asap7_dontuse.tcl` (dummy/scan/fill/tap cells)        |

The flow mirrors the RWT/approximate/MATMUL reference under
`/home/min/a/das169/design_compiler/RWT/arya_2026_06_18/syn` (same libraries,
clock, compile strategy and report set), adapted to per-source-file granularity
and automatic multi-clock detection.

## Directory layout
```
syn/
  designs/<design>/<module>/      one self-contained folder per source file
    <module>.v                    local copy of the RTL (carries any synth shim)
    dc_<module>.tcl               the per-file synthesis script (separate per folder)
    test.log                      full DC run log (stdout)
    timing.log                    report_timing (worst setup paths)
    area.log / areahier.log       report_area (flat / -hierarchy)
    power.log / powerhier.log     report_power (flat / -hierarchy)
    reports/                      check_design, qor, drc, hold timing, refs, clock-gating
    <module>.mapped.v             gate-level netlist
  synth.py                        discover sources + generate scripts + run DC + cleanup
  process_results.py              parse logs -> Excel + CSV + comparison plots
  results/                        synthesis_results.xlsx, summary.csv
  plots/                          within_<design>.png, cross_*.png
  full_batch.log                  the batch run log
  README.md  FINDINGS.md          this file + the per-file issue/shim notes
```
`<design>` is `sobel_stochastic` / `prewitt_stochastic`; `<module>` is the source
file stem. The 9 modules per design map to one folder each (18 total). Only
`sobel_stoch.v` differs between the two designs; the other eight modules are
byte-identical but are kept per-design so each design folder is self-contained.

## Running
```bash
python3 synth.py --list                 # print the 18-source-file table (+ clocks)
python3 synth.py --gen-only             # just write the per-file dc tcl scripts
python3 synth.py --jobs 4               # synthesize all 18 (4 parallel dc_shell)
python3 synth.py --designs sobel_stochastic          # subset by design
python3 synth.py --modules sobel_stoch frame_buffer  # subset by module
python3 process_results.py              # build Excel + CSV + plots after synthesis
```
Intermediate junk (`*.svf *.mr *.pvl *.syn alib/ cksum_dir/`) is cleaned
automatically; the six required logs (`area/areahier/power/powerhier/timing` +
`test.log`) are always kept, plus `reports/` and the gate netlist.

## Source files (per design)
| Module                  | Clocks (1 GHz)              | Role |
|-------------------------|----------------------------|------|
| `address_mux`           | — (combinational)          | 2:1 mux: write vs read frame-buffer address |
| `data_MUX`              | — (combinational)          | blank-screen gate on the display byte |
| `camera_reset_clk`      | — (feed-through)           | OV7670 XCLK pass-through + reset invert |
| `capture_starter`       | `vsync`                    | latches first vsync to align frame start |
| `capture`               | `clk_100mhz`, `pclk` (+ generated `halfclk`) | OV7670 byte capture FSM |
| `frame_buffer`          | `clk`                      | 320×240×8 single-port BRAM (see FINDINGS) |
| `read_write_controller` | `clk`                      | fill-vs-display arbiter FSM |
| `vga_display`           | `clk_100mhz`, `p_clk`      | 640×480 VGA timing + RGB out |
| `sobel_stoch`           | `clk`, `clk_100mhz`        | **the stochastic Sobel/Prewitt edge core** |

## Automatic clock handling
Each module declares its clock differently (`clk`, `clk_100mhz`, `pclk`, `p_clk`,
`vsync`, the generated `halfclk`, or none). `synth.py` finds the real clocks by
scanning `posedge`/`negedge` edges (comments stripped) and intersecting them with
the port list, **excluding async resets** (`reset` appears as an edge in
`@(posedge clk or posedge reset)` but is not a clock). It then:

* `create_clock` (1 GHz) on every **input** clock port — DC rejects clocks on an
  output port, so an internally-generated clock that also leaves the module
  (`capture.halfclk`) is left unconstrained rather than redefined;
* puts a virtual clock on purely-combinational modules so their I/O paths are
  still timed;
* applies input/output delay (100 ps) and a BUFx2 driving cell to the non-clock
  ports.

## RTL portability shims
Two StEdge modules use constructs that Vivado accepts but the stricter DC HDL
Compiler rejects. `synth.py` applies **minimal, documented, semantics-preserving
shims to the local synthesis copy only** — the original repo RTL under
`sobel_stochastic/RTL/` and `prewitt_stochastic/RTL/` is left untouched. Every
shimmed line is marked `// [synth shim]`. See **FINDINGS.md** for the full
rationale; in short:

* **implicit nets** (`sobel_stoch`): `shift_en` / `valid_pix` are used before
  their `assign`, so DC needs an explicit `wire` declaration (implicit Verilog
  nets are always 1-bit, so this is exact);
* **multi-clock sequencer** (`sobel_stoch`): the BRAM-fetch block was triggered
  by `@(posedge clk_100mhz or posedge clk or posedge reset)` and tested `clk` as
  a level — an illegal multi-clock flop for ASIC; the redundant `or posedge clk`
  edge is dropped (the RTL comment itself notes this block "does NOT simulate
  cleanly").
