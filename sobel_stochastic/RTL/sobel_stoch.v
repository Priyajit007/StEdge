`timescale 1ns / 1ps
//==============================================================================
// Module : sobel_stoch  (Sobel variant)
//
// Stochastic-domain Sobel edge detector. Fetches a 3x3 pixel neighbourhood out
// of the frame-buffer BRAM, converts each pixel to an 8-bit unary/thermometer
// bit-stream, then computes |Gx| + |Gy| using:
//
//   * XOR gates as stochastic subtractors on correlated bit-streams, and
//   * deterministic bit-interleaved concatenation as the scaled adder that
//     replaces the MUX/accumulator tree of a conventional implementation.
//
// The [-1 -2 -1 / 0 0 0 / +1 +2 +1] (Sobel) weighting is baked into the two-
// stage concat of m1{x,y}/m2{x,y} -> d{x,y}, where the middle-row difference
// "bx"/"by" is doubled by appearing in both interleave stages. The Prewitt
// sibling replaces the duplicated slots with 1'b0 because its kernel is
// uniformly weighted.
//
// Ports
//   clk        : capture-side pixel clock -- drives the fetch FSM tick
//   clk_100mhz : system clock; clocks the address micro-sequencer
//   reset      : active-high clear for the fetch FSM and row/col counters
//   video_on   : from vga_display -- gates compute to the visible region
//   data_in    : 8-bit pixel byte coming back from the frame buffer
//   frame_done : end-of-frame pulse from vga_display (kept in the port list
//                for the block-design wiring; not used in this body)
//   address    : 17-bit BRAM read address (320x240 = 76800 window)
//   pix_out    : 8-bit edge-magnitude back to the VGA path via data_MUX
//
// Paper reference: Section 3 (architecture), Eqs. (7)-(10) for the concat
// adder; thermometer encoding in pix_stoch() is the "unary SC" of Section 2.
//==============================================================================


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
// ---- 3x3 neighbourhood buffers -------------------------------------------
// d_prev / d_curr / d_next : raw 8-bit pixels fetched from BRAM (rows r-1,r,r+1)
// d_*_stoch                : same pixel after thermometer encoding
// O[row][col]              : 3x3 register window; shifts left every clk tick
reg [7:0] d_prev;
reg [7:0] d_curr;
reg [7:0] d_next;
reg [7:0] d_prev_stoch;
reg [7:0] d_curr_stoch;
reg [7:0] d_next_stoch;
reg [7:0] O [0:2][0:2];
integer col_count;
integer row_count;
// Column-wise stochastic subtractions (XOR on correlated bit-streams).
reg [7:0] ax,bx,cx; // ax = p2 ^ p0, bx = p5 ^ p3, cx = p8 ^ p6;  (Gx rows)
// Row-wise stochastic subtractions.
reg [7:0] ay,by,cy; // ay = p0 ^ p6, by = p1 ^ p7, cy = p2 ^ p8;  (Gy rows)
// m1/m2/d : deterministic-concatenation adder stages (paper Eq. 9/10).
// res_reg : final |Gx|+|Gy| magnitude, rescaled from 4-bit popcount back to 8 bits.
reg [7:0] m1x,m2x,m1y,m2y,dx,dy,res_reg;
reg flag;         // "fetch in progress" guard for the 3-beat address micro-sequencer
reg [1:0] counter;// 0->prev, 1->curr, 2->next (BRAM read beats)
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
// ---- BRAM fetch micro-sequencer ------------------------------------------
// Uses both the pixel clock ('clk') and the system clock ('clk_100mhz') as
// edges so the read can happen between pixel ticks. Synthesises fine but does
// NOT simulate cleanly without a testbench that serialises these two edges.
always @(posedge clk_100mhz or posedge clk or posedge reset)
begin
    if(reset)
    begin
        flag <= 0;
        counter <= 0;
    end
    else if(clk && !flag)
    begin
        // Start of a new 3x3 fetch: issue row (r-1) address.
        flag <= 1;
        counter <= 2'b00;
        address <= address1;
    end
    else if(counter == 0)
    begin
        // data_in now carries pixel from row (r-1); queue the r'th address.
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
        // Last beat: latch row (r+1) and rearm the guard for the next column.
        d_next <= data_in;
        counter <= counter + 1;
        flag <= 0;
        address <= address1;
    end
end

// ---- Compute pipeline (runs in the visible region, one column / tick) ----
always @(posedge clk) // Computation pipeline
if (shift_en&&video_on&&!reset) begin
//    d_prev <= total_memory[(col_count+640*(row_count-1))%sizeOfLengthReal];
//    d_curr <= total_memory[(col_count+640*row_count)%sizeOfLengthReal];
//    d_next <= total_memory[(col_count+640*(row_count+1))%sizeOfLengthReal];
    // 8-bit pixel -> 8-bit unary / thermometer bit-stream (see pix_stoch below).
    d_prev_stoch = pix_stoch(d_prev);
    d_curr_stoch = pix_stoch(d_curr);
    d_next_stoch = pix_stoch(d_next);
    // 3x3 shift-register window: shift each row left, insert the new column.
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
    // Stochastic-domain subtractions: XOR of two thermometer streams.
    // Gx differences across the three rows:
    ax = O[0][0] ^O[0][2];   // top row    : p2 - p0
    bx = O[1][0] ^O[1][2];   // middle row : p5 - p3   (Sobel weight x2)
    cx = O[2][0] ^O[2][2];   // bottom row : p8 - p6
    // Gy differences across the three columns:
    ay = O[0][0] ^O[2][0];   // left col
    by = O[0][1] ^O[2][1];   // middle col (Sobel weight x2)
    cy = O[0][2] ^O[2][2];   // right col

    // First interleave stage: ax/cx rows doubled via bx in the even slots --
    // this is the deterministic-concatenation adder (paper Eq. 9). Two inputs
    // get summed into one byte whose mean probability is (p1 + p2)/2.
    m1x   = {ax[7],bx[6],ax[5],bx[4],ax[3],bx[2],ax[1],bx[0]};
    m2x   = {cx[7],bx[6],cx[5],bx[4],cx[3],bx[2],cx[1],bx[0]};
    m1y   = {ay[7],by[6],ay[5],by[4],ay[3],by[2],ay[1],by[0]};
    m2y   = {cy[7],by[6],cy[5],by[4],cy[3],by[2],cy[1],by[0]};

    // Second interleave stage: fold m1 and m2 together -> |Gx| / |Gy|.
    dx    <= {m1x[7],m2x[6],m1x[5],m2x[4],m1x[3],m2x[2],m1x[1],m2x[0]};
    dy    <= {m1y[7],m2y[6],m1y[5],m2y[4],m1y[3],m2y[2],m1y[1],m2y[0]};

    // Popcount of eight concatenated stochastic bits, rescaled by 31 to bring
    // the 0..8 range back into a visible 0..248 greyscale span.
    res_reg    <= (((dx[7]+dy[6])+(dx[5]+dy[4]))+((dx[3]+dy[2])+(dx[1]+dy[0])))*31;
    
end
// Column counter, 0..639 (VGA horizontal). Starts at 4 after reset because
// the first three columns can't form a valid 3x3 window yet.
always @(posedge clk) begin
    if(reset)
        col_count <= 4;
    else if(video_on)
        col_count <= (col_count + 1<=639)?col_count+1:0;
end

// Row counter, 0..479 (VGA vertical); increments at column wrap-around.
always @(posedge clk) begin
    if(reset)
        row_count <= 0;
    else if(video_on)
       row_count<= (col_count + 1<=639)?row_count:(row_count+1<=479)?row_count+1:0;
end

// pix_stoch: 8-bit pixel -> 8-bit thermometer encoding. Bit k is set when
// pix >= 32*k, so the number of '1's approximates pix/32. This is the cheap
// unary generator used throughout the stochastic pipeline -- no LFSR needed.
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

// Compute only when the row window has valid top/bottom neighbours.
assign shift_en = (row_count>=1&&row_count<=478);
//assign valid_pix=((col_count-4>=1 || col_count+636<=638)&&shift_en)?1:0;
assign valid_pix = 1;
assign pix_out = valid_pix?res_reg:8'b0;

// Pixel-doubling: BRAM is 320x240, VGA walks 640x480. Divide both counters
// by two so 2x2 VGA cells map to one stored pixel.
assign address1 = (col_count/2)+320*((row_count-1)/2);
assign address2 = (col_count/2)+320*(row_count/2);
assign address3 = (col_count/2)+320*((row_count+1)/2);
   
endmodule
