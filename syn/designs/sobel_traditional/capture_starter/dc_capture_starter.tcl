## ===========================================================================
## Auto-generated Design Compiler synthesis script
## Design   : sobel_traditional
## Source   : capture_starter.v     (top module: capture_starter)
## Clocks   : vsync
## PDK      : ASAP7 7nm  RVT  TT 0.70 V 25 C
## Tool     : Synopsys DC W-2024.09-SP4
## Clock    : 1 GHz  (period 1000 ps; ASAP7 Liberty time unit = 1 ps)
## Compile  : compile_ultra (high effort), fallback compile -map_effort high
## ===========================================================================

set DESIGN     "capture_starter"
set TOP        "capture_starter"
set ASAP7_DIR  "/home/min/a/das169/das169/asap7"
set REPORT_DIR "reports"
file mkdir $REPORT_DIR

# --- libraries: 5 ASAP7 RVT cell families ---------------------------------
set ASAP7_DBS [list \
    "$ASAP7_DIR/db/asap7sc7p5t_AO_RVT_TT_nldm_211120.db" \
    "$ASAP7_DIR/db/asap7sc7p5t_INVBUF_RVT_TT_nldm_220122.db" \
    "$ASAP7_DIR/db/asap7sc7p5t_OA_RVT_TT_nldm_211120.db" \
    "$ASAP7_DIR/db/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.db" \
    "$ASAP7_DIR/db/asap7sc7p5t_SIMPLE_RVT_TT_nldm_211120.db" ]
set_app_var target_library $ASAP7_DBS
set_app_var link_library   [concat "*" $ASAP7_DBS]
set_app_var search_path    [concat [list "."] $search_path]

# --- read & elaborate RTL --------------------------------------------------
set RTL_FILES [list "capture_starter.v"]
foreach f $RTL_FILES {
    puts "Analyzing: $f"
    if {[catch {analyze -format verilog $f} e]} {
        puts "verilog analyze failed ($e); retrying as sverilog"
        if {[catch {analyze -format sverilog $f} e2]} {
            puts "FATAL: analyze failed on $f : $e2"; exit 2
        }
    }
}
if {[catch {elaborate $TOP} e]} {
    puts "FATAL: elaborate $TOP failed : $e"; exit 3
}
current_design $TOP
link
uniquify

# --- ASAP7 don't-use list --------------------------------------------------
source "$ASAP7_DIR/asap7_dontuse.tcl"

# --- timing constraints: 1 GHz --------------------------------------------
set CLK_PERIOD_PS 1000
create_clock -name vsync -period $CLK_PERIOD_PS [get_ports vsync]
set_clock_uncertainty -setup 50 [all_clocks]
set_clock_uncertainty -hold  20 [all_clocks]
set_clock_transition  50        [all_clocks]
set_dont_touch_network          [all_clocks]
set NONCLK_INPUTS [remove_from_collection [all_inputs] [get_ports {vsync}]]
set DELAY_OUTPUTS [all_outputs]
set_input_delay  -max 100 -clock [get_clocks vsync] $NONCLK_INPUTS
set_output_delay -max 100 -clock [get_clocks vsync] $DELAY_OUTPUTS
set DRV_BUF "BUFx2_ASAP7_75t_R"
if {[sizeof_collection [get_lib_cells -quiet */$DRV_BUF]] > 0} {
    set_driving_cell -lib_cell $DRV_BUF $NONCLK_INPUTS
}

check_design > $REPORT_DIR/check_design.log

# --- compile (high effort) -------------------------------------------------
set_max_area 0
set_app_var compile_ultra_ungroup_small_hierarchies false
puts "=== compile_ultra (high effort) ==="
if {[catch {compile_ultra -no_autoungroup} e]} {
    puts "compile_ultra failed: $e"
    puts "=== falling back to compile -map_effort high ==="
    if {[catch {compile -map_effort high} e2]} {
        puts "FATAL: compile failed : $e2"; exit 4
    }
}

# --- reports (kept) --------------------------------------------------------
puts "=== generating reports ==="
report_timing -path_type full -delay_type max -max_paths 5 -nworst 5 \
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
if {[catch {report_clock_gating > $REPORT_DIR/clock_gating.log} e]} {}

write -format verilog -hierarchy -output ${DESIGN}.mapped.v

puts "=== SYNTH_OK $DESIGN ==="
exit 0
