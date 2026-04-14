`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2025 14:01:57
// Design Name: 
// Module Name: camera_reset_clk
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
