`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2025 00:04:22
// Design Name: 
// Module Name: sobel
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
module sobel(
input clk,
output  [7:0] pix_out,
input video_on,
input reset,
input clk_100mhz, 
input  [7:0] data_in, 
output reg [16:0] address,
input frame_done);

reg signed [10:0] Dx, Dy, D;
reg [7:0] abs_D;
reg [7:0] O [0:2][0:2];
integer col_count;
integer row_count;
wire shift_en;
wire valid_pix;
reg flag;
reg [1:0] counter;
wire [16:0] address1;
wire [16:0] address2;
wire [16:0] address3;

 function [10:0] abs (input signed [10:0] x);
abs = x>=0?x:-x;
endfunction

always @(posedge clk_100mhz or posedge clk or posedge reset)
begin
    if(reset)
    begin
        flag <= 0;
        counter <= 0;
    end 
    else if(clk && !flag)
    begin
        flag <= 1;
        counter <= 2'b00;
        address <= address1;
    end
    else if(counter == 0)
    begin
        O[0][2] <= data_in;
        counter <= counter + 1;
        address <= address2;
    end
    else if(counter == 1)
    begin
        O[1][2] <= data_in;
        counter <= counter + 1;
        address <= address3;
    end
    else if(counter == 2)
    begin
        O[2][2] <= data_in;
        counter <= counter + 1;
        flag <= 0;
        address <= address1;
    end
end


 always @(posedge clk) // Computation pipeline
if (shift_en&&video_on&&!reset) begin
    D =  abs(Dy)+abs(Dx);
    abs_D <= D[10:3];
    Dx <= - $signed({3'b000, O[0][0]}) // - 1 * 0[-1][-1]
     + $signed({3'b000, O[0][2]}) // + 1 * 0[-1][+1]
     - ($signed({3'b000, O[ 1][0]}) // - 1 * 0[ 0][-1]
     )
     + ($signed({3'b000, O[ 1][2]}) // + 1 * 0[ 0][+1]
     )
     - $signed({3'b000, O[2][0]}) // - 1 * 0[+1][-1]
     + $signed({3'b000, O[2][2]}); // + 1 * 0[+1][+1]
    Dy <= $signed({3'b000, O[0][0]}) // + 1 * O[-1][-1]
     + ($signed({3'b000, O[0][1]}) // + 1 * 0[-1][ 0]
    )
     + $signed({3'b000, O[0][2]}) // + 1 * 0[-1][+1]
     - $signed({3'b000, O[2][0]}) // - 1 * 0[+1][-1]
     - ($signed({3'b000, O[2][1]}) // - 1 * 0[+1][ 0]
     )
     - $signed({3'b000, O[2][2]}); // - 1 * 0[+1][+1]
    O[0][0] <= O[0][1];
    O[0][1] <= O[0][2];
//    O[0][2] <= total_memory[(col_count+640*(row_count-1))%sizeOfLengthReal];
//    $readmemh(INFILE,prev,(col_count+640*(row_count-1)),(col_count+640*(row_count-1)));
//    O[0][2] <= prev[0];
    O[1][0] <= O[0][1];
    O[1][1] <= O[0][2];
//    O[1][2] <= total_memory[(col_count+640*row_count)%sizeOfLengthReal];
//    $readmemh(INFILE,curr,(col_count+640*row_count),(col_count+640*row_count));
//    O[1][2] <= curr[0];
    O[2][0] <= O[0][1];
    O[2][1] <= O[0][2];
//    O[2][2] <= total_memory[(col_count+640*(row_count+1))%sizeOfLengthReal];
//    $readmemh(INFILE,next,(col_count+640*(row_count+1)),(col_count+640*(row_count+1)));
//    O[2][2] <= next[0];
end

always @(posedge clk) begin
    if(reset) 
        col_count <= 4;
    else if(video_on)
//        col_count <= (col_count + 1<=639)?col_count+1:0;
            col_count <= (col_count + 1<=639)?col_count+1:0;
end

always @(posedge clk) begin
    if(reset) 
        row_count <= 0;
    else if(video_on)
//       row_count<= (col_count + 1<=639)?row_count:(row_count+1<=479)?row_count+1:0;
         row_count<= (col_count + 1<=639)?row_count:(row_count+1<=479)?row_count+1:0;
end
assign address1 = (col_count/2)+320*((row_count-1)/2);
assign address2 = (col_count/2)+320*(row_count/2);
assign address3 = (col_count/2)+320*((row_count+1)/2);
assign shift_en = (row_count>=1&&row_count<=478);
//assign valid_pix=((col_count-4>=1 || col_count+636<=638)&&shift_en)?1:0;
assign valid_pix=1;
assign pix_out = valid_pix?abs_D:8'b0;
endmodule
