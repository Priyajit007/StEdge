/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Sun Jul 12 13:36:58 2026
/////////////////////////////////////////////////////////////


module read_write_controller ( clk, reset, en, frame_writing_done, 
        frame_display_done, write_en, read_en, video_on, select, stateinfo, 
        wea, data_valid );
  output [2:0] stateinfo;
  input clk, reset, en, frame_writing_done, frame_display_done, video_on,
         data_valid;
  output write_en, read_en, select, wea;
  wire   write_en, read_en1, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21,
         n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35;
  assign wea = write_en;
  assign select = read_en1;

  DFFASRHQNx1_ASAP7_75t_R \state_reg[0]  ( .D(n23), .CLK(clk), .SETN(n14), 
        .RESETN(n13), .QN(n18) );
  DFFASRHQNx1_ASAP7_75t_R \state_reg[2]  ( .D(n21), .CLK(clk), .SETN(n14), 
        .RESETN(n13), .QN(n17) );
  DFFASRHQNx1_ASAP7_75t_R \state_reg[1]  ( .D(n22), .CLK(clk), .SETN(n14), 
        .RESETN(n13), .QN(n16) );
  DFFASRHQNx1_ASAP7_75t_R read_en1_reg ( .D(n20), .CLK(clk), .SETN(n14), 
        .RESETN(n13), .QN(n15) );
  DFFASRHQNx1_ASAP7_75t_R write_en1_reg ( .D(n19), .CLK(clk), .SETN(n14), 
        .RESETN(n13), .QN(n12) );
  INVxp33_ASAP7_75t_R U27 ( .A(n33), .Y(n34) );
  INVxp33_ASAP7_75t_R U28 ( .A(n18), .Y(stateinfo[0]) );
  AOI21xp33_ASAP7_75t_R U29 ( .A1(n15), .A2(n29), .B(n26), .Y(n20) );
  OAI22xp33_ASAP7_75t_R U30 ( .A1(n25), .A2(n24), .B1(n18), .B2(n29), .Y(n21)
         );
  INVxp67_ASAP7_75t_R U31 ( .A(n15), .Y(read_en1) );
  INVxp67_ASAP7_75t_R U32 ( .A(n17), .Y(stateinfo[2]) );
  INVxp67_ASAP7_75t_R U33 ( .A(n16), .Y(stateinfo[1]) );
  NAND2xp5_ASAP7_75t_R U34 ( .A(n16), .B(frame_writing_done), .Y(n30) );
  INVxp67_ASAP7_75t_R U35 ( .A(data_valid), .Y(n32) );
  TIEHIx1_ASAP7_75t_R U36 ( .H(n14) );
  INVxp33_ASAP7_75t_R U37 ( .A(reset), .Y(n13) );
  NAND3xp33_ASAP7_75t_R U38 ( .A(n16), .B(frame_writing_done), .C(stateinfo[2]), .Y(n31) );
  NOR2xp33_ASAP7_75t_R U39 ( .A(stateinfo[0]), .B(n31), .Y(n25) );
  AOI31xp33_ASAP7_75t_R U40 ( .A1(n18), .A2(n16), .A3(en), .B(stateinfo[2]), 
        .Y(n24) );
  NAND3xp33_ASAP7_75t_R U41 ( .A(n17), .B(frame_display_done), .C(stateinfo[1]), .Y(n29) );
  NOR2xp33_ASAP7_75t_R U42 ( .A(n18), .B(n29), .Y(n26) );
  NAND2xp33_ASAP7_75t_R U43 ( .A(frame_display_done), .B(stateinfo[1]), .Y(n27) );
  AOI211xp5_ASAP7_75t_R U44 ( .A1(n30), .A2(n27), .B(n18), .C(stateinfo[2]), 
        .Y(n28) );
  AOI31xp33_ASAP7_75t_R U45 ( .A1(n18), .A2(n31), .A3(n29), .B(n28), .Y(n23)
         );
  NOR3xp33_ASAP7_75t_R U46 ( .A(n18), .B(stateinfo[2]), .C(n30), .Y(n33) );
  O2A1O1Ixp33_ASAP7_75t_R U47 ( .A1(n31), .A2(stateinfo[0]), .B(n12), .C(n33), 
        .Y(n19) );
  NOR2xp33_ASAP7_75t_R U48 ( .A(n12), .B(n32), .Y(write_en) );
  AND2x2_ASAP7_75t_R U49 ( .A(video_on), .B(read_en1), .Y(read_en) );
  NOR2xp33_ASAP7_75t_R U50 ( .A(n18), .B(stateinfo[2]), .Y(n35) );
  A2O1A1Ixp33_ASAP7_75t_R U51 ( .A1(n35), .A2(frame_display_done), .B(n16), 
        .C(n34), .Y(n22) );
endmodule

