`timescale 1ns / 1ps
//==============================================================================
// Module : capture_starter
//
// Latches the first vsync edge coming off the OV7670 so downstream logic can
// release its own reset aligned to a real frame boundary (rather than mid-
// frame garbage if the board came up while the camera was partway through a
// line). vsync_detected goes high on the first vsync rising edge after
// `reset` is de-asserted; capture_reset mirrors reset into the camera's
// vsync clock domain.
//
// Using vsync as a clock is intentional -- it's slow (60 Hz) and only used
// to drive this handshake. Everything downstream is on clk_100mhz / pclk.
//==============================================================================


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
