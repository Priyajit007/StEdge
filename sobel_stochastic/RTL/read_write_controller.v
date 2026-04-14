`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2025 12:17:18
// Design Name: 
// Module Name: read_write_controller
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


module read_write_controller(
input clk,
input reset,
input en,
input frame_writing_done,
input frame_display_done,
output wire write_en,
output wire read_en,
input video_on,
output reg select,
output wire [2:0] stateinfo,
output wea,
input data_valid
    );
parameter start=0,writing=1,readytoread=2,reading=3,readytowrite=4;
reg [2:0] state;
reg read_en1,write_en1;
always @(posedge clk or posedge reset)
begin
    if(reset)
        begin
            state <= start;
            read_en1 <= 0;
            write_en1 <= 0;
            select <= 0;
        end
    else
    begin
        case(state)
                start :  begin
                            if(en)
                            begin
                                state <= readytowrite;
                            end
                            else
                            begin
                                state <= start;
                            end
                        end
             writing :  begin
                           if(frame_writing_done)
                            begin
                                state <= readytoread;
                                write_en1 <= 0;
                            end
                            else
                            begin
                                state <= writing;
                            end
                        end
             readytoread :  begin
                                if(frame_display_done)
                                begin
                                    state <= reading;
                                    read_en1 <= 1;
                                    select <= 1;
                                end
                                else
                                begin
                                    state <= readytoread;
                                end 
                            end
             reading :  begin
                            if(frame_display_done)
                            begin
                                state <= readytowrite;
                                read_en1 <= 0;
                                select <= 0;
                            end
                            else
                            begin
                                state <= reading;
                            end
                        end
             readytowrite :  begin
                                if(frame_writing_done)
                                begin
                                    state <= writing;
                                    write_en1 <= 1;
                                end  
                                else
                                begin
                                    state <= readytowrite;
                                end 
                             end 
            endcase
    end
end
assign read_en = read_en1 && video_on;
assign write_en = write_en1 && data_valid;
assign stateinfo = state;
assign wea = write_en?1:0;
endmodule
