/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

// See Xilinx UG953 and UG474 for a description of the cell types below.
// http://www.xilinx.com/support/documentation/user_guides/ug474_7Series_CLB.pdf
// http://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_4/ug953-vivado-7series-libraries.pdf

module VCC(output P);
  assign P = 1;
endmodule

module GND(output G);
  assign G = 0;
endmodule

module IBUF(output O, input I);
  assign O = I;
endmodule

module OBUF(output O, input I);
  assign O = I;
endmodule

module BUFG(output O, input I);
  assign O = I;
endmodule

// module OBUFT(output O, input I, T);
//   assign O = T ? 1'bz : I;
// endmodule

// module IOBUF(inout IO, output O, input I, T);
//   assign O = IO, IO = T ? 1'bz : I;
// endmodule

module INV(output O, input I);
  assign O = !I;
endmodule

module LUT1(output O, input I0);
  parameter [1:0] INIT = 0;
  assign O = I0 ? INIT[1] : INIT[0];
endmodule

module LUT2(output O, input I0, I1);
  parameter [3:0] INIT = 0;
  wire [ 1: 0] s1 = I1 ? INIT[ 3: 2] : INIT[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
endmodule

module LUT3(output O, input I0, I1, I2);
  parameter [7:0] INIT = 0;
  wire [ 3: 0] s2 = I2 ? INIT[ 7: 4] : INIT[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
endmodule

module LUT4(output O, input I0, I1, I2, I3);
  parameter [15:0] INIT = 0;
  wire [ 7: 0] s3 = I3 ? INIT[15: 8] : INIT[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
endmodule

module LUT5(output O, input I0, I1, I2, I3, I4);
  parameter [31:0] INIT = 0;
  wire [15: 0] s4 = I4 ? INIT[31:16] : INIT[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
endmodule

module LUT6(output O, input I0, I1, I2, I3, I4, I5);
  parameter [63:0] INIT = 0;
  wire [31: 0] s5 = I5 ? INIT[63:32] : INIT[31: 0];
  wire [15: 0] s4 = I4 ?   s5[31:16] :   s5[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
endmodule

module MUXF7(output O, input I0, I1, S);
  assign O = S ? I1 : I0;
endmodule

module MUXF8(output O, input I0, I1, S);
  assign O = S ? I1 : I0;
endmodule

module MUXCY(output O, input CI, DI, S);
  assign O = S ? CI : DI;
endmodule

module XORCY(output O, input CI, LI);
  assign O = CI ^ LI;
endmodule

module CARRY4(output [3:0] CO, O, input CI, CYINIT, input [3:0] DI, S);
  assign O = S ^ {CO[2:0], CYINIT | CI};
  assign CO[0] = S[0] ? CI | CYINIT : DI[0];
  assign CO[1] = S[1] ? CO[0] : DI[1];
  assign CO[2] = S[2] ? CO[1] : DI[2];
  assign CO[3] = S[3] ? CO[2] : DI[3];
endmodule

`ifdef _EXPLICIT_CARRY

module CARRY0(output CO_CHAIN, CO_FABRIC, O, input CI, CI_INIT, DI, S);
  parameter CYINIT_FABRIC = 0;
  wire CI_COMBINE;
  if(CYINIT_FABRIC) begin
    assign CI_COMBINE = CI_INIT;
  end else begin
    assign CI_COMBINE = CI;
  end
  assign CO_CHAIN = S ? CI_COMBINE : DI;
  assign CO_FABRIC = S ? CI_COMBINE : DI;
  assign O = S ^ CI_COMBINE;
endmodule

module CARRY(output CO_CHAIN, CO_FABRIC, O, input CI, DI, S);
  assign CO_CHAIN = S ? CI : DI;
  assign CO_FABRIC = S ? CI : DI;
  assign O = S ^ CI;
endmodule

`endif

module FDRE (output reg Q, input C, CE, D, R);
  parameter [0:0] INIT = 1'b0;
  initial Q <= INIT;
  always @(posedge C) if (R) Q <= 1'b0; else if(CE) Q <= D;
endmodule

module FDSE (output reg Q, input C, CE, D, S);
  parameter [0:0] INIT = 1'b1;
  initial Q <= INIT;
  always @(posedge C) if (S) Q <= 1'b1; else if(CE) Q <= D;
endmodule

module FDCE (output reg Q, input C, CE, D, CLR);
  parameter [0:0] INIT = 1'b0;
  initial Q <= INIT;
  always @(posedge C, posedge CLR) if (CLR) Q <= 1'b0; else if (CE) Q <= D;
endmodule

module FDPE (output reg Q, input C, CE, D, PRE);
  parameter [0:0] INIT = 1'b1;
  initial Q <= INIT;
  always @(posedge C, posedge PRE) if (PRE) Q <= 1'b1; else if (CE) Q <= D;
endmodule

module RAM32X1D (
  output DPO, SPO,
  input  D, WCLK, WE,
  input  A0, A1, A2, A3, A4,
  input  DPRA0, DPRA1, DPRA2, DPRA3, DPRA4
);
  parameter INIT = 32'h0;
  wire [4:0] a = {A4, A3, A2, A1, A0};
  wire [4:0] dpra = {DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};
  reg [31:0] mem;
  initial mem <= INIT;
  assign SPO = mem[a];
  assign DPO = mem[dpra];
  wire clk = WCLK;
  always @(posedge clk) if (WE) mem[a] <= D;
endmodule


module RAM64X1D (
  output DPO, SPO,
  input  D, WCLK, WE,
  input  A0, A1, A2, A3, A4, A5,
  input  DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, DPRA5
);
  parameter INIT = 64'h0;
  wire [5:0] a = {A5, A4, A3, A2, A1, A0};
  wire [5:0] dpra = {DPRA5, DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};
  reg [63:0] mem;
  initial mem <= INIT;
  assign SPO = mem[a];
  assign DPO = mem[dpra];
  wire clk = WCLK;
  always @(posedge clk) if (WE) mem[a] <= D;
endmodule

module RAM128X1D (
  output       DPO, SPO,
  input        D, WCLK, WE,
  input  [6:0] A, DPRA
);
  parameter INIT = 128'h0;
  reg [127:0] mem;
  initial mem <= INIT;
  assign SPO = mem[A];
  assign DPO = mem[DPRA];
  wire clk = WCLK;
  always @(posedge clk) if (WE) mem[A] <= D;
endmodule

