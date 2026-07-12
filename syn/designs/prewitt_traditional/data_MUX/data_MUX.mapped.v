/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Sun Jul 12 13:40:40 2026
/////////////////////////////////////////////////////////////


module data_MUX ( select, din, dout );
  input [7:0] din;
  output [7:0] dout;
  input select;


  AND2x2_ASAP7_75t_R U10 ( .A(select), .B(din[0]), .Y(dout[0]) );
  AND2x2_ASAP7_75t_R U11 ( .A(select), .B(din[6]), .Y(dout[6]) );
  AND2x2_ASAP7_75t_R U12 ( .A(select), .B(din[5]), .Y(dout[5]) );
  AND2x2_ASAP7_75t_R U13 ( .A(select), .B(din[4]), .Y(dout[4]) );
  AND2x2_ASAP7_75t_R U14 ( .A(select), .B(din[7]), .Y(dout[7]) );
  AND2x2_ASAP7_75t_R U15 ( .A(select), .B(din[3]), .Y(dout[3]) );
  AND2x2_ASAP7_75t_R U16 ( .A(select), .B(din[2]), .Y(dout[2]) );
  AND2x2_ASAP7_75t_R U17 ( .A(select), .B(din[1]), .Y(dout[1]) );
endmodule

