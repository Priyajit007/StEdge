`timescale 1ns / 1ps
//==============================================================================
// Module : camera_reset_clk
//
// Pin-level glue between Basys 3 controls and the OV7670. Two jobs:
//
//   * xclk         = clk                -- feeds the system clock straight
//                                           into the camera XCLK pin (M19).
//                                           OV7670 will happily accept any
//                                           8-48 MHz clock as XCLK; the paper
//                                           runs it from the 100 MHz domain
//                                           divided upstream.
//   * camera_reset = ~crst              -- inverts the active-low switch so
//                                           the OV7670 RSTn pin (N17) is
//                                           released when the user raises the
//                                           slide switch (SW2 / W16).
//
// `reset` is wired in as a port for BD uniformity; it is not consumed here.
//==============================================================================


module camera_reset_clk(
input reset,
input clk,
output xclk,
output camera_reset,
input crst
    );
assign xclk = clk;
assign camera_reset = ~crst;
endmodule
