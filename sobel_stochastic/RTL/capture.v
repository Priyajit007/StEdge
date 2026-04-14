//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 17.04.2025 09:53:37
//// Design Name: 
//// Module Name: capture
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2025 09:53:37
// Design Name: 
// Module Name: capture
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
reg flag;
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

always @(posedge pclk or posedge reset) 
begin
    if (reset) 
        halfclk <= 1;
    else
        halfclk <= ~halfclk;
end

always @(posedge halfclk or posedge reset)
begin
    if(reset)
    begin
        data_Y <= 0;
        address <= 17'b11111111111111111;
        row_count <= 0;
        column_count <=0;
    end
    else
    begin
        if(vsync == 0 && hsync == 1)
        begin
            if(column_count < 320 && row_count <240)
            begin
                data_valid1 <= 1;
                data_Y <= data_In;
                column_count <= column_count+1;
                address <= address + 1;
            end
            else if(column_count < 639)
            begin
                column_count <= column_count+1;
                data_valid1 <= 0;
                data_Y <= 0;
            end
            if(column_count == 639)
            begin
                column_count <= 0;
                row_count <= row_count + 1;
            end
        end
        if(row_count == 480)
        begin
            row_count <= 0;
            address <= 17'b11111111111111111;
        end
    end     
end
assign data_valid = data_valid1;
endmodule
