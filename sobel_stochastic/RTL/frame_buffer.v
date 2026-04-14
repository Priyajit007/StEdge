`timescale 1ns / 1ps
//==============================================================================
// Module : frame_buffer
//
// 320 x 240 x 8-bit single-port BRAM. One-clock read/write latency. The
// (* ram_style = "block" *) pragma pins the inference to Block RAM (as
// opposed to distributed LUTRAM) so the resource-saving headline in the
// paper still holds after synthesis.
//
// Ports
//   clk            : shared read/write clock
//   add[16:0]      : word address, 0..76799
//   data_in[7:0]   : write data (camera luma or SC edge byte)
//   data_out[7:0]  : read data (registered, shows up one clk after add)
//   wea            : 1 -> write, 0 -> read
//==============================================================================


module frame_buffer(
input clk,
input [16:0] add,
input [7:0] data_in,
output reg [7:0] data_out,
input wea
    );
// Force block-RAM inference (76800 bytes = 320*240).
(* ram_style = "block" *) reg [7:0] buffer [0:76799];

always @(posedge clk)
begin
    if(wea)
        buffer[add] <= data_in;
    if(!wea)
        data_out <= buffer[add];
end
endmodule
