/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Sun Jun 28 06:29:28 2026
/////////////////////////////////////////////////////////////


module capture_starter ( vsync, reset, vsync_detected, capture_reset );
  input vsync, reset;
  output vsync_detected, capture_reset;
  wire   n1;

  DFFHQNx1_ASAP7_75t_R capture_reset_reg ( .D(n1), .CLK(vsync), .QN(
        capture_reset) );
  INVxp33_ASAP7_75t_R U4 ( .A(capture_reset), .Y(vsync_detected) );
  INVxp33_ASAP7_75t_R U3 ( .A(reset), .Y(n1) );
endmodule

