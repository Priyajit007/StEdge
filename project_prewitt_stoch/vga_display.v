`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2025 10:36:34
// Design Name: 
// Module Name: vga_display
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.01.2025 14:55:53
// Design Name: 
// Module Name: VGAout
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


module vga_display(
    input clk_100mhz,
    input p_clk,
    input [7:0] data_in,
    input reset,
    output hsync,
    output vsync,
    output [11:0] rgb,
    output video_on,
    output wire [16:0] address,
    output reg frame_done,
    output reg [9:0] h_count_reg,
    output reg [9:0] v_count_reg
    );
     parameter HD = 640;             // horizontal display area width in pixels
    parameter HF = 48;              // horizontal front porch width in pixels
    parameter HB = 16;              // horizontal back porch width in pixels
    parameter HR = 96;              // horizontal retrace width in pixels
    parameter HMAX = HD+HF+HB+HR-1; // max value of horizontal counter = 799
    parameter VD = 480;             // vertical display area length in pixels 
    parameter VF = 10;              // vertical front porch length in pixels  
    parameter VB = 33;              // vertical back porch length in pixels   
    parameter VR = 2;               // vertical retrace length in pixels  
    parameter VMAX = VD+VF+VB+VR-1; // max value of vertical counter = 524   
    
//    reg [9:0] h_count_reg, v_count_reg;
    reg [7:0] data;
    reg flag;
    wire [16:0] address1;
   //Logic for horizontal counter
    always @(posedge clk_100mhz)
    begin
        if(reset)
            begin
                frame_done <= 0;
                flag <= 0;
            end
        else if(frame_done == 1)
            frame_done <= 0;
        else if(v_count_reg == VD && frame_done==0 && flag==0)
            begin
                frame_done <= 1;
                flag <= 1;
            end
        else if(v_count_reg == 3)
            flag <= 0;
        else
            frame_done <= frame_done;
    end
    always @(posedge p_clk or posedge reset)      // pixel tick
        if(reset)
        begin
            h_count_reg = 0;
        end
        else
            if(h_count_reg == HMAX)                 // end of horizontal scan
                h_count_reg = 0;
            else
                h_count_reg = h_count_reg + 1;         
  
    // Logic for vertical counter
    always @(posedge p_clk or posedge reset)
        if(reset)
            v_count_reg = 0;
        else
            if(h_count_reg == HMAX)                 // end of horizontal scan
                if((v_count_reg == VMAX))
                begin           // end of vertical scan
                    v_count_reg = 0;
                end
                else
                    v_count_reg = v_count_reg + 1;
        
    // h_sync_next asserted within the horizontal retrace area
    assign hsync = (h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
    
    // v_sync_next asserted within the vertical retrace area
    assign vsync = (v_count_reg >= (VD+VB) && v_count_reg <= (VD+VB+VR-1));
    
    // Video ON/OFF - only ON while pixel counts are within the display area
    assign video_on = (h_count_reg < HD) && (v_count_reg < VD); // 0-639 and 0-479 respectively
    
    assign rgb = (video_on) ?{data_in[3:0],data_in[3:0],data_in[3:0]}:12'b0;
    assign address = (v_count_reg/2) * 320 + (h_count_reg/2);
//    assign address1 = v_count_reg * 640 + h_count_reg;
//    assign address = (address1<76800)?address1:17'b0;
//      assign address1 = (v_count_reg * 320) + h_count_reg;
//      assign address = (address1<76800)&&(v_count_reg<240)&&(h_count_reg<320)?address1:17'b0;
endmodule
