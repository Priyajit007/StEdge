`timescale 1ns / 1ps
//==============================================================================
// Module : read_write_controller
//
// Ping-pong FSM arbitrating ownership of the (single-port) frame buffer
// between the camera write side and the VGA read side. There is only one
// BRAM; writer and reader take turns.
//
// States
//   start         : idle until the user asserts `en`
//   readytowrite  : waiting on capture.frame_done to kick off a write pass
//   writing       : camera streams into BRAM; leaves when frame_writing_done
//   readytoread   : waiting on vga_display.frame_done to kick off a read pass
//   reading       : VGA reads from BRAM; leaves when the next display_done
//
// `select` drives data_MUX so display output is zeroed while the buffer is
// being filled (prevents showing the previous frame mid-write). `wea` is the
// BRAM write-enable, gated by data_valid so only real Y bytes get stored.
//
// Ports
//   clk                 : system clock
//   reset               : active-high clear -> state=start
//   en                  : one-shot "start the pipeline" (mapped to SW1)
//   frame_writing_done  : pulse from capture.frame_done
//   frame_display_done  : pulse from vga_display.frame_done
//   video_on            : gates the read strobe to the visible region
//   data_valid          : gates the write strobe to actual pixel ticks
//   read_en / write_en  : gated versions of the FSM's internal strobes
//   wea                 : BRAM write-enable (also steers address_mux)
//   select              : data_MUX select (0=blank, 1=live)
//   stateinfo[2:0]      : current state, exposed for ILA / debug
//==============================================================================


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
// Read strobe only inside the visible region; write strobe only while the
// camera is emitting a real luma byte. `wea` folds the address_mux select and
// the BRAM write-enable into a single signal.
assign read_en = read_en1 && video_on;
assign write_en = write_en1 && data_valid;
assign stateinfo = state;
assign wea = write_en?1:0;
endmodule
