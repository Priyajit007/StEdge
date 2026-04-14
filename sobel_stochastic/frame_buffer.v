`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 00:29:47
// Design Name: 
// Module Name: frame_buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module frame_buffer(
input clk,
input [16:0] add,
input [7:0] data_in,
output reg [7:0] data_out,
input wea
    );
(* ram_style = "block" *) reg [7:0] buffer [0:76799];

always @(posedge clk)
begin
    if(wea)
        buffer[add] <= data_in;
    if(!wea)
        data_out <= buffer[add];
end
endmodule
