# StEdge

Real-time edge-detection accelerator in the stochastic-computing (SC) domain, built for the
Digilent Basys 3 (Xilinx Artix-7 `xc7a35tcpg236-1`). The unified pipeline replaces conventional
gradient arithmetic with XOR-based subtraction and a deterministic bitstream-concatenation
adder, so both Sobel and Prewitt operators fit inside a 100 MHz design that streams 30 fps video
from an OV7670 camera straight to a VGA monitor.

Measured against a deterministic baseline on the same board: **~84 % fewer LUTs, ~68 % less
BRAM and ~17 % lower on-chip power** while holding visual quality flat. Full numbers, the
algebraic reformulation and the bit-interleaved accumulator trick are in the companion paper
(`Hardware_StoBel.pdf` is git-ignored; keep a local copy if you want the derivations handy).

---

## Repository layout

```
StEdge/
├── sobel_stochastic/
│   ├── RTL/              # nine .v sources – Sobel variant of sobel_stoch
│   ├── constraint/       # const.xdc – Basys 3 pin-out
│   └── Bitfile/          # pre-built design_1_wrapper.bit + debug .ltx
├── prewitt_stochastic/
│   ├── RTL/              # same nine modules; only sobel_stoch.v differs
│   ├── constraints/      # const.xdc
│   └── bitfile/          # pre-built bitstream
└── README.md
```

The two trees are deliberately parallel — same top-level ports, same BRAM layout, same VGA
timing — so the only thing that changes between a Sobel and a Prewitt build is the XOR /
concatenation tree inside `RTL/sobel_stoch.v`. Sobel uses four interleave stages (because the
middle row of the kernel is weighted ×2); Prewitt collapses to three (uniform weights) and the
missing stage shows up as zero-padded slots in `m2x`/`m2y`.

Pick one tree per build. **Do not mix sources from both directories in the same project** — the
module names collide.

---

## Hardware required

| Item                | Notes                                                                 |
|---------------------|-----------------------------------------------------------------------|
| Digilent Basys 3    | Artix-7 `xc7a35tcpg236-1`, 100 MHz on-board oscillator on `W5`        |
| OV7670 camera       | 8-bit YUV422, PCLK / VSYNC / HREF + I²C init. No FIFO variant assumed |
| VGA monitor + cable | Any monitor that accepts 640×480 @ 60 Hz through the on-board DB-15   |
| USB Micro-B cable   | Powers the Basys 3 and provides the JTAG bridge for programming       |
| ~20 Pmod jumper wires | OV7670 wiring — Pmod **JB** carries D0-D7, Pmod **JC** carries the control/clock pins (see `constraint/const.xdc`) |

OV7670 register init (white-balance, YUV422 output, QVGA windowing) is **not** part of this
design. Either pre-program the module over I²C with a small MCU before Basys 3 power-up, or
drive SIOC/SIOD from a spare FPGA Pmod and port one of the public OV7670 init cores. The paper
uses an off-board initialiser; the RTL in this repo only consumes D0-D7 + sync once the camera
is already streaming.

### Board-side wiring (from `const.xdc`)

```
Camera data  D0..D7   -> A14 A16 B15 B16 A15 A17 C15 C16     (Pmod JB)
Camera clk   PCLK     -> P18                                 (Pmod JC)
Camera sync  VSYNC    -> L17
             HREF     -> M18
Camera xclk  XCLK     -> M19     (24 MHz out to OV7670 — uses system clock here)
Camera rst   RSTn     -> N17
Switches     reset    -> V17 (SW0)
             en       -> V16 (SW1)
             crst     -> W16 (SW2)
VGA          R[3:0]   -> G19 H19 J19 N19
             G[3:0]   -> J17 H17 G17 D17
             B[3:0]   -> N18 L18 K18 J18
             HSYNC    -> P19
             VSYNC    -> R19
```

The design outputs greyscale by replicating the low 4 luma bits across R/G/B (see
`vga_display.v`) — the 12-bit RGB port is wired purely to match the Basys 3 VGA DAC.

---

## Toolchain

- **Xilinx Vivado 2024.2** — WebPACK is sufficient; no licensed IP is used. Older Vivado releases
  from the 2019.2 → 2024.1 window also build the design unchanged, but the `.bit` checked into
  `Bitfile/` was produced on 2024.2.
- **Digilent Basys 3 board files** — install so Vivado can resolve `xc7a35tcpg236-1` + the board
  preset. Clone `Digilent/vivado-boards` and copy `new/board_files/*` into
  `<Vivado>/data/boards/board_files/`.
- **JTAG drivers**
  - Linux: run `<Vivado>/data/xicom/cable_drivers/lin64/install_script/install_drivers/install_drivers`
    as root after installing Vivado.
  - Windows: Digilent Adept 2 runtime handles the Basys 3 out-of-the-box.
- Nothing else. No Python, no HLS, no soft-core — this is pure RTL driven from a Vivado block
  design.

---

## Flashing the pre-built bitstream (fastest path)

If you just want to see it run:

1. Power the Basys 3 over USB. Put SW0 (`reset`), SW1 (`en`), SW2 (`crst`) to `0`.
2. Open Vivado → *Open Hardware Manager* → *Open Target* → *Auto-connect*.
3. *Program Device* → pick `sobel_stochastic/Bitfile/design_1_wrapper.bit` (or the Prewitt
   variant under `prewitt_stochastic/bitfile/`).
4. Wire the OV7670 (see table above), plug the VGA monitor, flip SW2 high to release the
   camera reset, then SW1 high to enable the write-side FSM. Pulse SW0 once if the first frame
   is torn.

---

## Building from source

The project is a Vivado **block design** (IP Integrator). The constraint file targets the
auto-generated wrapper `design_1_wrapper`, and every port name carries the usual `_0` / `_1`
suffix IPI adds when exposing a hierarchical block's ports.

### Option A — GUI

1. `vivado &` → *Create Project* → RTL project, do **not** specify sources yet.
2. Part: `xc7a35tcpg236-1` (or board preset *Basys 3*).
3. Pick **one** tree:
   - Sobel build: add every `.v` under `sobel_stochastic/RTL/` and `sobel_stochastic/constraint/const.xdc`.
   - Prewitt build: add every `.v` under `prewitt_stochastic/RTL/` and `prewitt_stochastic/constraints/const.xdc`.
4. *Create Block Design* → name it **`design_1`** (the XDC expects that wrapper name).
5. In the BD canvas, right-click → *Add Module* and drop in `camera_reset_clk`,
   `capture_starter`, `capture`, `frame_buffer`, `address_mux`, `data_MUX`, `vga_display`,
   `sobel_stoch`, `read_write_controller`. Also drop a **Clocking Wizard** (100 MHz in →
   100 MHz `clk_out1` + 25 MHz `clk_out2` for the pixel clock, reset active-high).
6. Wire them up — in short:
   - `clk_in1` of the clocking wizard ← top-level `clk_in1_0` (W5).
   - `clk_out1` → `clk_100mhz` on `capture`, `sobel_stoch`, `vga_display`, `read_write_controller`.
   - `clk_out2` → `p_clk` of `vga_display`.
   - Camera `pclk_0`, `vsync_0`, `hsync_0`, `data_in_0[7:0]` → `capture`.
   - `capture.data_Y` → `frame_buffer.data_in`, `capture.address` → `address_mux.wr_add`,
     `vga_display.address` → `address_mux.rd_add`, `address_mux.add` → `frame_buffer.add`.
   - `frame_buffer.data_out` → `sobel_stoch.data_in`; `sobel_stoch.pix_out` → `data_MUX.din`;
     `data_MUX.dout` → `vga_display.data_in`.
   - `read_write_controller` arbitrates: `capture.frame_done` → `frame_writing_done`,
     `vga_display.frame_done` → `frame_display_done`, `wea` → `frame_buffer.wea` and
     `address_mux.wea`, `select` → `data_MUX.select`.
   - Expose `rgb_0`, `hsync_1`, `vsync_1`, `xclk_0`, `camera_reset_0`, `reset_0`, `en_0`,
     `crst_0` as external BD ports (names must match the XDC verbatim).
7. *Validate Design* → *Create HDL Wrapper* (let Vivado manage it) → the wrapper is
   `design_1_wrapper`.
8. Set `design_1_wrapper` as top. Run *Synthesis* → *Implementation* → *Generate Bitstream*.
9. *Open Hardware Manager* → *Program Device*.

### Option B — TCL (headless)

There is no build script checked in, but a minimal re-creation of Option A looks like this.
Save as `build.tcl` next to the repo root and invoke with
`vivado -mode batch -source build.tcl -tclargs sobel` (or `prewitt`):

```tcl
set variant [lindex $argv 0]
if {$variant eq "sobel"} {
    set rtl   sobel_stochastic/RTL
    set xdc   sobel_stochastic/constraint/const.xdc
} else {
    set rtl   prewitt_stochastic/RTL
    set xdc   prewitt_stochastic/constraints/const.xdc
}

create_project stedge_$variant ./build_$variant -part xc7a35tcpg236-1 -force
add_files [glob $rtl/*.v]
add_files -fileset constrs_1 $xdc

# ... create_bd_design design_1, instantiate modules, connect nets,
#     make_wrapper / add_files design_1_wrapper.v -- see GUI steps 4-7 above.

set_property top design_1_wrapper [current_fileset]
launch_runs synth_1 -jobs 8 ; wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8 ; wait_on_run impl_1
```

The BD stitch-up is the tedious bit; the paper's supplementary material distributes it as a
pre-archived `design_1.tcl`. If you build that into your copy of the repo, drop it beside the
RTL and call `source design_1.tcl` between `add_files` and `launch_runs`.

---

## Results reported in the paper

Basys 3 (`xc7a35tcpg236-1`), 100 MHz, post-implementation:

| Metric              | Deterministic baseline | **StEdge (stochastic)** | Reduction |
|---------------------|-----------------------:|------------------------:|----------:|
| LUTs                |                      — |                       — |    ~84 %  |
| BRAM                |                      — |                       — |    ~68 %  |
| On-chip power       |               0.251 W  |                 0.209 W |    ~17 %  |
| Junction temperature|                      — |                  26.3 °C |   —       |
| Throughput          |                 30 fps |                  30 fps |   —       |

The dashes are deliberate — the paper reports the reductions as ratios and the absolute
baseline numbers are in Table 4 / Table 5 of the PDF. Re-run your own numbers with Vivado's
`report_utilization` / `report_power` if you want to cite exact values for your board revision.

---

## Known gaps

- **No testbench.** The design was brought up directly on hardware. The two `always` blocks in
  `sobel_stoch.v` that are sensitive to both `clk_100mhz` and `clk` do not simulate cleanly
  without a wrapper that serialises the edges — don't be surprised if a naïve sim produces
  `X`s on `address`.
- **No OV7670 init core** is included; see the note under *Hardware required*.
- **Block-design TCL not distributed in-tree.** The `.bit` and the XDC are here, but the
  IPI stitching is in the paper's supplementary archive. Either follow the GUI steps above or
  port the supplement's `design_1.tcl`.
- A handful of the VGA timing-parameter names in `vga_display.v` (`HF` vs `HB`) swap the
  conventional front/back-porch labels. Values are correct for 640×480 @ 60 Hz (16/48/96); only
  the comments are misleading. Left unchanged to match the synthesised bitstream.

---

## Citing

```bibtex
@article{ghosh2026stedge,
  title   = {StEdge: A Low-Power Real-Time Hardware Accelerator for Edge Detection
             Using Stochastic Computing},
  author  = {Ghosh, Priyajit and Mukherjee, Rajarshi and Saha, Auro Anand and
             Das, Arghadip and Raha, Arnab and Naskar, Mrinal Kanti},
  journal = {Hardware},
  year    = {2026},
  doi     = {10.3390/hardware1010000},
  publisher = {MDPI}
}
```

## License

No open-source license file has been declared. Treat the RTL as research code released
alongside the paper — if you want to redistribute, modify or use it in a product, contact the
corresponding author (`priyajitkandi2003@gmail.com`).
