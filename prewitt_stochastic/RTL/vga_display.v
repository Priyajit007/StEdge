`timescale 1ns / 1ps
//==============================================================================
// Module : vga_display
//
// 640x480 @ 60 Hz VGA timing generator + read-side frame-buffer driver. Walks
// horizontal / vertical counters off the 25 MHz pixel clock, emits hsync /
// vsync and gates the 12-bit RGB output to the visible region.
//
// Per-row it also produces the BRAM read address:
//     address = (v/2) * 320 + (h/2)
// so the 320x240 buffer is upscaled 2x both ways into the 640x480 scan.
//
// Output rgb is { data_in[3:0], data_in[3:0], data_in[3:0] } -- greyscale
// replicated across R/G/B nibbles so the Basys 3's 4-bit-per-channel VGA DAC
// maps directly to luminance.
//
// Ports
//   clk_100mhz   : system clock -- only clocks frame_done pulse logic
//   p_clk        : 25 MHz pixel clock (from a MMCM/PLL in the block design)
//   data_in[7:0] : greyscale/edge byte coming back from the detector path
//   reset        : active-high clear
//   hsync, vsync : VGA sync pulses
//   rgb[11:0]    : 4:4:4 Basys 3 VGA DAC
//   video_on     : high only inside the visible 640x480 region
//   address[16:0]: read address into frame_buffer
//   frame_done   : one-tick pulse at end-of-visible region (display side handoff)
//   h_count_reg, v_count_reg : exposed for debug / chipscope taps
//
// NOTE: HF / HB parameter names swap the conventional front/back porch labels
// below; the numeric values are correct for 640x480 @ 60 Hz (16 front, 48
// back, 96 retrace). Left as-is because the bitstream in Bitfile/ matches.
//==============================================================================

`timescale 1ns / 1ps

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
   // ---- frame_done pulse on transition to the vertical blanking region ----
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
    
    // Greyscale broadcast onto all three 4-bit DAC lanes.
    assign rgb = (video_on) ?{data_in[3:0],data_in[3:0],data_in[3:0]}:12'b0;
    // 640x480 -> 320x240 map: divide both counters by 2 (pixel doubling).
    assign address = (v_count_reg/2) * 320 + (h_count_reg/2);
//    assign address1 = v_count_reg * 640 + h_count_reg;
//    assign address = (address1<76800)?address1:17'b0;
//      assign address1 = (v_count_reg * 320) + h_count_reg;
//      assign address = (address1<76800)&&(v_count_reg<240)&&(h_count_reg<320)?address1:17'b0;
endmodule
