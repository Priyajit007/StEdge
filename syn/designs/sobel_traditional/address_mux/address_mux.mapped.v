/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Sun Jul 12 13:35:04 2026
/////////////////////////////////////////////////////////////


module address_mux ( rd_add, wr_add, wea, add );
  input [16:0] rd_add;
  input [16:0] wr_add;
  output [16:0] add;
  input wea;
  wire   n2, n3;

  HB1xp67_ASAP7_75t_R U19 ( .A(wea), .Y(n2) );
  INVx1_ASAP7_75t_R U20 ( .A(n2), .Y(n3) );
  AO22x1_ASAP7_75t_R U21 ( .A1(wea), .A2(wr_add[0]), .B1(n3), .B2(rd_add[0]), 
        .Y(add[0]) );
  AO22x1_ASAP7_75t_R U22 ( .A1(wea), .A2(wr_add[1]), .B1(n3), .B2(rd_add[1]), 
        .Y(add[1]) );
  AO22x1_ASAP7_75t_R U23 ( .A1(wea), .A2(wr_add[2]), .B1(n3), .B2(rd_add[2]), 
        .Y(add[2]) );
  AO22x1_ASAP7_75t_R U24 ( .A1(wea), .A2(wr_add[3]), .B1(n3), .B2(rd_add[3]), 
        .Y(add[3]) );
  AO22x1_ASAP7_75t_R U25 ( .A1(wea), .A2(wr_add[4]), .B1(n3), .B2(rd_add[4]), 
        .Y(add[4]) );
  AO22x1_ASAP7_75t_R U26 ( .A1(wea), .A2(wr_add[5]), .B1(n3), .B2(rd_add[5]), 
        .Y(add[5]) );
  AO22x1_ASAP7_75t_R U27 ( .A1(wea), .A2(wr_add[6]), .B1(n3), .B2(rd_add[6]), 
        .Y(add[6]) );
  AO22x1_ASAP7_75t_R U28 ( .A1(wea), .A2(wr_add[7]), .B1(n3), .B2(rd_add[7]), 
        .Y(add[7]) );
  AO22x1_ASAP7_75t_R U29 ( .A1(wea), .A2(wr_add[8]), .B1(n3), .B2(rd_add[8]), 
        .Y(add[8]) );
  AO22x1_ASAP7_75t_R U30 ( .A1(wea), .A2(wr_add[9]), .B1(n3), .B2(rd_add[9]), 
        .Y(add[9]) );
  AO22x1_ASAP7_75t_R U31 ( .A1(wea), .A2(wr_add[10]), .B1(n3), .B2(rd_add[10]), 
        .Y(add[10]) );
  AO22x1_ASAP7_75t_R U32 ( .A1(wea), .A2(wr_add[11]), .B1(n3), .B2(rd_add[11]), 
        .Y(add[11]) );
  AO22x1_ASAP7_75t_R U33 ( .A1(wea), .A2(wr_add[12]), .B1(n3), .B2(rd_add[12]), 
        .Y(add[12]) );
  AO22x1_ASAP7_75t_R U34 ( .A1(wea), .A2(wr_add[13]), .B1(n3), .B2(rd_add[13]), 
        .Y(add[13]) );
  AO22x1_ASAP7_75t_R U35 ( .A1(wea), .A2(wr_add[14]), .B1(n3), .B2(rd_add[14]), 
        .Y(add[14]) );
  AO22x1_ASAP7_75t_R U36 ( .A1(wea), .A2(wr_add[15]), .B1(n3), .B2(rd_add[15]), 
        .Y(add[15]) );
  AO22x1_ASAP7_75t_R U37 ( .A1(wea), .A2(wr_add[16]), .B1(n3), .B2(rd_add[16]), 
        .Y(add[16]) );
endmodule

