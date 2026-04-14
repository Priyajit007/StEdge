# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk_in1_0]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk_in1_0]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_in1_0]
#VGAconnector
set_property PACKAGE_PIN G19 [get_ports {rgb_0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[0]}]
set_property PACKAGE_PIN H19 [get_ports {rgb_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[1]}]
set_property PACKAGE_PIN J19 [get_ports {rgb_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[2]}]
set_property PACKAGE_PIN N19 [get_ports {rgb_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[3]}]
set_property PACKAGE_PIN J17 [get_ports {rgb_0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[4]}]
set_property PACKAGE_PIN H17 [get_ports {rgb_0[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[5]}]
set_property PACKAGE_PIN G17 [get_ports {rgb_0[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[6]}]
set_property PACKAGE_PIN D17 [get_ports {rgb_0[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[7]}]
set_property PACKAGE_PIN N18 [get_ports {rgb_0[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[8]}]
set_property PACKAGE_PIN L18 [get_ports {rgb_0[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[9]}]
set_property PACKAGE_PIN K18 [get_ports {rgb_0[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[10]}]
set_property PACKAGE_PIN J18 [get_ports {rgb_0[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_0[11]}]
set_property PACKAGE_PIN P19 [get_ports hsync_1]
set_property IOSTANDARD LVCMOS33 [get_ports hsync_1]
set_property PACKAGE_PIN R19 [get_ports vsync_1]
set_property IOSTANDARD LVCMOS33 [get_ports vsync_1]
#reset
set_property PACKAGE_PIN V17 [get_ports reset_0]
set_property IOSTANDARD LVCMOS33 [get_ports reset_0]
#camera
## Clock signal from camera (PCLK)
set_property PACKAGE_PIN P18 [get_ports {pclk_0}]
set_property IOSTANDARD LVCMOS33 [get_ports {pclk_0}]

## VSYNC signal from camera
set_property PACKAGE_PIN L17 [get_ports {vsync_0}]
set_property IOSTANDARD LVCMOS33 [get_ports {vsync_0}]

## HREF signal from camera
set_property PACKAGE_PIN M18 [get_ports {hsync_0}]
set_property IOSTANDARD LVCMOS33 [get_ports {hsync_0}]

## Camera Data Pins D0 - D7 → data_In_0[7:0]

# D0
set_property PACKAGE_PIN A14 [get_ports {data_in_0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[0]}]

# D1
set_property PACKAGE_PIN A16 [get_ports {data_in_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[1]}]

# D2
set_property PACKAGE_PIN B15 [get_ports {data_in_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[2]}]

# D3
set_property PACKAGE_PIN B16 [get_ports {data_in_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[3]}]

# D4
set_property PACKAGE_PIN A15 [get_ports {data_in_0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[4]}]

# D5
set_property PACKAGE_PIN A17 [get_ports {data_in_0[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[5]}]

# D6

set_property PACKAGE_PIN C15 [get_ports {data_in_0[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[6]}]

# D7
set_property PACKAGE_PIN C16 [get_ports {data_in_0[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[7]}]

# camera xclk
set_property PACKAGE_PIN M19 [get_ports {xclk_0}]
set_property IOSTANDARD LVCMOS33 [get_ports {xclk_0}]
#camera_reset
set_property PACKAGE_PIN N17 [get_ports {camera_reset_0}]
set_property IOSTANDARD LVCMOS33 [get_ports {camera_reset_0}]
#en
set_property PACKAGE_PIN V16 [get_ports {en_0}]
set_property IOSTANDARD LVCMOS33 [get_ports {en_0}]
#en
set_property PACKAGE_PIN W16 [get_ports {crst_0}]
set_property IOSTANDARD LVCMOS33 [get_ports {crst_0}]