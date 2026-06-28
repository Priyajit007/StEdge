/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Sun Jun 28 06:24:06 2026
/////////////////////////////////////////////////////////////


module capture ( clk_100mhz, pclk, data_In, vsync, hsync, reset, halfclk, 
        data_Y, address, data_valid, frame_done, row_count, column_count );
  input [7:0] data_In;
  output [7:0] data_Y;
  output [16:0] address;
  output [9:0] row_count;
  output [9:0] column_count;
  input clk_100mhz, pclk, vsync, hsync, reset;
  output halfclk, data_valid, frame_done;
  wire   n33, n34, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75,
         n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89,
         n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102,
         n103, n104, n105, n106, n107, n108, n109, n110, n111, n112, n113,
         n114, n115, n116, n117, n118, n119, n120, n121, n122, n123, n124,
         n125, n126, n127, n128, n129, n130, n131, n132, n133, n134, n135,
         n136, n137, n138, n139, n140, n141, n142, n143, n144, n145, n146,
         n147, n148, n149, n150, n151, n152, n153, n154, n155, n156, n157,
         n158, n159, n160, n161, n162, n163, n164, n165, n166, n167, n168,
         n169, n170, n171, n172, n173, n174, n175, n176, n177, n178, n179,
         n180, n181, n182, n183, n184, n185, n186, n187, n188, n189, n190,
         n191, n192, n193, n194, n195, n196, n197, n198, n199, n200, n201,
         n202, n203, n204, n205, n206, n207, n208, n209;

  DFFASRHQNx1_ASAP7_75t_R halfclk_reg ( .D(halfclk), .CLK(pclk), .SETN(n36), 
        .RESETN(n209), .QN(halfclk) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[0]  ( .D(n82), .CLK(halfclk), .SETN(n36), .RESETN(n113), .QN(address[0]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[16]  ( .D(n81), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(address[16]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[15]  ( .D(n80), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(address[15]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[14]  ( .D(n79), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(address[14]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[13]  ( .D(n78), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(address[13]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[12]  ( .D(n77), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(address[12]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[11]  ( .D(n76), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(address[11]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[10]  ( .D(n75), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(address[10]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[9]  ( .D(n74), .CLK(halfclk), .SETN(n36), .RESETN(n209), .QN(address[9]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[8]  ( .D(n73), .CLK(halfclk), .SETN(n36), .RESETN(n209), .QN(address[8]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[7]  ( .D(n72), .CLK(halfclk), .SETN(n36), .RESETN(n209), .QN(address[7]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[6]  ( .D(n71), .CLK(halfclk), .SETN(n36), .RESETN(n209), .QN(address[6]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[5]  ( .D(n70), .CLK(halfclk), .SETN(n36), .RESETN(n209), .QN(address[5]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[4]  ( .D(n69), .CLK(halfclk), .SETN(n36), .RESETN(n209), .QN(address[4]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[3]  ( .D(n68), .CLK(halfclk), .SETN(n36), .RESETN(n209), .QN(address[3]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[2]  ( .D(n67), .CLK(halfclk), .SETN(n36), .RESETN(n209), .QN(address[2]) );
  DFFASRHQNx1_ASAP7_75t_R \address_reg[1]  ( .D(n66), .CLK(halfclk), .SETN(n36), .RESETN(n209), .QN(address[1]) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[0]  ( .D(n112), .CLK(halfclk), 
        .SETN(n36), .RESETN(n209), .QN(n65) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[9]  ( .D(n102), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(n64) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[0]  ( .D(n111), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(n63) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[1]  ( .D(n110), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(n62) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[2]  ( .D(n109), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(n61) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[3]  ( .D(n108), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(n60) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[4]  ( .D(n107), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(n59) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[5]  ( .D(n106), .CLK(halfclk), .SETN(
        n36), .RESETN(n113), .QN(n58) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[6]  ( .D(n105), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(n57) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[7]  ( .D(n104), .CLK(halfclk), .SETN(
        n36), .RESETN(n113), .QN(n56) );
  DFFASRHQNx1_ASAP7_75t_R \row_count_reg[8]  ( .D(n103), .CLK(halfclk), .SETN(
        n36), .RESETN(n209), .QN(n55) );
  DFFASRHQNx1_ASAP7_75t_R flag_reg ( .D(n100), .CLK(clk_100mhz), .SETN(n36), 
        .RESETN(n113), .QN(n54) );
  DFFASRHQNx1_ASAP7_75t_R frame_done_reg ( .D(n101), .CLK(clk_100mhz), .SETN(
        n36), .RESETN(n113), .QN(n53) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[1]  ( .D(n99), .CLK(halfclk), 
        .SETN(n36), .RESETN(n113), .QN(n52) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[2]  ( .D(n98), .CLK(halfclk), 
        .SETN(n36), .RESETN(n209), .QN(n51) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[3]  ( .D(n97), .CLK(halfclk), 
        .SETN(n36), .RESETN(n113), .QN(n50) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[4]  ( .D(n96), .CLK(halfclk), 
        .SETN(n36), .RESETN(n209), .QN(n49) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[5]  ( .D(n95), .CLK(halfclk), 
        .SETN(n36), .RESETN(n113), .QN(n48) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[6]  ( .D(n94), .CLK(halfclk), 
        .SETN(n36), .RESETN(n113), .QN(n47) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[7]  ( .D(n93), .CLK(halfclk), 
        .SETN(n36), .RESETN(n113), .QN(n46) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[8]  ( .D(n92), .CLK(halfclk), 
        .SETN(n36), .RESETN(n209), .QN(n45) );
  DFFASRHQNx1_ASAP7_75t_R \column_count_reg[9]  ( .D(n91), .CLK(halfclk), 
        .SETN(n36), .RESETN(n113), .QN(n44) );
  DFFASRHQNx1_ASAP7_75t_R \data_Y_reg[7]  ( .D(n90), .CLK(halfclk), .SETN(n36), 
        .RESETN(n209), .QN(n43) );
  DFFASRHQNx1_ASAP7_75t_R \data_Y_reg[6]  ( .D(n89), .CLK(halfclk), .SETN(n36), 
        .RESETN(n113), .QN(n42) );
  DFFASRHQNx1_ASAP7_75t_R \data_Y_reg[5]  ( .D(n88), .CLK(halfclk), .SETN(n36), 
        .RESETN(n113), .QN(n41) );
  DFFASRHQNx1_ASAP7_75t_R \data_Y_reg[4]  ( .D(n87), .CLK(halfclk), .SETN(n36), 
        .RESETN(n113), .QN(n40) );
  DFFASRHQNx1_ASAP7_75t_R \data_Y_reg[3]  ( .D(n86), .CLK(halfclk), .SETN(n36), 
        .RESETN(n209), .QN(n39) );
  DFFASRHQNx1_ASAP7_75t_R \data_Y_reg[2]  ( .D(n85), .CLK(halfclk), .SETN(n36), 
        .RESETN(n113), .QN(n38) );
  DFFASRHQNx1_ASAP7_75t_R \data_Y_reg[1]  ( .D(n84), .CLK(halfclk), .SETN(n36), 
        .RESETN(n209), .QN(n37) );
  DFFASRHQNx1_ASAP7_75t_R \data_Y_reg[0]  ( .D(n83), .CLK(halfclk), .SETN(n36), 
        .RESETN(n113), .QN(n34) );
  DFFHQNx1_ASAP7_75t_R data_valid1_reg ( .D(n33), .CLK(halfclk), .QN(
        data_valid) );
  INVxp33_ASAP7_75t_R U114 ( .A(n63), .Y(row_count[0]) );
  INVxp33_ASAP7_75t_R U115 ( .A(reset), .Y(n113) );
  INVx1_ASAP7_75t_R U116 ( .A(n141), .Y(n209) );
  TIEHIx1_ASAP7_75t_R U117 ( .H(n36) );
  INVxp33_ASAP7_75t_R U118 ( .A(n113), .Y(n141) );
  INVxp33_ASAP7_75t_R U119 ( .A(n59), .Y(row_count[4]) );
  INVxp33_ASAP7_75t_R U120 ( .A(n58), .Y(row_count[5]) );
  INVxp33_ASAP7_75t_R U121 ( .A(n55), .Y(row_count[8]) );
  INVxp33_ASAP7_75t_R U122 ( .A(address[8]), .Y(n202) );
  NOR2xp33_ASAP7_75t_R U123 ( .A(n56), .B(n57), .Y(n176) );
  INVxp33_ASAP7_75t_R U124 ( .A(hsync), .Y(n114) );
  NOR2xp33_ASAP7_75t_R U125 ( .A(n114), .B(vsync), .Y(n149) );
  NAND4xp25_ASAP7_75t_R U126 ( .A(n44), .B(n149), .C(n64), .D(n55), .Y(n115)
         );
  AOI31xp33_ASAP7_75t_R U127 ( .A1(n176), .A2(row_count[4]), .A3(row_count[5]), 
        .B(n115), .Y(n116) );
  A2O1A1Ixp33_ASAP7_75t_R U128 ( .A1(n47), .A2(n46), .B(n45), .C(n116), .Y(
        n199) );
  AND4x1_ASAP7_75t_R U129 ( .A(address[0]), .B(address[1]), .C(address[2]), 
        .D(address[3]), .Y(n142) );
  AND3x1_ASAP7_75t_R U130 ( .A(n142), .B(address[4]), .C(address[5]), .Y(n132)
         );
  NAND3xp33_ASAP7_75t_R U131 ( .A(n132), .B(address[6]), .C(address[7]), .Y(
        n117) );
  NOR2xp33_ASAP7_75t_R U132 ( .A(n199), .B(n117), .Y(n204) );
  INVxp33_ASAP7_75t_R U133 ( .A(n204), .Y(n203) );
  NOR2xp33_ASAP7_75t_R U134 ( .A(n202), .B(n203), .Y(n122) );
  NAND2xp33_ASAP7_75t_R U135 ( .A(address[9]), .B(n122), .Y(n121) );
  INVxp33_ASAP7_75t_R U136 ( .A(n121), .Y(n136) );
  NAND2xp33_ASAP7_75t_R U137 ( .A(n136), .B(address[10]), .Y(n135) );
  INVxp33_ASAP7_75t_R U138 ( .A(n135), .Y(n120) );
  INVxp33_ASAP7_75t_R U139 ( .A(n176), .Y(n119) );
  NAND3xp33_ASAP7_75t_R U140 ( .A(n64), .B(n61), .C(n60), .Y(n182) );
  NAND4xp25_ASAP7_75t_R U141 ( .A(n59), .B(n62), .C(row_count[8]), .D(
        row_count[5]), .Y(n118) );
  NOR4xp25_ASAP7_75t_R U142 ( .A(n119), .B(n182), .C(row_count[0]), .D(n118), 
        .Y(n207) );
  NAND2xp33_ASAP7_75t_R U143 ( .A(address[11]), .B(n120), .Y(n123) );
  OAI31xp33_ASAP7_75t_R U144 ( .A1(address[11]), .A2(n120), .A3(n207), .B(n123), .Y(n76) );
  OAI31xp33_ASAP7_75t_R U145 ( .A1(address[9]), .A2(n122), .A3(n207), .B(n121), 
        .Y(n74) );
  INVxp33_ASAP7_75t_R U146 ( .A(n123), .Y(n126) );
  NAND2xp33_ASAP7_75t_R U147 ( .A(n126), .B(address[12]), .Y(n125) );
  INVxp33_ASAP7_75t_R U148 ( .A(n125), .Y(n128) );
  NAND2xp33_ASAP7_75t_R U149 ( .A(n128), .B(address[13]), .Y(n127) );
  INVxp33_ASAP7_75t_R U150 ( .A(n127), .Y(n130) );
  NAND2xp33_ASAP7_75t_R U151 ( .A(n130), .B(address[14]), .Y(n129) );
  INVxp33_ASAP7_75t_R U152 ( .A(n129), .Y(n124) );
  NAND2xp33_ASAP7_75t_R U153 ( .A(n124), .B(address[15]), .Y(n137) );
  OAI31xp33_ASAP7_75t_R U154 ( .A1(n124), .A2(address[15]), .A3(n207), .B(n137), .Y(n80) );
  OAI31xp33_ASAP7_75t_R U155 ( .A1(n126), .A2(address[12]), .A3(n207), .B(n125), .Y(n77) );
  OAI31xp33_ASAP7_75t_R U156 ( .A1(n128), .A2(address[13]), .A3(n207), .B(n127), .Y(n78) );
  OAI31xp33_ASAP7_75t_R U157 ( .A1(n130), .A2(address[14]), .A3(n207), .B(n129), .Y(n79) );
  INVxp33_ASAP7_75t_R U158 ( .A(n199), .Y(n201) );
  NAND3xp33_ASAP7_75t_R U159 ( .A(n201), .B(n132), .C(address[6]), .Y(n133) );
  INVxp33_ASAP7_75t_R U160 ( .A(n133), .Y(n131) );
  OAI31xp33_ASAP7_75t_R U161 ( .A1(address[7]), .A2(n207), .A3(n131), .B(n203), 
        .Y(n72) );
  NAND2xp33_ASAP7_75t_R U162 ( .A(n201), .B(n132), .Y(n143) );
  INVxp33_ASAP7_75t_R U163 ( .A(n143), .Y(n134) );
  OAI31xp33_ASAP7_75t_R U164 ( .A1(address[6]), .A2(n207), .A3(n134), .B(n133), 
        .Y(n71) );
  OAI31xp33_ASAP7_75t_R U165 ( .A1(n136), .A2(address[10]), .A3(n207), .B(n135), .Y(n75) );
  INVxp33_ASAP7_75t_R U166 ( .A(n137), .Y(n139) );
  NAND2xp33_ASAP7_75t_R U167 ( .A(n139), .B(address[16]), .Y(n138) );
  OAI31xp33_ASAP7_75t_R U168 ( .A1(n139), .A2(address[16]), .A3(n207), .B(n138), .Y(n81) );
  INVxp33_ASAP7_75t_R U169 ( .A(n50), .Y(column_count[3]) );
  INVxp33_ASAP7_75t_R U170 ( .A(n51), .Y(column_count[2]) );
  INVxp33_ASAP7_75t_R U171 ( .A(n52), .Y(column_count[1]) );
  INVxp33_ASAP7_75t_R U172 ( .A(n65), .Y(column_count[0]) );
  INVxp33_ASAP7_75t_R U173 ( .A(n48), .Y(column_count[5]) );
  INVxp33_ASAP7_75t_R U174 ( .A(n45), .Y(column_count[8]) );
  INVxp33_ASAP7_75t_R U175 ( .A(n46), .Y(column_count[7]) );
  NAND4xp25_ASAP7_75t_R U176 ( .A(column_count[3]), .B(column_count[2]), .C(
        column_count[1]), .D(column_count[0]), .Y(n155) );
  NOR2xp33_ASAP7_75t_R U177 ( .A(n49), .B(n155), .Y(n190) );
  NAND2xp33_ASAP7_75t_R U178 ( .A(n190), .B(column_count[5]), .Y(n158) );
  NOR2xp33_ASAP7_75t_R U179 ( .A(n47), .B(n158), .Y(n193) );
  INVxp33_ASAP7_75t_R U180 ( .A(n193), .Y(n194) );
  NOR2xp33_ASAP7_75t_R U181 ( .A(column_count[8]), .B(column_count[7]), .Y(
        n150) );
  A2O1A1Ixp33_ASAP7_75t_R U182 ( .A1(n194), .A2(n150), .B(n44), .C(n149), .Y(
        n198) );
  AND2x2_ASAP7_75t_R U183 ( .A(n201), .B(n209), .Y(n140) );
  O2A1O1Ixp33_ASAP7_75t_R U184 ( .A1(n198), .A2(n141), .B(data_valid), .C(n140), .Y(n33) );
  INVxp33_ASAP7_75t_R U185 ( .A(address[4]), .Y(n205) );
  NAND2xp33_ASAP7_75t_R U186 ( .A(n201), .B(n142), .Y(n206) );
  NOR2xp33_ASAP7_75t_R U187 ( .A(n205), .B(n206), .Y(n144) );
  OAI31xp33_ASAP7_75t_R U188 ( .A1(address[5]), .A2(n207), .A3(n144), .B(n143), 
        .Y(n70) );
  INVxp33_ASAP7_75t_R U189 ( .A(address[2]), .Y(n147) );
  INVxp33_ASAP7_75t_R U190 ( .A(n207), .Y(n160) );
  AOI31xp33_ASAP7_75t_R U191 ( .A1(n201), .A2(address[0]), .A3(address[1]), 
        .B(n207), .Y(n146) );
  AOI21xp33_ASAP7_75t_R U192 ( .A1(n147), .A2(n160), .B(n146), .Y(n145) );
  OAI21xp33_ASAP7_75t_R U193 ( .A1(address[3]), .A2(n145), .B(n206), .Y(n68)
         );
  NAND3xp33_ASAP7_75t_R U194 ( .A(n201), .B(address[0]), .C(address[1]), .Y(
        n161) );
  INVxp33_ASAP7_75t_R U195 ( .A(n146), .Y(n148) );
  AOI22xp33_ASAP7_75t_R U196 ( .A1(address[2]), .A2(n161), .B1(n148), .B2(n147), .Y(n67) );
  INVxp33_ASAP7_75t_R U197 ( .A(n44), .Y(column_count[9]) );
  INVxp33_ASAP7_75t_R U198 ( .A(n198), .Y(n191) );
  NAND4xp25_ASAP7_75t_R U199 ( .A(n193), .B(n150), .C(n149), .D(
        column_count[9]), .Y(n178) );
  INVxp33_ASAP7_75t_R U200 ( .A(n178), .Y(n169) );
  NOR2xp33_ASAP7_75t_R U201 ( .A(n191), .B(n169), .Y(n156) );
  INVxp33_ASAP7_75t_R U202 ( .A(n156), .Y(n196) );
  AOI22xp33_ASAP7_75t_R U203 ( .A1(n65), .A2(n198), .B1(n196), .B2(
        column_count[0]), .Y(n112) );
  NAND2xp33_ASAP7_75t_R U204 ( .A(n160), .B(n169), .Y(n164) );
  AOI22xp33_ASAP7_75t_R U205 ( .A1(n63), .A2(n164), .B1(n169), .B2(
        row_count[0]), .Y(n111) );
  INVxp33_ASAP7_75t_R U206 ( .A(n62), .Y(row_count[1]) );
  NAND2xp33_ASAP7_75t_R U207 ( .A(row_count[1]), .B(row_count[0]), .Y(n181) );
  NOR3xp33_ASAP7_75t_R U208 ( .A(n61), .B(n178), .C(n181), .Y(n165) );
  O2A1O1Ixp33_ASAP7_75t_R U209 ( .A1(n181), .A2(n164), .B(n61), .C(n165), .Y(
        n109) );
  INVxp33_ASAP7_75t_R U210 ( .A(n57), .Y(row_count[6]) );
  NOR3xp33_ASAP7_75t_R U211 ( .A(n61), .B(n60), .C(n181), .Y(n168) );
  NAND2xp33_ASAP7_75t_R U212 ( .A(n168), .B(row_count[4]), .Y(n151) );
  NOR2xp33_ASAP7_75t_R U213 ( .A(n58), .B(n151), .Y(n175) );
  INVxp33_ASAP7_75t_R U214 ( .A(n164), .Y(n174) );
  NAND2xp33_ASAP7_75t_R U215 ( .A(n175), .B(n174), .Y(n173) );
  A2O1A1Ixp33_ASAP7_75t_R U216 ( .A1(n169), .A2(n175), .B(n207), .C(
        row_count[6]), .Y(n152) );
  INVxp33_ASAP7_75t_R U217 ( .A(n152), .Y(n172) );
  AOI21xp33_ASAP7_75t_R U218 ( .A1(n57), .A2(n173), .B(n172), .Y(n105) );
  NAND2xp33_ASAP7_75t_R U219 ( .A(n176), .B(n175), .Y(n177) );
  OAI31xp33_ASAP7_75t_R U220 ( .A1(n178), .A2(n55), .A3(n177), .B(n160), .Y(
        n153) );
  O2A1O1Ixp33_ASAP7_75t_R U221 ( .A1(n178), .A2(n177), .B(n55), .C(n153), .Y(
        n103) );
  NAND3xp33_ASAP7_75t_R U222 ( .A(n191), .B(column_count[1]), .C(
        column_count[0]), .Y(n188) );
  NAND2xp33_ASAP7_75t_R U223 ( .A(n196), .B(column_count[0]), .Y(n186) );
  NOR3xp33_ASAP7_75t_R U224 ( .A(n51), .B(n52), .C(n186), .Y(n187) );
  AOI21xp33_ASAP7_75t_R U225 ( .A1(n51), .A2(n188), .B(n187), .Y(n98) );
  INVxp33_ASAP7_75t_R U226 ( .A(n49), .Y(column_count[4]) );
  OAI21xp33_ASAP7_75t_R U227 ( .A1(n155), .A2(n156), .B(column_count[4]), .Y(
        n154) );
  OAI31xp33_ASAP7_75t_R U228 ( .A1(n155), .A2(column_count[4]), .A3(n198), .B(
        n154), .Y(n96) );
  INVxp33_ASAP7_75t_R U229 ( .A(n47), .Y(column_count[6]) );
  OAI21xp33_ASAP7_75t_R U230 ( .A1(n158), .A2(n156), .B(column_count[6]), .Y(
        n157) );
  OAI31xp33_ASAP7_75t_R U231 ( .A1(n158), .A2(column_count[6]), .A3(n198), .B(
        n157), .Y(n94) );
  NAND3xp33_ASAP7_75t_R U232 ( .A(n193), .B(n191), .C(column_count[7]), .Y(
        n195) );
  NAND2xp33_ASAP7_75t_R U233 ( .A(column_count[9]), .B(n178), .Y(n159) );
  OAI21xp33_ASAP7_75t_R U234 ( .A1(n45), .A2(n195), .B(n159), .Y(n91) );
  INVxp33_ASAP7_75t_R U235 ( .A(n38), .Y(data_Y[2]) );
  INVxp33_ASAP7_75t_R U236 ( .A(n39), .Y(data_Y[3]) );
  INVxp33_ASAP7_75t_R U237 ( .A(n61), .Y(row_count[2]) );
  INVxp33_ASAP7_75t_R U238 ( .A(n60), .Y(row_count[3]) );
  INVxp33_ASAP7_75t_R U239 ( .A(n64), .Y(row_count[9]) );
  INVxp33_ASAP7_75t_R U240 ( .A(n40), .Y(data_Y[4]) );
  INVxp33_ASAP7_75t_R U241 ( .A(n34), .Y(data_Y[0]) );
  INVxp33_ASAP7_75t_R U242 ( .A(n37), .Y(data_Y[1]) );
  INVxp33_ASAP7_75t_R U243 ( .A(n43), .Y(data_Y[7]) );
  INVxp33_ASAP7_75t_R U244 ( .A(n41), .Y(data_Y[5]) );
  INVxp33_ASAP7_75t_R U245 ( .A(n42), .Y(data_Y[6]) );
  NAND3xp33_ASAP7_75t_R U246 ( .A(n207), .B(n54), .C(n53), .Y(n183) );
  INVxp33_ASAP7_75t_R U247 ( .A(n183), .Y(n101) );
  INVxp33_ASAP7_75t_R U248 ( .A(n56), .Y(row_count[7]) );
  INVxp33_ASAP7_75t_R U249 ( .A(n53), .Y(frame_done) );
  INVxp33_ASAP7_75t_R U250 ( .A(address[0]), .Y(n200) );
  OAI21xp33_ASAP7_75t_R U251 ( .A1(n200), .A2(n199), .B(n160), .Y(n162) );
  OAI21xp33_ASAP7_75t_R U252 ( .A1(address[1]), .A2(n162), .B(n161), .Y(n66)
         );
  NOR2xp33_ASAP7_75t_R U253 ( .A(n63), .B(n178), .Y(n163) );
  OAI32xp33_ASAP7_75t_R U254 ( .A1(row_count[1]), .A2(n63), .A3(n178), .B1(n62), .B2(n163), .Y(n110) );
  OR2x2_ASAP7_75t_R U255 ( .A(n181), .B(n164), .Y(n166) );
  OAI32xp33_ASAP7_75t_R U256 ( .A1(row_count[3]), .A2(n61), .A3(n166), .B1(n60), .B2(n165), .Y(n108) );
  NAND2xp33_ASAP7_75t_R U257 ( .A(n168), .B(n174), .Y(n167) );
  AOI32xp33_ASAP7_75t_R U258 ( .A1(n169), .A2(row_count[4]), .A3(n168), .B1(
        n59), .B2(n167), .Y(n107) );
  NAND3xp33_ASAP7_75t_R U259 ( .A(n169), .B(n168), .C(row_count[4]), .Y(n171)
         );
  INVxp33_ASAP7_75t_R U260 ( .A(n171), .Y(n170) );
  AOI221xp5_ASAP7_75t_R U261 ( .A1(n58), .A2(n171), .B1(row_count[5]), .B2(
        n170), .C(n207), .Y(n106) );
  OAI32xp33_ASAP7_75t_R U262 ( .A1(row_count[7]), .A2(n57), .A3(n173), .B1(n56), .B2(n172), .Y(n104) );
  NAND3xp33_ASAP7_75t_R U263 ( .A(n176), .B(n175), .C(n174), .Y(n180) );
  NOR3xp33_ASAP7_75t_R U264 ( .A(n55), .B(n178), .C(n177), .Y(n179) );
  OAI32xp33_ASAP7_75t_R U265 ( .A1(row_count[9]), .A2(n55), .A3(n180), .B1(n64), .B2(n179), .Y(n102) );
  NOR4xp25_ASAP7_75t_R U266 ( .A(row_count[4]), .B(row_count[5]), .C(
        row_count[8]), .D(frame_done), .Y(n185) );
  NOR4xp25_ASAP7_75t_R U267 ( .A(row_count[7]), .B(row_count[6]), .C(n182), 
        .D(n181), .Y(n184) );
  A2O1A1Ixp33_ASAP7_75t_R U268 ( .A1(n185), .A2(n184), .B(n54), .C(n183), .Y(
        n100) );
  AO32x1_ASAP7_75t_R U269 ( .A1(n191), .A2(n52), .A3(column_count[0]), .B1(
        column_count[1]), .B2(n186), .Y(n99) );
  OAI32xp33_ASAP7_75t_R U270 ( .A1(column_count[3]), .A2(n51), .A3(n188), .B1(
        n50), .B2(n187), .Y(n97) );
  NAND3xp33_ASAP7_75t_R U271 ( .A(n48), .B(n190), .C(n191), .Y(n189) );
  A2O1A1Ixp33_ASAP7_75t_R U272 ( .A1(n190), .A2(n196), .B(n48), .C(n189), .Y(
        n95) );
  NAND3xp33_ASAP7_75t_R U273 ( .A(n46), .B(n193), .C(n191), .Y(n192) );
  A2O1A1Ixp33_ASAP7_75t_R U274 ( .A1(n193), .A2(n196), .B(n46), .C(n192), .Y(
        n93) );
  NOR2xp33_ASAP7_75t_R U275 ( .A(n46), .B(n194), .Y(n197) );
  AOI32xp33_ASAP7_75t_R U276 ( .A1(n197), .A2(column_count[8]), .A3(n196), 
        .B1(n45), .B2(n195), .Y(n92) );
  AO22x1_ASAP7_75t_R U277 ( .A1(data_In[7]), .A2(n201), .B1(n198), .B2(
        data_Y[7]), .Y(n90) );
  AO22x1_ASAP7_75t_R U278 ( .A1(data_In[6]), .A2(n201), .B1(n198), .B2(
        data_Y[6]), .Y(n89) );
  AO22x1_ASAP7_75t_R U279 ( .A1(data_In[5]), .A2(n201), .B1(n198), .B2(
        data_Y[5]), .Y(n88) );
  AO22x1_ASAP7_75t_R U280 ( .A1(data_In[4]), .A2(n201), .B1(n198), .B2(
        data_Y[4]), .Y(n87) );
  AO22x1_ASAP7_75t_R U281 ( .A1(data_In[3]), .A2(n201), .B1(n198), .B2(
        data_Y[3]), .Y(n86) );
  AO22x1_ASAP7_75t_R U282 ( .A1(data_In[2]), .A2(n201), .B1(n198), .B2(
        data_Y[2]), .Y(n85) );
  AO22x1_ASAP7_75t_R U283 ( .A1(data_In[1]), .A2(n201), .B1(n198), .B2(
        data_Y[1]), .Y(n84) );
  AO22x1_ASAP7_75t_R U284 ( .A1(data_In[0]), .A2(n201), .B1(n198), .B2(
        data_Y[0]), .Y(n83) );
  OAI32xp33_ASAP7_75t_R U285 ( .A1(n201), .A2(address[0]), .A3(n207), .B1(n200), .B2(n199), .Y(n82) );
  OAI32xp33_ASAP7_75t_R U286 ( .A1(address[8]), .A2(n204), .A3(n207), .B1(n203), .B2(n202), .Y(n73) );
  INVxp33_ASAP7_75t_R U287 ( .A(n206), .Y(n208) );
  OAI32xp33_ASAP7_75t_R U288 ( .A1(address[4]), .A2(n208), .A3(n207), .B1(n206), .B2(n205), .Y(n69) );
endmodule

