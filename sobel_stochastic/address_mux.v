`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2025 21:30:42
// Design Name: 
// Module Name: address_mux
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


module address_mux(
input [16:0] rd_add,
input [16:0] wr_add,
input wea,
output [16:0] add
    );
assign add = wea?wr_add:rd_add;
endmodule
