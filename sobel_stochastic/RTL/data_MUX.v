`timescale 1ns / 1ps
//==============================================================================
// Module : data_MUX
//
// Blank-screen gate between sobel_stoch.pix_out and vga_display.data_in.
// `select` is driven by read_write_controller: the FSM holds it low while
// the frame buffer is being filled so the display shows black instead of
// a torn / half-updated frame.
//==============================================================================


module data_MUX(
input select,
input [7:0] din,
output [7:0] dout  );
assign dout = select?din:8'b0;
endmodule
