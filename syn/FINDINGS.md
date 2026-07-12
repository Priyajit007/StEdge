# Synthesis Findings — StEdge edge detection (stochastic + traditional)

Per-source-file ASAP7 7 nm synthesis (DC W-2024.09-SP4, 1 GHz, `compile_ultra`
high effort) of four designs: the two stochastic edge detectors
(`sobel_stochastic`, `prewitt_stochastic`) and the two deterministic
"traditional full system" builds (`sobel_traditional`, `prewitt_traditional`).
The traditional builds reuse the eight peripheral modules verbatim from the
stochastic RTL and swap only the compute core for the deterministic engine in
`traditional_src_codes/` — so §6 below is a like-for-like stochastic-vs-traditional
comparison of the edge-compute core. Sections 1–5 cover the stochastic designs;
§6 covers the traditional builds and the comparison.

The StEdge RTL targets a Xilinx FPGA and is integrated in a **Vivado block
design** (there is no RTL top tying the modules together), so each of the nine
source files per design is synthesised **standalone as its own top**. The notes
below cover the DC-vs-Vivado portability issues found and the minimal shims
applied to make synthesis clean. **All shims are applied to the local synthesis
copy under `designs/…/<module>.v` only — the original repo RTL is untouched** —
and every shimmed line is tagged `// [synth shim]`.

---

## 1. Multi-clock-name handling (all modules)

The modules do not share a clock-port name. Across the nine files the clock
appears as `clk`, `clk_100mhz`, `pclk`, `p_clk`, `vsync`, the generated
`halfclk`, or not at all. `synth.py` therefore detects clocks structurally —
every signal used on a `posedge`/`negedge` edge (with comments stripped),
intersected with the port list — instead of assuming a port named `clk`.

* **Async resets are not clocks.** `always @(posedge clk or posedge reset)`
  lists `reset` as an edge, but it is an async clear, not a clock. Reset-like
  names (`reset`, `rst`, `clr`, `clear`, `arst`, `preset`) are excluded from the
  clock set, so they get a normal input delay instead of a 1 GHz `create_clock`.
* **Generated clock on an output port** (`capture.halfclk`). `halfclk` is a
  divided clock that is both used internally and driven out of the module. DC
  rejects `create_clock` on an output port (`UID-391`), so clocks are created
  only on **input** clock ports; `halfclk`'s small domain is left unconstrained
  (it is still synthesised, and excluded from the data-output delay set).
* **Purely combinational modules** (`address_mux`, `data_MUX`,
  `camera_reset_clk`) get a **virtual clock** so their input→output paths are
  still timed and reported.

## 2. `sobel_stoch` — implicit nets used before declaration (VER-956)

`shift_en` is read inside the compute `always` block (`if (shift_en && …)`) but
only created later by `assign shift_en = …`. Vivado auto-declares such an
implicit net; DC's HDL Compiler rejects it (`VER-956: symbol 'shift_en' is not
defined`) because its first textual use is a procedural read, which is not one
of the contexts that creates an implicit net. `valid_pix` is the same pattern.

**Shim:** add an explicit `wire shift_en;` / `wire valid_pix;` at the top of the
module. Implicit Verilog nets are always 1-bit scalars, so the explicit
single-bit declaration is semantically exact — it only fixes declaration order.

## 3. `sobel_stoch` — illegal multi-clock fetch sequencer (ELAB-300/303)

The BRAM-fetch micro-sequencer was written as:
```verilog
always @(posedge clk_100mhz or posedge clk or posedge reset)
    if (reset) ...
    else if (clk && !flag) ...      // tests clk as a LEVEL
    else if (counter == 0)  ...      // tests counter (not in the edge list)
```
This is a flip-flop triggered by **two clocks** (`clk_100mhz` *and* `clk`) plus
an async reset, then tests `clk` as a level and `counter` as data inside the
edge-sensitive block. That is not a synthesisable flop for an ASIC flow — DC
raises `ELAB-303` (reset condition must be a simple identifier) and `ELAB-300`
(`counter` not in the event expression). The RTL's own comment notes this block
"Synthesises fine but does **NOT simulate cleanly**" — i.e. it relies on
Vivado-specific leniency.

**Shim:** drop the redundant `or posedge clk` edge so the block is a normal
`clk_100mhz` flop with async reset that samples `clk` as a level
(`always @(posedge clk_100mhz or posedge reset)`). This is the standard ASIC
mapping of the intent (advance the fetch on the fast system clock, observing the
pixel-clock level) and leaves the compute pipeline (`always @(posedge clk)`) and
the row/column counters unchanged. `clk` remains a real clock for the compute
path, so `sobel_stoch` is correctly constrained on both `clk` and `clk_100mhz`.

## 4. `frame_buffer` — 320×240×8 BRAM with no ASIC macro

`frame_buffer` declares `reg [7:0] buffer [0:76799]` (a 76 800-word × 8-bit =
**614 400-bit** memory, the `(* ram_style = "block" *)` FPGA Block-RAM). There is
no compiled SRAM macro for this odd depth in the academic ASAP7 kit (the RWT
reference used OpenRAM macros for its MATMUL SRAMs; StEdge ships none), so DC has
to map the array to **standard-cell flip-flops** — ~614 k DFFs plus a 76 800:1
read mux. That does not converge under `compile_ultra` in a sensible time/memory
budget, so this one source file is given a bounded timeout and is expected to be
reported **TIMEOUT/FAIL**. On the FPGA it is one Block-RAM; a real ASIC port
would instantiate a compiled SRAM macro instead of inferring registers. This is
a property of the memory, not a synthesis error in the surrounding logic.

---

## 5. Result summary (stochastic designs)

**16 / 18 stochastic source files synthesised cleanly** at 1 GHz on ASAP7 7 nm
(no `Error` lines). The two `frame_buffer` instances are the expected exception
(§4, the 614 kb BRAM has no ASIC macro). The eight non-core modules are
byte-identical between the two stochastic designs, so their numbers match
exactly; only `sobel_stoch` differs. The traditional builds and the
stochastic-vs-traditional comparison are in §6.

Per source file (ASAP7 RVT, TT 0.70 V 25 °C, 1 GHz target; values shared by both
designs unless split):

| Source file            | Status  | Area µm² | # cells | # FF | Power µW | Worst slack ps | Est Fmax GHz |
|------------------------|---------|---------:|--------:|-----:|---------:|---------------:|-------------:|
| `camera_reset_clk`     | OK      |    0.044 |       1 |    0 |    0.005 |          794.3 |        4.86  |
| `data_MUX`             | OK      |    0.700 |       8 |    0 |    0.412 |          771.1 |        4.37  |
| `capture_starter`      | OK      |    0.379 |       3 |    1 |    1.204 |          786.9 |        4.69  |
| `address_mux`          | OK      |    2.333 |      19 |    0 |    1.072 |          697.9 |        3.31  |
| `read_write_controller`| OK      |    3.499 |      30 |    5 |    7.566 |          731.7 |        3.73  |
| `vga_display`          | OK      |   17.992 |     147 |   22 |   29.825 |          343.2 |        1.52  |
| `capture`              | OK      |   30.429 |     224 |   49 |   26.188 |          768.5 |        4.32  |
| `frame_buffer`         | TIMEOUT |        — |       — |    — |        — |              — |          —   |
| `sobel_stoch` (Sobel)  | OK      |   99.990 |     932 |  110 |  150.752 |            3.30 |       1.003  |
| `sobel_stoch` (Prewitt)| OK      |  106.405 |     980 |  122 |  165.860 |            0.43 |       1.000  |

Observations:

* **`sobel_stoch` is the timing-critical and area/power-dominant block** — as
  expected, it is the actual stochastic compute core. It just meets the 1 GHz
  target (slack ≈ 3.3 ps Sobel / 0.4 ps Prewitt); every other module has wide
  positive slack.
* **Prewitt vs Sobel core:** the Prewitt variant came out slightly *larger*
  (106.4 vs 100.0 µm², 122 vs 110 FFs, 166 vs 151 µW). Although Prewitt zeroes
  the middle-row terms (`m2x/m2y` use `1'b0`), the Sobel variant's reuse of the
  `bx`/`by` differences lets DC share more logic; the net difference is ≈ 6 %.
* **Warnings are benign** (no errors). The histogram is dominated by
  `UID-401` (driving-cell attribute set on input ports — from `set_driving_cell`),
  `OPT-1311` (ASAP7 ships only placeholder alibs — DC analyses the library
  directly), `UID-348` (the intended virtual clock on the three combinational
  modules), `VER-318` (signed→unsigned RTL conversions), and `UISN-40`
  (DesignWare library auto-add). None affect correctness.

---

## 6. Traditional full-system synthesis + stochastic-vs-traditional comparison

The two **traditional** designs (`sobel_traditional`, `prewitt_traditional`)
build the same camera-to-VGA edge-detection system but replace the stochastic
compute core with the **deterministic** engine in `traditional_src_codes/`
(`sobel.v` / `prewitt.v`). Those cores compute `|Gx| + |Gy|` with ordinary
11-bit signed arithmetic (shift-and-add convolution + an `abs()` function,
mapped by DC to DesignWare `DP_OP_*` adders), instead of the stochastic pipeline's
XOR subtractors and bit-interleaved concatenation adders. The eight peripheral
modules are reused **verbatim** from the matching stochastic design (they are
byte-identical), so the only thing that changes between a stochastic design and
its traditional counterpart is the compute core — the block the comparison is
about.

**Shims.** The traditional cores have the *same* illegal multi-clock fetch
sequencer as `sobel_stoch` (§3), so the identical "drop `or posedge clk`" shim is
applied. They already declare `shift_en` / `valid_pix`, so the implicit-net shim
(§2) does not fire. `prewitt.v` declares `module sobel` in the source; its local
synthesis copy is renamed to `prewitt` so the folder, the DC top and the netlist
agree. Two extra (benign) warnings appear that the stochastic cores don't:
`TIM-052` (a non-unate `clk` path through the DesignWare arithmetic operators)
and `VO-4` (`assign` feedthroughs written into the netlist) — neither affects
timing closure (both cores meet 1 GHz).

**Result.** All 16 traditional peripheral+core modules synthesised cleanly at
1 GHz (`frame_buffer` TIMEOUTs as in §4). Across all four designs that is
**32 / 36 source files clean**. Compute-core comparison (ASAP7 RVT, TT 0.70 V
25 °C, 1 GHz):

| Compute core        | Area µm² | # cells | # FF | Total power µW | Worst slack ps | Est Fmax GHz |
|---------------------|---------:|--------:|-----:|---------------:|---------------:|-------------:|
| Sobel — stochastic  |    99.99 |     932 |  110 |         150.75 |           3.30 |        1.003 |
| Sobel — traditional |   135.32 |    1206 |  154 |         208.48 |           0.18 |        1.000 |
| Prewitt — stochastic|   106.40 |     980 |  122 |         165.86 |           0.43 |        1.000 |
| Prewitt — traditional|  139.72 |    1248 |  154 |         209.20 |           0.55 |        1.001 |

Observations:

* **Stochastic computing wins on area and power, as intended.** For Sobel the
  stochastic core is **26 % smaller** (100.0 vs 135.3 µm²), draws **28 % less
  power** (150.8 vs 208.5 µW) and uses **29 % fewer flip-flops** (110 vs 154)
  than the deterministic arithmetic core. For Prewitt the gap is **24 % area /
  21 % power / 21 % FFs** (106.4 vs 139.7 µm², 165.9 vs 209.2 µW, 122 vs 154 FF).
  The XOR/concat stochastic datapath is simply cheaper than the signed
  shift-add-abs arithmetic that DC maps to DesignWare adders.
* **Both styles just close 1 GHz.** All four cores meet timing with small
  positive slack (traditional Sobel is tightest at 0.18 ps); none is timing-
  limited relative to the other.
* **Prewitt ≳ Sobel in both styles.** The Prewitt core is marginally larger than
  Sobel in each style (stochastic +6 %, traditional +3 %) — consistent with the
  stochastic-only observation in §5.

See `results/summary.csv`, `results/synthesis_results.xlsx` (Summary_All + one
sheet per design) and `plots/`:
`within_<design>.png` (per-design breakdowns), `cross_area_by_module.png`,
`cross_design_avg.png`, `cross_area_vs_power.png`, and
`cross_compute_core.png` (the stochastic-vs-traditional core comparison above).
