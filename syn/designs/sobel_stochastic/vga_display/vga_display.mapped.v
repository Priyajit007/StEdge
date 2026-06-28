/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Sun Jun 28 06:27:39 2026
/////////////////////////////////////////////////////////////


module vga_display ( clk_100mhz, p_clk, data_in, reset, hsync, vsync, rgb, 
        video_on, address, frame_done, h_count_reg, v_count_reg );
  input [7:0] data_in;
  output [11:0] rgb;
  output [16:0] address;
  output [9:0] h_count_reg;
  output [9:0] v_count_reg;
  input clk_100mhz, p_clk, reset;
  output hsync, vsync, video_on, frame_done;
  wire   flag, N37, N38, N39, N40, N41, N42, N43, N44, N45, n27, n28, n30, n31,
         n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45,
         n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59,
         n60, \DP_OP_21J1_122_3192/n40 , \DP_OP_21J1_122_3192/n37 ,
         \DP_OP_21J1_122_3192/n36 , \DP_OP_21J1_122_3192/n33 ,
         \DP_OP_21J1_122_3192/n32 , \DP_OP_21J1_122_3192/n29 ,
         \DP_OP_21J1_122_3192/n28 , \DP_OP_21J1_122_3192/n25 ,
         \DP_OP_21J1_122_3192/n24 , \DP_OP_21J1_122_3192/n23 ,
         \DP_OP_21J1_122_3192/n22 , \DP_OP_21J1_122_3192/n20 ,
         \DP_OP_21J1_122_3192/n19 , \DP_OP_21J1_122_3192/n18 ,
         \DP_OP_21J1_122_3192/n17 , \DP_OP_21J1_122_3192/n16 ,
         \DP_OP_21J1_122_3192/n15 , \DP_OP_21J1_122_3192/n14 ,
         \DP_OP_21J1_122_3192/n13 , \DP_OP_21J1_122_3192/n12 ,
         \DP_OP_21J1_122_3192/n11 , \DP_OP_21J1_122_3192/n8 ,
         \DP_OP_21J1_122_3192/n7 , \DP_OP_21J1_122_3192/n6 ,
         \DP_OP_21J1_122_3192/n5 , \DP_OP_21J1_122_3192/n4 ,
         \DP_OP_21J1_122_3192/n3 , \DP_OP_21J1_122_3192/n2 , n61, n62, n63,
         n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77,
         n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91,
         n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104,
         n105, n106;
  assign rgb[3] = rgb[11];
  assign rgb[7] = rgb[11];
  assign rgb[2] = rgb[10];
  assign rgb[6] = rgb[10];
  assign rgb[1] = rgb[9];
  assign rgb[5] = rgb[9];
  assign rgb[0] = rgb[8];
  assign rgb[4] = rgb[8];
  assign h_count_reg[6] = address[5];
  assign h_count_reg[5] = address[4];
  assign h_count_reg[4] = address[3];
  assign h_count_reg[3] = address[2];
  assign h_count_reg[2] = address[1];
  assign h_count_reg[1] = address[0];

  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[0]  ( .D(n59), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n59) );
  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[1]  ( .D(N37), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n58) );
  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[2]  ( .D(N38), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n57) );
  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[3]  ( .D(N39), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n56) );
  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[4]  ( .D(N40), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n55) );
  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[5]  ( .D(N41), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n54) );
  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[6]  ( .D(N42), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n53) );
  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[7]  ( .D(N43), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n52) );
  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[8]  ( .D(N44), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n51) );
  DFFASRHQNx1_ASAP7_75t_R \h_count_reg_reg[9]  ( .D(N45), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n50) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[0]  ( .D(n49), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n48) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[1]  ( .D(n47), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n46) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[2]  ( .D(n45), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n44) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[3]  ( .D(n43), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n42) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[4]  ( .D(n41), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n40) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[5]  ( .D(n39), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n38) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[6]  ( .D(n37), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n36) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[7]  ( .D(n35), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n34) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[8]  ( .D(n33), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n32) );
  DFFASRHQNx1_ASAP7_75t_R \v_count_reg_reg[9]  ( .D(n31), .CLK(p_clk), .SETN(
        n30), .RESETN(n106), .QN(n28) );
  DFFHQNx1_ASAP7_75t_R flag_reg ( .D(n27), .CLK(clk_100mhz), .QN(flag) );
  DFFHQNx1_ASAP7_75t_R frame_done_reg ( .D(n60), .CLK(clk_100mhz), .QN(
        frame_done) );
  FAx1_ASAP7_75t_R \DP_OP_21J1_122_3192/U23  ( .A(n44), .B(n51), .CI(
        \DP_OP_21J1_122_3192/n20 ), .CON(\DP_OP_21J1_122_3192/n19 ), .SN(
        address[7]) );
  FAx1_ASAP7_75t_R \DP_OP_21J1_122_3192/U22  ( .A(\DP_OP_21J1_122_3192/n19 ), 
        .B(v_count_reg[1]), .CI(\DP_OP_21J1_122_3192/n40 ), .CON(
        \DP_OP_21J1_122_3192/n18 ), .SN(\DP_OP_21J1_122_3192/n25 ) );
  FAx1_ASAP7_75t_R \DP_OP_21J1_122_3192/U18  ( .A(\DP_OP_21J1_122_3192/n7 ), 
        .B(\DP_OP_21J1_122_3192/n8 ), .CI(\DP_OP_21J1_122_3192/n18 ), .CON(
        \DP_OP_21J1_122_3192/n17 ), .SN(address[9]) );
  FAx1_ASAP7_75t_R \DP_OP_21J1_122_3192/U17  ( .A(\DP_OP_21J1_122_3192/n36 ), 
        .B(\DP_OP_21J1_122_3192/n37 ), .CI(\DP_OP_21J1_122_3192/n17 ), .CON(
        \DP_OP_21J1_122_3192/n16 ), .SN(\DP_OP_21J1_122_3192/n24 ) );
  FAx1_ASAP7_75t_R \DP_OP_21J1_122_3192/U13  ( .A(\DP_OP_21J1_122_3192/n5 ), 
        .B(\DP_OP_21J1_122_3192/n6 ), .CI(\DP_OP_21J1_122_3192/n16 ), .CON(
        \DP_OP_21J1_122_3192/n15 ), .SN(address[11]) );
  FAx1_ASAP7_75t_R \DP_OP_21J1_122_3192/U12  ( .A(\DP_OP_21J1_122_3192/n32 ), 
        .B(\DP_OP_21J1_122_3192/n33 ), .CI(\DP_OP_21J1_122_3192/n15 ), .CON(
        \DP_OP_21J1_122_3192/n14 ), .SN(\DP_OP_21J1_122_3192/n23 ) );
  FAx1_ASAP7_75t_R \DP_OP_21J1_122_3192/U8  ( .A(\DP_OP_21J1_122_3192/n3 ), 
        .B(\DP_OP_21J1_122_3192/n4 ), .CI(\DP_OP_21J1_122_3192/n14 ), .CON(
        \DP_OP_21J1_122_3192/n13 ), .SN(address[13]) );
  FAx1_ASAP7_75t_R \DP_OP_21J1_122_3192/U7  ( .A(\DP_OP_21J1_122_3192/n28 ), 
        .B(\DP_OP_21J1_122_3192/n29 ), .CI(\DP_OP_21J1_122_3192/n13 ), .CON(
        \DP_OP_21J1_122_3192/n12 ), .SN(\DP_OP_21J1_122_3192/n22 ) );
  FAx1_ASAP7_75t_R \DP_OP_21J1_122_3192/U3  ( .A(\DP_OP_21J1_122_3192/n2 ), 
        .B(n32), .CI(\DP_OP_21J1_122_3192/n12 ), .CON(
        \DP_OP_21J1_122_3192/n11 ), .SN(address[15]) );
  INVxp33_ASAP7_75t_R U79 ( .A(n101), .Y(n94) );
  INVxp33_ASAP7_75t_R U80 ( .A(n46), .Y(v_count_reg[1]) );
  INVxp33_ASAP7_75t_R U81 ( .A(n54), .Y(address[4]) );
  AOI22xp33_ASAP7_75t_R U82 ( .A1(n32), .A2(n105), .B1(n78), .B2(
        v_count_reg[8]), .Y(n33) );
  AOI21xp33_ASAP7_75t_R U83 ( .A1(n36), .A2(n100), .B(n99), .Y(n37) );
  AOI21xp33_ASAP7_75t_R U84 ( .A1(n40), .A2(n98), .B(n97), .Y(n41) );
  AOI22xp33_ASAP7_75t_R U85 ( .A1(n48), .A2(n92), .B1(n94), .B2(v_count_reg[0]), .Y(n49) );
  AOI21xp33_ASAP7_75t_R U86 ( .A1(n53), .A2(n86), .B(n89), .Y(N42) );
  AOI21xp33_ASAP7_75t_R U87 ( .A1(n91), .A2(n102), .B(n101), .Y(n96) );
  AOI21xp33_ASAP7_75t_R U88 ( .A1(n55), .A2(n84), .B(n87), .Y(N40) );
  OAI21xp33_ASAP7_75t_R U89 ( .A1(\DP_OP_21J1_122_3192/n4 ), .A2(n79), .B(n28), 
        .Y(n69) );
  OAI21xp33_ASAP7_75t_R U90 ( .A1(v_count_reg[8]), .A2(v_count_reg[6]), .B(n79), .Y(\DP_OP_21J1_122_3192/n3 ) );
  AOI22xp33_ASAP7_75t_R U91 ( .A1(n42), .A2(n38), .B1(v_count_reg[5]), .B2(
        v_count_reg[3]), .Y(\DP_OP_21J1_122_3192/n36 ) );
  AOI22xp33_ASAP7_75t_R U92 ( .A1(n50), .A2(n42), .B1(v_count_reg[3]), .B2(
        h_count_reg[9]), .Y(\DP_OP_21J1_122_3192/n40 ) );
  AOI22xp33_ASAP7_75t_R U93 ( .A1(n28), .A2(n34), .B1(v_count_reg[7]), .B2(
        v_count_reg[9]), .Y(\DP_OP_21J1_122_3192/n28 ) );
  AOI22xp33_ASAP7_75t_R U94 ( .A1(n58), .A2(n59), .B1(h_count_reg[0]), .B2(
        address[0]), .Y(N37) );
  INVxp67_ASAP7_75t_R U95 ( .A(n38), .Y(v_count_reg[5]) );
  INVxp67_ASAP7_75t_R U96 ( .A(n52), .Y(h_count_reg[7]) );
  INVxp67_ASAP7_75t_R U97 ( .A(n50), .Y(h_count_reg[9]) );
  INVxp67_ASAP7_75t_R U98 ( .A(n51), .Y(h_count_reg[8]) );
  INVxp67_ASAP7_75t_R U99 ( .A(n44), .Y(v_count_reg[2]) );
  INVxp67_ASAP7_75t_R U100 ( .A(n34), .Y(v_count_reg[7]) );
  INVxp67_ASAP7_75t_R U101 ( .A(n42), .Y(v_count_reg[3]) );
  HB1xp67_ASAP7_75t_R U102 ( .A(reset), .Y(n61) );
  INVx1_ASAP7_75t_R U103 ( .A(n61), .Y(n106) );
  TIEHIx1_ASAP7_75t_R U104 ( .H(n30) );
  INVxp33_ASAP7_75t_R U105 ( .A(n59), .Y(h_count_reg[0]) );
  INVxp33_ASAP7_75t_R U106 ( .A(n58), .Y(address[0]) );
  NOR3xp33_ASAP7_75t_R U107 ( .A(n57), .B(n58), .C(n59), .Y(n85) );
  O2A1O1Ixp33_ASAP7_75t_R U108 ( .A1(n58), .A2(n59), .B(n57), .C(n85), .Y(N38)
         );
  INVxp33_ASAP7_75t_R U109 ( .A(n57), .Y(address[1]) );
  INVxp33_ASAP7_75t_R U110 ( .A(n56), .Y(address[2]) );
  NAND2xp33_ASAP7_75t_R U111 ( .A(address[2]), .B(n85), .Y(n84) );
  NOR2xp33_ASAP7_75t_R U112 ( .A(n84), .B(n55), .Y(n87) );
  AOI22xp33_ASAP7_75t_R U113 ( .A1(n52), .A2(n46), .B1(v_count_reg[1]), .B2(
        h_count_reg[7]), .Y(address[6]) );
  INVxp33_ASAP7_75t_R U114 ( .A(n36), .Y(v_count_reg[6]) );
  INVxp33_ASAP7_75t_R U115 ( .A(n48), .Y(v_count_reg[0]) );
  INVxp33_ASAP7_75t_R U116 ( .A(n28), .Y(v_count_reg[9]) );
  NAND2xp33_ASAP7_75t_R U117 ( .A(v_count_reg[5]), .B(v_count_reg[7]), .Y(
        \DP_OP_21J1_122_3192/n4 ) );
  INVxp33_ASAP7_75t_R U118 ( .A(n40), .Y(v_count_reg[4]) );
  INVxp33_ASAP7_75t_R U119 ( .A(n32), .Y(v_count_reg[8]) );
  NOR2xp33_ASAP7_75t_R U120 ( .A(v_count_reg[0]), .B(v_count_reg[1]), .Y(n83)
         );
  NOR4xp25_ASAP7_75t_R U121 ( .A(frame_done), .B(v_count_reg[2]), .C(
        v_count_reg[3]), .D(v_count_reg[9]), .Y(n63) );
  NAND2xp33_ASAP7_75t_R U122 ( .A(v_count_reg[6]), .B(v_count_reg[8]), .Y(n79)
         );
  NOR4xp25_ASAP7_75t_R U123 ( .A(flag), .B(\DP_OP_21J1_122_3192/n4 ), .C(
        v_count_reg[4]), .D(n79), .Y(n62) );
  NAND4xp25_ASAP7_75t_R U124 ( .A(n83), .B(n63), .C(n62), .D(n106), .Y(n60) );
  NAND3xp33_ASAP7_75t_R U125 ( .A(n34), .B(n32), .C(n40), .Y(n75) );
  NOR2xp33_ASAP7_75t_R U126 ( .A(n48), .B(n46), .Y(n93) );
  NAND2xp33_ASAP7_75t_R U127 ( .A(n44), .B(n93), .Y(n64) );
  NOR4xp25_ASAP7_75t_R U128 ( .A(frame_done), .B(n75), .C(v_count_reg[6]), .D(
        n64), .Y(n65) );
  NAND4xp25_ASAP7_75t_R U129 ( .A(n42), .B(n38), .C(n28), .D(n65), .Y(n67) );
  INVxp33_ASAP7_75t_R U130 ( .A(n60), .Y(n66) );
  AOI31xp33_ASAP7_75t_R U131 ( .A1(flag), .A2(n106), .A3(n67), .B(n66), .Y(n27) );
  INVxp33_ASAP7_75t_R U132 ( .A(n55), .Y(address[3]) );
  INVxp33_ASAP7_75t_R U133 ( .A(n53), .Y(address[5]) );
  OAI33xp33_ASAP7_75t_R U134 ( .A1(n55), .A2(n53), .A3(n54), .B1(address[3]), 
        .B2(address[5]), .B3(address[4]), .Y(n68) );
  NOR4xp25_ASAP7_75t_R U135 ( .A(n50), .B(n52), .C(h_count_reg[8]), .D(n68), 
        .Y(hsync) );
  NAND2xp33_ASAP7_75t_R U136 ( .A(address[4]), .B(n87), .Y(n86) );
  NOR2xp33_ASAP7_75t_R U137 ( .A(n86), .B(n53), .Y(n89) );
  O2A1O1Ixp33_ASAP7_75t_R U138 ( .A1(h_count_reg[8]), .A2(h_count_reg[7]), .B(
        h_count_reg[9]), .C(n69), .Y(video_on) );
  AND2x2_ASAP7_75t_R U139 ( .A(video_on), .B(data_in[1]), .Y(rgb[9]) );
  AND2x2_ASAP7_75t_R U140 ( .A(video_on), .B(data_in[2]), .Y(rgb[10]) );
  AND2x2_ASAP7_75t_R U141 ( .A(video_on), .B(data_in[3]), .Y(rgb[11]) );
  AND2x2_ASAP7_75t_R U142 ( .A(video_on), .B(data_in[0]), .Y(rgb[8]) );
  INVxp33_ASAP7_75t_R U143 ( .A(\DP_OP_21J1_122_3192/n25 ), .Y(address[8]) );
  NAND3xp33_ASAP7_75t_R U144 ( .A(v_count_reg[3]), .B(v_count_reg[2]), .C(n93), 
        .Y(n72) );
  INVxp33_ASAP7_75t_R U145 ( .A(n72), .Y(n71) );
  NAND3xp33_ASAP7_75t_R U146 ( .A(v_count_reg[5]), .B(v_count_reg[4]), .C(n71), 
        .Y(n76) );
  INVxp33_ASAP7_75t_R U147 ( .A(n76), .Y(n77) );
  NOR4xp25_ASAP7_75t_R U148 ( .A(address[4]), .B(address[5]), .C(
        h_count_reg[7]), .D(n50), .Y(n70) );
  NAND3xp33_ASAP7_75t_R U149 ( .A(h_count_reg[8]), .B(n87), .C(n70), .Y(n101)
         );
  NAND2xp33_ASAP7_75t_R U150 ( .A(n77), .B(n94), .Y(n100) );
  NOR3xp33_ASAP7_75t_R U151 ( .A(n36), .B(n101), .C(n76), .Y(n99) );
  NAND2xp33_ASAP7_75t_R U152 ( .A(n71), .B(n94), .Y(n98) );
  NOR3xp33_ASAP7_75t_R U153 ( .A(n40), .B(n101), .C(n72), .Y(n97) );
  NAND2xp33_ASAP7_75t_R U154 ( .A(h_count_reg[7]), .B(n89), .Y(n88) );
  NOR2xp33_ASAP7_75t_R U155 ( .A(n88), .B(n51), .Y(n73) );
  AOI211xp5_ASAP7_75t_R U156 ( .A1(n51), .A2(n88), .B(n94), .C(n73), .Y(N44)
         );
  INVxp33_ASAP7_75t_R U157 ( .A(n73), .Y(n74) );
  AOI221xp5_ASAP7_75t_R U158 ( .A1(n50), .A2(n74), .B1(h_count_reg[9]), .B2(
        n73), .C(n94), .Y(N45) );
  NOR4xp25_ASAP7_75t_R U159 ( .A(n28), .B(v_count_reg[6]), .C(v_count_reg[5]), 
        .D(n75), .Y(n80) );
  NAND4xp25_ASAP7_75t_R U160 ( .A(n83), .B(n80), .C(v_count_reg[3]), .D(
        v_count_reg[2]), .Y(n102) );
  NAND2xp33_ASAP7_75t_R U161 ( .A(n102), .B(n94), .Y(n92) );
  OR4x1_ASAP7_75t_R U162 ( .A(n92), .B(n76), .C(n36), .D(n34), .Y(n105) );
  NAND3xp33_ASAP7_75t_R U163 ( .A(n77), .B(v_count_reg[6]), .C(v_count_reg[7]), 
        .Y(n103) );
  NOR2xp33_ASAP7_75t_R U164 ( .A(n103), .B(n101), .Y(n78) );
  INVxp33_ASAP7_75t_R U165 ( .A(\DP_OP_21J1_122_3192/n24 ), .Y(address[10]) );
  INVxp33_ASAP7_75t_R U166 ( .A(\DP_OP_21J1_122_3192/n23 ), .Y(address[12]) );
  INVxp33_ASAP7_75t_R U167 ( .A(\DP_OP_21J1_122_3192/n22 ), .Y(address[14]) );
  NAND2xp33_ASAP7_75t_R U168 ( .A(h_count_reg[7]), .B(v_count_reg[1]), .Y(
        \DP_OP_21J1_122_3192/n20 ) );
  NAND2xp33_ASAP7_75t_R U169 ( .A(h_count_reg[9]), .B(v_count_reg[3]), .Y(
        \DP_OP_21J1_122_3192/n8 ) );
  NOR2xp33_ASAP7_75t_R U170 ( .A(n44), .B(n40), .Y(\DP_OP_21J1_122_3192/n37 )
         );
  NAND2xp33_ASAP7_75t_R U171 ( .A(v_count_reg[3]), .B(v_count_reg[5]), .Y(
        \DP_OP_21J1_122_3192/n6 ) );
  NOR2xp33_ASAP7_75t_R U172 ( .A(n36), .B(n40), .Y(\DP_OP_21J1_122_3192/n33 )
         );
  INVxp33_ASAP7_75t_R U173 ( .A(n79), .Y(\DP_OP_21J1_122_3192/n29 ) );
  NAND2xp33_ASAP7_75t_R U174 ( .A(v_count_reg[9]), .B(v_count_reg[7]), .Y(
        \DP_OP_21J1_122_3192/n2 ) );
  INVxp33_ASAP7_75t_R U175 ( .A(n80), .Y(n82) );
  NAND2xp33_ASAP7_75t_R U176 ( .A(n42), .B(n44), .Y(n81) );
  NOR4xp25_ASAP7_75t_R U177 ( .A(n93), .B(n83), .C(n82), .D(n81), .Y(vsync) );
  OA21x2_ASAP7_75t_R U178 ( .A1(v_count_reg[7]), .A2(v_count_reg[5]), .B(
        \DP_OP_21J1_122_3192/n4 ), .Y(\DP_OP_21J1_122_3192/n32 ) );
  AO21x1_ASAP7_75t_R U179 ( .A1(n40), .A2(n36), .B(\DP_OP_21J1_122_3192/n33 ), 
        .Y(\DP_OP_21J1_122_3192/n5 ) );
  AO21x1_ASAP7_75t_R U180 ( .A1(n40), .A2(n44), .B(\DP_OP_21J1_122_3192/n37 ), 
        .Y(\DP_OP_21J1_122_3192/n7 ) );
  HAxp5_ASAP7_75t_R U181 ( .A(n28), .B(\DP_OP_21J1_122_3192/n11 ), .SN(
        address[16]) );
  OA21x2_ASAP7_75t_R U182 ( .A1(address[2]), .A2(n85), .B(n84), .Y(N39) );
  OA211x2_ASAP7_75t_R U183 ( .A1(address[4]), .A2(n87), .B(n86), .C(n101), .Y(
        N41) );
  OA21x2_ASAP7_75t_R U184 ( .A1(h_count_reg[7]), .A2(n89), .B(n88), .Y(N43) );
  NOR2xp33_ASAP7_75t_R U185 ( .A(n48), .B(n101), .Y(n90) );
  OAI32xp33_ASAP7_75t_R U186 ( .A1(v_count_reg[1]), .A2(n48), .A3(n101), .B1(
        n46), .B2(n90), .Y(n47) );
  INVxp33_ASAP7_75t_R U187 ( .A(n93), .Y(n91) );
  OAI32xp33_ASAP7_75t_R U188 ( .A1(v_count_reg[2]), .A2(n92), .A3(n91), .B1(
        n44), .B2(n96), .Y(n45) );
  NAND4xp25_ASAP7_75t_R U189 ( .A(n42), .B(n94), .C(n93), .D(v_count_reg[2]), 
        .Y(n95) );
  A2O1A1Ixp33_ASAP7_75t_R U190 ( .A1(n96), .A2(v_count_reg[2]), .B(n42), .C(
        n95), .Y(n43) );
  OAI32xp33_ASAP7_75t_R U191 ( .A1(v_count_reg[5]), .A2(n40), .A3(n98), .B1(
        n38), .B2(n97), .Y(n39) );
  OAI32xp33_ASAP7_75t_R U192 ( .A1(v_count_reg[7]), .A2(n36), .A3(n100), .B1(
        n34), .B2(n99), .Y(n35) );
  O2A1O1Ixp33_ASAP7_75t_R U193 ( .A1(n32), .A2(n103), .B(n102), .C(n101), .Y(
        n104) );
  OAI32xp33_ASAP7_75t_R U194 ( .A1(v_count_reg[9]), .A2(n32), .A3(n105), .B1(
        n28), .B2(n104), .Y(n31) );
endmodule

