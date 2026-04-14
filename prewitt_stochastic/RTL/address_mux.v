`timescale 1ns / 1ps
//==============================================================================
// Module : address_mux
//
// Steers either the write address (capture side) or the read address (VGA
// side) onto the single frame_buffer port, according to the wea strobe from
// read_write_controller. Pure combinational 2:1 mux on 17-bit addresses.
//==============================================================================


module address_mux(
input [16:0] rd_add,
input [16:0] wr_add,
input wea,
output [16:0] add
    );
assign add = wea?wr_add:rd_add;
endmodule
