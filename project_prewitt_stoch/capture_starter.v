`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2025 23:33:36
// Design Name: 
// Module Name: capture_starter
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


module capture_starter(
input vsync,
input reset,
output reg vsync_detected,
output reg capture_reset
    );
always @(posedge vsync)
begin
    capture_reset <= reset;
    if(reset == 1)
        vsync_detected <= 0;
    else
        vsync_detected <= 1;
end    
endmodule
