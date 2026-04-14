`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2025 23:09:51
// Design Name: 
// Module Name: sobel_stoch
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


module sobel_stoch(
input clk,
output  [7:0] pix_out,
input video_on,
input reset,
input clk_100mhz, 
input  [7:0] data_in, 
output reg [16:0] address,
input frame_done
    );
reg [7:0] d_prev;
reg [7:0] d_curr;
reg [7:0] d_next;
reg [7:0] d_prev_stoch;
reg [7:0] d_curr_stoch;
reg [7:0] d_next_stoch;
reg [7:0] O [0:2][0:2];
integer col_count;
integer row_count;
reg [7:0] ax,bx,cx; // ax = p2 - p0, bx = p5 - p3, cx = p8 - p6;
reg [7:0] ay,by,cy; // ay = p0 - p6, by = p1 - p7, cy = p2 - p8; 
reg [7:0] m1x,m2x,m1y,m2y,dx,dy,res_reg;
reg flag;
reg [1:0] counter;
wire [16:0] address1;
wire [16:0] address2;
wire [16:0] address3;
//parameter sizeOfLengthReal = 307200; //total data bytes
//parameter INFILE  = "C:/Users/auroa/Desktop/acceleratortest/testPic1.hex";
//(* ram_style = "block" *)reg [7 : 0]   total_memory [0 : sizeOfLengthReal-1];

//initial begin
//col_count <= 4;
//row_count <= 0;
//$readmemh(INFILE,total_memory,0,sizeOfLengthReal-1); // read file from INFILE
//end
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
        d_prev <= data_in;
        counter <= counter + 1;
        address <= address2;
    end
    else if(counter == 1)
    begin
        d_curr <= data_in;
        counter <= counter + 1;
        address <= address3;
    end
    else if(counter == 2)
    begin
        d_next <= data_in;
        counter <= counter + 1;
        flag <= 0;
        address <= address1;
    end
end
always @(posedge clk) // Computation pipeline
if (shift_en&&video_on&&!reset) begin
//    d_prev <= total_memory[(col_count+640*(row_count-1))%sizeOfLengthReal];
//    d_curr <= total_memory[(col_count+640*row_count)%sizeOfLengthReal];
//    d_next <= total_memory[(col_count+640*(row_count+1))%sizeOfLengthReal];
    d_prev_stoch = pix_stoch(d_prev);
    d_curr_stoch = pix_stoch(d_curr);
    d_next_stoch = pix_stoch(d_next);
    O[0][0] <= O[0][1];
    O[0][1] <= O[0][2];
    O[0][2] <=d_prev_stoch;
//    $readmemh(INFILE,prev,(col_count+640*(row_count-1)),(col_count+640*(row_count-1)));
//    O[0][2] <= prev[0];
    O[1][0] <= O[0][1];
    O[1][1] <= O[0][2];
    O[1][2] <= d_curr_stoch;
//    $readmemh(INFILE,curr,(col_count+640*row_count),(col_count+640*row_count));
//    O[1][2] <= curr[0];
    O[2][0] <= O[0][1];
    O[2][1] <= O[0][2];
    O[2][2] <= d_next_stoch;
//    $readmemh(INFILE,next,(col_count+640*(row_count+1)),(col_count+640*(row_count+1)));
//    O[2][2] <= next[0];
    ax = O[0][0] ^O[0][2];
    bx = O[1][0] ^O[1][2];
    cx = O[2][0] ^O[2][2];    
    ay = O[0][0] ^O[2][0];
    by = O[0][1] ^O[2][1];
    cy = O[0][2] ^O[2][2];
    
    m1x   = {ax[7],bx[6],ax[5],bx[4],ax[3],bx[2],ax[1],bx[0]};
    m2x   = {1'b0,cx[6],1'b0,cx[4],1'b0,cx[2],1'b0,cx[0]};
    m1y   = {ay[7],by[6],ay[5],by[4],ay[3],by[2],ay[1],by[0]};
    m2y   = {1'b0,cy[6],1'b0,cy[4],1'b0,cy[2],1'b0,cy[0]};
    
     dx    <= {m1x[7],m2x[6],m1x[5],m2x[4],m1x[3],m2x[2],m1x[1],m2x[0]};
     dy    <= {m1y[7],m2y[6],m1y[5],m2y[4],m1y[3],m2y[2],m1y[1],m2y[0]};
     
     res_reg    <= (((dx[7]+dy[6])+(dx[5]+dy[4]))+((dx[3]+dy[2])+(dx[1]+dy[0])))*31;
    
end
always @(posedge clk) begin
    if(reset) 
        col_count <= 4;
    else if(video_on)
        col_count <= (col_count + 1<=639)?col_count+1:0;
end

always @(posedge clk) begin
    if(reset) 
        row_count <= 0;
    else if(video_on)
       row_count<= (col_count + 1<=639)?row_count:(row_count+1<=479)?row_count+1:0;
end

function [7:0] pix_stoch;
    input [7:0] pix;
    begin
        pix_stoch[0] = (pix >= 0) ? 1 : 0;
        pix_stoch[1] = (pix >= 32) ? 1 : 0;
        pix_stoch[2] = (pix >= 64) ? 1 : 0;
        pix_stoch[3] = (pix >= 96) ? 1 : 0;
        pix_stoch[4] = (pix >= 128) ? 1 : 0;
        pix_stoch[5] = (pix >= 160) ? 1 : 0;
        pix_stoch[6] = (pix >= 192) ? 1 : 0;
        pix_stoch[7] = (pix >= 224) ? 1 : 0;
    end
endfunction

assign shift_en = (row_count>=1&&row_count<=478);
//assign valid_pix=((col_count-4>=1 || col_count+636<=638)&&shift_en)?1:0;
assign valid_pix = 1;
assign pix_out = valid_pix?res_reg:8'b0;
assign address1 = (col_count/2)+320*((row_count-1)/2);
assign address2 = (col_count/2)+320*(row_count/2);
assign address3 = (col_count/2)+320*((row_count+1)/2);
   
endmodule
