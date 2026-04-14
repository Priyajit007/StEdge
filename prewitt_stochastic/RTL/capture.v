//==============================================================================
// NOTE: the block below is an older/alternative revision of capture() that
// used pclk directly for address stepping and gated data_valid by halfclk.
// Kept commented out as reference; the actual synthesised module starts
// further down (after the second `timescale directive).
//==============================================================================


//module capture(
//input clk_100mhz,
//input pclk,
//input [7:0] data_In,
//input vsync,
//input hsync,
//input reset,
//output reg halfclk,
//output reg [7:0] data_Y,
//output reg [16:0] address,
//output data_valid,
//output reg frame_done,
//output reg [9:0] row_count,
//output reg [9:0] column_count
//    );

//reg data_valid1;
//reg flag;
//always @(posedge clk_100mhz or posedge reset)
//begin
//    if(reset)
//        begin
//            frame_done <= 0;  
//            flag <= 0; 
//        end
//    else if(frame_done == 1)
//        frame_done <= 0;
//    else if(row_count == 480 && frame_done==0 && flag==0)
//        begin
//        flag <= 1;
//        frame_done <= 1;
//        end
//    else if(row_count == 3)
//        begin
//            flag <= 0;
//        end
//    else
//        frame_done <= frame_done;
//end  
//always @(posedge pclk or posedge reset) 
//begin
//    if (reset) 
//        halfclk <= 1;
//    else
//        halfclk <= ~halfclk;
//end
//always @(posedge pclk or posedge reset)
//begin
//    if(reset)
//    begin
//        data_Y <= 0;
//        address <= 17'b11111111111111111;
//        row_count <= 0;
//        column_count <=0;
//    end
//    else
//    begin
//        if(vsync == 0 && hsync == 1)
//        begin
//            if(column_count < 320 && row_count <240)
//            begin
//                data_valid1 <= 1;
//                data_Y <= data_In;
//                column_count <= column_count+1;
//                if(halfclk)
//                    address <= address + 1;
//            end
//            else if(column_count != 639)
//            begin
//                column_count <= column_count+1;
//                data_valid1 <= 0;
//                data_Y <= 0;
//            end
//            if(column_count == 639)
//            begin
//                column_count <= 0;
//                row_count <= row_count + 1;
//            end
//        end
//        if(row_count == 480)
//        begin
//            row_count <= 0;
//            address <= 17'b11111111111111111;
//        end
//    end     
//end
//assign data_valid = data_valid1 && halfclk;
//endmodule
`timescale 1ns / 1ps
//==============================================================================
// Module : capture
//
// OV7670 -> frame-buffer write side. The camera streams a 640x480 YUV422 frame
// at the PCLK rate; one byte is a pixel field (Y0, U0, Y1, V0, ...). This
// block:
//
//   1. Divides PCLK by 2 (halfclk) so only luminance (Y) bytes are latched --
//      U/V samples fall on the other half-cycle.
//   2. Writes the first 320 Y bytes of the first 240 lines into BRAM,
//      producing a 320x240 greyscale frame (i.e. QVGA-centre from a VGA feed).
//   3. Emits a frame_done pulse when the counter hits line 480 so the
//      read-side FSM can swap direction.
//
// Ports
//   clk_100mhz   : system clock, used only for the frame_done pulse domain
//   pclk         : raw camera pixel clock
//   data_In[7:0] : current byte off the camera bus
//   vsync, hsync : camera sync; capture is gated on vsync=0 & hsync=1 (active)
//   reset        : active-high clear
//   halfclk      : PCLK/2, exposed so other blocks can see the luma tick
//   data_Y[7:0]  : latched luma byte for the frame-buffer data port
//   address      : 17-bit write address into the 320x240 BRAM
//   data_valid   : high while a Y byte is being latched
//   frame_done   : one-tick pulse at end-of-frame (capture side handoff)
//   row_count    : 10-bit vertical counter, 0..479
//   column_count : 10-bit horizontal counter, 0..639
//==============================================================================


module capture(
input clk_100mhz,
input pclk,
input [7:0] data_In,
input vsync,
input hsync,
input reset,
output reg halfclk,
output reg [7:0] data_Y,
output reg [16:0] address,
output data_valid,
output reg frame_done,
output reg [9:0] row_count,
output reg [9:0] column_count
    );

reg data_valid1;
reg flag;       // one-shot latch so frame_done stays a single clk_100mhz tick
// ---- frame_done pulse generator (system-clock domain) ---------------------
// Fires once when row_count hits 480, rearms when row_count passes 3 on the
// next frame. `flag` debounces against the frame_done self-clear.
always @(posedge clk_100mhz or posedge reset)
begin
    if(reset)
        begin
            frame_done <= 0;
            flag <= 0;
        end
    else if(frame_done == 1)
        frame_done <= 0;
    else if(row_count == 480 && frame_done==0 && flag==0)
        begin
        flag <= 1;
        frame_done <= 1;
        end
    else if(row_count == 3)
        begin
            flag <= 0;
        end
    else
        frame_done <= frame_done;
end

// ---- PCLK / 2 -- keeps only Y lanes out of the YUV422 byte stream ---------
always @(posedge pclk or posedge reset)
begin
    if (reset)
        halfclk <= 1;
    else
        halfclk <= ~halfclk;
end

// ---- 320x240 write crop, clocked on halfclk (Y bytes only) ----------------
always @(posedge halfclk or posedge reset)
begin
    if(reset)
    begin
        data_Y <= 0;
        // Seed address to all-ones so the first increment wraps to 0.
        address <= 17'b11111111111111111;
        row_count <= 0;
        column_count <=0;
    end
    else
    begin
        if(vsync == 0 && hsync == 1)                      // active video
        begin
            if(column_count < 320 && row_count <240)      // top-left 320x240 crop
            begin
                data_valid1 <= 1;
                data_Y <= data_In;
                column_count <= column_count+1;
                address <= address + 1;
            end
            else if(column_count < 639)                   // tail of the 640-wide line, drop
            begin
                column_count <= column_count+1;
                data_valid1 <= 0;
                data_Y <= 0;
            end
            if(column_count == 639)                       // end of line -> next row
            begin
                column_count <= 0;
                row_count <= row_count + 1;
            end
        end
        if(row_count == 480)                              // end of frame -> rewind
        begin
            row_count <= 0;
            address <= 17'b11111111111111111;
        end
    end
end
assign data_valid = data_valid1;
endmodule
