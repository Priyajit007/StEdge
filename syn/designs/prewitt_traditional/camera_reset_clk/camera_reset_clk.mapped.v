/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Sun Jul 12 13:38:48 2026
/////////////////////////////////////////////////////////////


module camera_reset_clk ( reset, clk, xclk, camera_reset, crst );
  input reset, clk, crst;
  output xclk, camera_reset;
  wire   xclk;
  assign xclk = clk;

  INVxp33_ASAP7_75t_R U1 ( .A(crst), .Y(camera_reset) );
endmodule

