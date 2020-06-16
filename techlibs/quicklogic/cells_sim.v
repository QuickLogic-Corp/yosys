//                FZ        FS
module LUT1(output O, input I0);
    parameter [1:0] INIT = 0;
    assign O = I0 ? INIT[1] : INIT[0];
endmodule

//               TZ        TSL TAB
module LUT2(output O, input I0, I1);
    parameter [3:0] INIT = 0;
    assign O = INIT[{I1, I0}];
endmodule

// O:  TZ
// I0: TA1 TA2 TB1 TB2
// I1: TSL
// I2: TAB
module LUT3(output O, input I0, I1, I2);
    parameter [7:0] INIT = 0;
    assign O = INIT[{I2, I1, I0}];
endmodule

// O:  CZ
// I0: TA1 TA2 TB1 TB2 BA1 BA2 BB1 BB2
// I1: TSL BSL
// I2: TAB BAB
// I3: TBS
module LUT4(output O, input I0, I1, I2, I3);
    parameter [15:0] INIT = 0;
    assign O = INIT[{I3, I2, I1, I0}];
endmodule

//               FZ       FS
module inv(output Q, input A);
    assign Q = A ? 0 : 1;
endmodule

module buff(output Q, input A);
    assign Q = A;
endmodule

module dff(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input CLK
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;
	
    always @(posedge CLK)
        Q <= D;
endmodule

module dffc(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input CLK,
    (* clkbuf_sink *)
    input CLR
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

    always @(posedge CLK or posedge CLR)
        if (CLR)
            Q <= 1'b0;
        else
            Q <= D;
endmodule

module dffp(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input CLK,
    (* clkbuf_sink *)
    input PRE
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

    always @(posedge CLK or posedge PRE)
        if (PRE)
            Q <= 1'b1;
        else
            Q <= D;
endmodule

module dffpc(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input CLK,
    (* clkbuf_sink *)
    input CLR,
    (* clkbuf_sink *)
    input PRE
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

    always @(posedge CLK or posedge CLR or posedge PRE)
        if (CLR)
            Q <= 1'b0;
        else if (PRE)
            Q <= 1'b1;
        else
            Q <= D;
endmodule

module dffe(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input CLK,
    input EN
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;
	
    always @(posedge CLK)
        if (EN)
            Q <= D;
endmodule

module dffec(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input CLK,
    input EN,
    (* clkbuf_sink *)
    input CLR
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

    always @(posedge CLK or posedge CLR)
        if (CLR)
            Q <= 1'b0;
        else if (EN)
            Q <= D;
endmodule

module dffepc(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input CLK,
    input EN,
    (* clkbuf_sink *)
    input CLR,
    (* clkbuf_sink *)
    input PRE
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

    always @(posedge CLK or posedge CLR or posedge PRE)
        if (CLR)
            Q <= 1'b0;
        else if (PRE)
            Q <= 1'b1;
        else if (EN)
            Q <= D;
endmodule

//FZ       FS F2 (F1 TO 0)
module AND2I0(output Q, input A, B);
    assign Q = A ? B : 0;
endmodule

// FZ       FS F1 F2
module mux2x0(output Q, input S, A, B);
    assign Q = S ? B : A;
endmodule

//FZ       FS F1 F2
module mux2x1(output Q, input S, A, B);
    assign Q = S ? B : A;
endmodule

// TZ       TSL TABTA1TA2TB1TB2 
module mux4x0(output Q, input S0, S1, A, B, C, D);
    assign Q = S1 ? (S0 ? D : C) : (S0 ? B : A);
endmodule

// S0 BSL TSL
// S1 BAB TAB
// S2 TBS
// A TA1
// B TA2
// C TB1
// D TB2
// E BA1
// F BA2
// G BB1
// H BB2
// Q CZ
module mux8x0(output Q, input S0, S1, S2, A, B, C, D, E, F, G, H);
    assign Q = S2 ? (S1 ? (S0 ? H : G) : (S0 ? F : E)) : (S1 ? (S0 ? D : C) : (S0 ? B : A));
endmodule

module inpad(output Q, input P);
    assign Q = P;
endmodule

module outpad(output P, input A);
    assign P = A;
endmodule

module ckpad(output Q, input P);
    assign Q = P;
endmodule

module bipad(input A, input EN, output Q, inout P);
    assign Q = P;
    assign P = EN ? A : 1'bz;
endmodule

module logic_0(output a);
    assign a = 0;
endmodule

module logic_1(output a);
    assign a = 1;
endmodule

module logic_cell_macro(
    input BA1,
    input BA2,
    input BAB,
    input BAS1,
    input BAS2,
    input BB1,
    input BB2,
    input BBS1,
    input BBS2,
    input BSL,
    input F1,
    input F2,
    input FS,
    input QCK,
    input QCKS,
    input QDI,
    input QDS,
    input QEN,
    input QRT,
    input QST,
    input TA1,
    input TA2,
    input TAB,
    input TAS1,
    input TAS2,
    input TB1,
    input TB2,
    input TBS,
    input TBS1,
    input TBS2,
    input TSL,
    output CZ,
    output FZ,
    output QZ,
    output TZ
);

    wire TAP1,TAP2,TBP1,TBP2,BAP1,BAP2,BBP1,BBP2,QCKP,TAI,TBI,BAI,BBI,TZI,BZI,CZI,QZI;
    reg QZ_r;
	
	initial
	begin
		QZ_r=1'b0;
	end

	assign QZ = QZ_r;
    assign TAP1 = TAS1 ? ~TA1 : TA1; 
    assign TAP2 = TAS2 ? ~TA2 : TA2; 
    assign TBP1 = TBS1 ? ~TB1 : TB1; 
    assign TBP2 = TBS2 ? ~TB2 : TB2;
    assign BAP1 = BAS1 ? ~BA1 : BA1;
    assign BAP2 = BAS2 ? ~BA2 : BA2;
    assign BBP1 = BBS1 ? ~BB1 : BB1;
    assign BBP2 = BBS2 ? ~BB2 : BB2;

    assign TAI = TSL ? TAP2 : TAP1;
    assign TBI = TSL ? TBP2 : TBP1;
    assign BAI = BSL ? BAP2 : BAP1;
    assign BBI = BSL ? BBP2 : BBP1;
    assign TZI = TAB ? TBI : TAI;
    assign BZI = BAB ? BBI : BAI;
    assign CZI = TBS ? BZI : TZI;
    assign QZI = QDS ? QDI : CZI ;
    assign FZ = FS ? F2 : F1;
    assign TZ = TZI;
    assign CZ = CZI;
    assign QCKP = QCKS ? QCK : ~QCK;

    always @(posedge QCKP or posedge QRT or posedge QST)
        if (QRT)
            QZ_r <= 1'b0;
        else if (QST)
            QZ_r <= 1'b1;
        else
            QZ_r <= QZI;

endmodule

// BLACK BOXES

(* blackbox *)
(* keep *)
module qlal4s3b_cell_macro(
    input	WB_CLK,
    input	WBs_ACK,
    input	[31:0]WBs_RD_DAT,
    output	[3:0]WBs_BYTE_STB,
    output	WBs_CYC,
    output	WBs_WE,
    output	WBs_RD,
    output	WBs_STB,
    output	[16:0]WBs_ADR,
    input	[3:0]SDMA_Req,
    input	[3:0]SDMA_Sreq,
    output	[3:0]SDMA_Done,
    output	[3:0]SDMA_Active,
    input	[3:0]FB_msg_out,
    input	[7:0]FB_Int_Clr,
    output	FB_Start,
    input	FB_Busy,
    output	WB_RST,
    output	Sys_PKfb_Rst,
    output	Sys_Clk0,
    output	Sys_Clk0_Rst,
    output	Sys_Clk1,
    output	Sys_Clk1_Rst,
    output	Sys_Pclk,
    output	Sys_Pclk_Rst,
    input	Sys_PKfb_Clk,
    input	[31:0]FB_PKfbData,
    output	[31:0]WBs_WR_DAT,
    input	[3:0]FB_PKfbPush,
    input	FB_PKfbSOF,
    input	FB_PKfbEOF,
    output	[7:0]Sensor_Int,
    output	FB_PKfbOverflow,
    output	[23:0]TimeStamp,
    input	Sys_PSel,
    input	[15:0]SPIm_Paddr,
    input	SPIm_PEnable,
    input	SPIm_PWrite,
    input	[31:0]SPIm_PWdata,
    output	SPIm_PReady,
    output	SPIm_PSlvErr,
    output	[31:0]SPIm_Prdata,
    input	[15:0]Device_ID,
    input	[13:0]FBIO_In_En,
    input	[13:0]FBIO_Out,
    input	[13:0]FBIO_Out_En,
    output	[13:0]FBIO_In,
    inout 	[13:0]SFBIO,
    input   Device_ID_6S,
    input   Device_ID_4S,
    input   SPIm_PWdata_26S,
    input   SPIm_PWdata_24S,
    input   SPIm_PWdata_14S,
    input   SPIm_PWdata_11S,
    input   SPIm_PWdata_0S,
    input   SPIm_Paddr_8S,
    input   SPIm_Paddr_6S,
    input   FB_PKfbPush_1S,
    input   FB_PKfbData_31S,
    input   FB_PKfbData_21S,
    input   FB_PKfbData_19S,
    input   FB_PKfbData_9S,
    input   FB_PKfbData_6S,
    input   Sys_PKfb_ClkS,
    input   FB_BusyS,
    input   WB_CLKS);
	
	
qlal4s3b_cell_macro_bfm	 u_ASSP_bfm_inst(
		.WBs_ADR     (WBs_ADR),
        .WBs_CYC     (WBs_CYC),
        .WBs_BYTE_STB(WBs_BYTE_STB),
        .WBs_WE      (WBs_WE),
        .WBs_RD      (WBs_RD), 
        .WBs_STB     (WBs_STB),
        .WBs_WR_DAT  (WBs_WR_DAT),
        .WB_CLK      (WB_CLK),
        .WB_RST      (WB_RST),
        .WBs_RD_DAT  (WBs_RD_DAT),
        .WBs_ACK     (WBs_ACK),
        //
        // SDMA Signals
        //
        .SDMA_Req     (SDMA_Req),
        .SDMA_Sreq    (SDMA_Sreq),
        .SDMA_Done    (SDMA_Done),
        .SDMA_Active  (SDMA_Active),
        //
        // FB Interrupts
        //
        .FB_msg_out    (FB_msg_out),
        .FB_Int_Clr    (FB_Int_Clr),
        .FB_Start      (FB_Start),
        .FB_Busy       (FB_Busy),
        //
        // FB Clocks
        //
        .Sys_Clk0      (Sys_Clk0),
        .Sys_Clk0_Rst  (Sys_Clk0_Rst),
        .Sys_Clk1      (Sys_Clk1),
        .Sys_Clk1_Rst  (Sys_Clk1_Rst),
        //
        // Packet FIFO
        //
        .Sys_PKfb_Clk     (Sys_PKfb_Clk),
        .Sys_PKfb_Rst     (Sys_PKfb_Rst),
        .FB_PKfbData      (FB_PKfbData),
        .FB_PKfbPush      (FB_PKfbPush),
        .FB_PKfbSOF       (FB_PKfbSOF),
        .FB_PKfbEOF       (FB_PKfbEOF),
        .FB_PKfbOverflow  (FB_PKfbOverflow),
        //
        // Sensor Interface
        //
        .Sensor_Int       (Sensor_Int),
        .TimeStamp        (TimeStamp),
        //
        // SPI Master APB Bus
        //
        .Sys_Pclk        (Sys_Pclk),
        .Sys_Pclk_Rst    (Sys_Pclk_Rst),
        .Sys_PSel        (Sys_PSel),
        .SPIm_Paddr      (SPIm_Paddr),
        .SPIm_PEnable    (SPIm_PEnable),
        .SPIm_PWrite     (SPIm_PWrite),
        .SPIm_PWdata     (SPIm_PWdata),
        .SPIm_Prdata     (SPIm_Prdata),
        .SPIm_PReady     (SPIm_PReady),
        .SPIm_PSlvErr    (SPIm_PSlvErr),
        //
        // Misc
        //
        .Device_ID		 (Device_ID),
        //
        // FBIO Signals
        //
        .FBIO_In         (FBIO_In),
        .FBIO_In_En      (FBIO_In_En),
        .FBIO_Out        (FBIO_Out),
        .FBIO_Out_En     (FBIO_Out_En),
        //
        // ???
        //
        .SFBIO              (SFBIO),
        .Device_ID_6S       (Device_ID_6S),
        .Device_ID_4S       (Device_ID_4S),
        .SPIm_PWdata_26S    (SPIm_PWdata_26S),
        .SPIm_PWdata_24S    (SPIm_PWdata_24S),
        .SPIm_PWdata_14S    (SPIm_PWdata_14S),
        .SPIm_PWdata_11S    (SPIm_PWdata_11S),
        .SPIm_PWdata_0S     (SPIm_PWdata_0S),
        .SPIm_Paddr_8S      (SPIm_Paddr_8S),
        .SPIm_Paddr_6S      (SPIm_Paddr_6S),
        .FB_PKfbPush_1S     (FB_PKfbPush_1S),
        .FB_PKfbData_31S    (FB_PKfbData_31S),
        .FB_PKfbData_21S    (FB_PKfbData_21S),
        .FB_PKfbData_19S    (FB_PKfbData_19S),
        .FB_PKfbData_9S     (FB_PKfbData_9S),
        .FB_PKfbData_6S     (FB_PKfbData_6S),
        .Sys_PKfb_ClkS      (Sys_PKfb_ClkS),
        .FB_BusyS           (FB_BusyS),
        .WB_CLKS            (WB_CLKS)
		);

endmodule /* qlal4s3b_cell_macro */

(* blackbox *)
module gclkbuff (input A, output Z);

assign Z = A;

endmodule

(* blackbox *)
module ram8k_2x1_cell_macro (
    input [10:0] A1_0,
    input [10:0] A1_1,
    input [10:0] A2_0,
    input [10:0] A2_1,
    (* clkbuf_sink *)
    input CLK1_0,
    (* clkbuf_sink *)
    input CLK1_1,
    (* clkbuf_sink *)
    input CLK2_0,
    (* clkbuf_sink *)
    input CLK2_1,
    output Almost_Empty_0, Almost_Empty_1, Almost_Full_0, Almost_Full_1,
    input ASYNC_FLUSH_0, ASYNC_FLUSH_1, ASYNC_FLUSH_S0, ASYNC_FLUSH_S1, CLK1EN_0, CLK1EN_1, CLK1S_0, CLK1S_1, CLK2EN_0, CLK2EN_1, CLK2S_0, CLK2S_1, CONCAT_EN_0, CONCAT_EN_1, CS1_0, CS1_1,CS2_0, CS2_1, DIR_0, DIR_1, FIFO_EN_0, FIFO_EN_1, P1_0, P1_1, P2_0,P2_1, PIPELINE_RD_0, PIPELINE_RD_1,
    output [3:0] POP_FLAG_0,
    output [3:0] POP_FLAG_1,
    output [3:0] PUSH_FLAG_0,
    output [3:0] PUSH_FLAG_1,
    output [17:0] RD_0,
    output [17:0] RD_1,
    input  SYNC_FIFO_0, SYNC_FIFO_1,
    input [17:0] WD_0,
    input [17:0] WD_1,
    input [1:0] WEN1_0,
    input [1:0] WEN1_1,
    input [1:0] WIDTH_SELECT1_0,
    input [1:0] WIDTH_SELECT1_1,
    input [1:0] WIDTH_SELECT2_0,
    input [1:0] WIDTH_SELECT2_1,
    input SD,DS,LS,SD_RB1,LS_RB1,DS_RB1,RMEA,RMEB,TEST1A,TEST1B,
    input [3:0] RMA,
    input [3:0] RMB);
	
	ram8k_2x1_cell I1  ( .A1_0({ A1_0[10:0] }) , .A1_1({ A1_1[10:0] }),
                     .A2_0({ A2_0[10:0] }) , .A2_1({ A2_1[10:0] }),
                     .Almost_Empty_0(Almost_Empty_0),
                     .Almost_Empty_1(Almost_Empty_1),
                     .Almost_Full_0(Almost_Full_0),
                     .Almost_Full_1(Almost_Full_1),
                     .ASYNC_FLUSH_0(ASYNC_FLUSH_0),
                     .ASYNC_FLUSH_1(ASYNC_FLUSH_1),
                     .ASYNC_FLUSH_S0(ASYNC_FLUSH_S0),
                     .ASYNC_FLUSH_S1(ASYNC_FLUSH_S1) , .CLK1_0(CLK1_0),
                     .CLK1_1(CLK1_1) , .CLK1EN_0(CLK1EN_0) , .CLK1EN_1(CLK1EN_1),
                     .CLK1S_0(CLK1S_0) , .CLK1S_1(CLK1S_1) , .CLK2_0(CLK2_0),
                     .CLK2_1(CLK2_1) , .CLK2EN_0(CLK2EN_0) , .CLK2EN_1(CLK2EN_1),
                     .CLK2S_0(CLK2S_0) , .CLK2S_1(CLK2S_1),
                     .CONCAT_EN_0(CONCAT_EN_0) , .CONCAT_EN_1(CONCAT_EN_1),
                     .CS1_0(CS1_0) , .CS1_1(CS1_1) , .CS2_0(CS2_0) , .CS2_1(CS2_1),
                     .DIR_0(DIR_0) , .DIR_1(DIR_1) , .FIFO_EN_0(FIFO_EN_0),
                     .FIFO_EN_1(FIFO_EN_1) , .P1_0(P1_0) , .P1_1(P1_1) , .P2_0(P2_0),
                     .P2_1(P2_1) , .PIPELINE_RD_0(PIPELINE_RD_0),
                     .PIPELINE_RD_1(PIPELINE_RD_1),
                     .POP_FLAG_0({ POP_FLAG_0[3:0] }),
                     .POP_FLAG_1({ POP_FLAG_1[3:0] }),
                     .PUSH_FLAG_0({ PUSH_FLAG_0[3:0] }),
                     .PUSH_FLAG_1({ PUSH_FLAG_1[3:0] }) , .RD_0({ RD_0[17:0] }),
                     .RD_1({ RD_1[17:0] }) , .SYNC_FIFO_0(SYNC_FIFO_0),
                     .SYNC_FIFO_1(SYNC_FIFO_1) , .WD_0({ WD_0[17:0] }),
                     .WD_1({ WD_1[17:0] }) , .WEN1_0({ WEN1_0[1:0] }),
                     .WEN1_1({ WEN1_1[1:0] }),
                     .WIDTH_SELECT1_0({ WIDTH_SELECT1_0[1:0] }),
                     .WIDTH_SELECT1_1({ WIDTH_SELECT1_1[1:0] }),
                     .WIDTH_SELECT2_0({ WIDTH_SELECT2_0[1:0] }),
                     .WIDTH_SELECT2_1({ WIDTH_SELECT2_1[1:0] }) );

endmodule /* ram8k_2x1_cell_macro */

(* blackbox *)
module gpio_cell_macro (

		ESEL,
		IE,
		OSEL,
		OQI,
		OQE,
		DS,
		FIXHOLD,
		IZ,
		IQZ,
		IQE,
		IQC,
		IQCS,
		IQR,
		WPD,
		INEN,
		IP
		);
				
input ESEL;
input IE;
input OSEL;
input OQI;
input OQE;
input DS;
input FIXHOLD;
output IZ;
output IQZ;
input IQE;
input IQC;
input IQCS;
input INEN;
input IQR;
input WPD;
inout IP;

reg EN_reg, OQ_reg, IQZ;
wire AND_OUT;

assign rstn = ~IQR;
assign IQCP = IQCS ? ~IQC : IQC;

always @(posedge IQCP or negedge rstn)
	if (~rstn)
		EN_reg <= 1'b0;
	else
		EN_reg <= IE;

always @(posedge IQCP or negedge rstn)
	if (~rstn)
		OQ_reg <= 1'b0;
	else
		if (OQE)
			OQ_reg <= OQI;
			
			
always @(posedge IQCP or negedge rstn)		
	if (~rstn)
		IQZ <= 1'b0;
	else
		if (IQE)
		IQZ <= AND_OUT; 
	
assign IZ = AND_OUT;  

assign AND_OUT = INEN ? IP : 1'b0; 

assign EN = ESEL ? IE : EN_reg ;

assign OQ = OSEL ? OQI : OQ_reg ;  

assign IP = EN ? OQ : 1'bz;

endmodule


module inpadff ( FFCLK , FFCLR, FFEN, P, FFQ, Q );

input FFCLK;
input FFCLR, FFEN;
output FFQ;
input P;
output Q;

wire  VCC, GND;

assign VCC = 1'b1;
assign GND = 1'b0;

gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(GND) , .INEN(VCC),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(FFEN) , .IQR(FFCLR),
                      .IQZ(FFQ) , .IZ(Q) , .OQE(GND) , .OQI(GND) , .OSEL(VCC),
                      .WPD(GND) );


endmodule /* inpadff */


module outpadff ( A , FFCLK, FFCLR, FFEN, P );

input A;
input FFCLK;
input FFCLR, FFEN;
output P;

wire  VCC, GND;

assign VCC = 1'b1;
assign GND = 1'b0;

gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(VCC) , .INEN(GND),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(GND) , .IQR(FFCLR),
                      .OQE(FFEN) , .OQI(A) , .OSEL(GND) , .WPD(GND), .IQZ(), .IZ() );


endmodule /* outpadff */


module bipadoff ( A2 , EN, FFCLK, FFCLR, O_FFEN, Q, P );

input A2, EN;
input FFCLK;
input FFCLR, O_FFEN;
inout P;
output Q;

wire  VCC, GND;

assign VCC = 1'b1;
assign GND = 1'b0;

gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(GND) , .IQR(FFCLR),
                      .IZ(Q) , .OQE(O_FFEN) , .OQI(A2) , .OSEL(GND) , .WPD(GND), .IQZ() );


endmodule /* bipadoff */


module bipadiff ( A2 , EN, FFCLK, FFCLR, FFEN, FFQ, Q, P );

input A2, EN;
input FFCLK;
input FFCLR, FFEN;
output FFQ;
inout P;
output Q;

wire  VCC, GND;

assign VCC = 1'b1;
assign GND = 1'b0;

gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(FFEN) , .IQR(FFCLR),
                      .IQZ(FFQ) , .IZ(Q) , .OQE(GND) , .OQI(A2) , .OSEL(VCC) , .WPD(GND) );


endmodule /* bipadiff */


module bipadioff ( A2 , EN, FFCLK, FFCLR, I_FFEN, O_FFEN, FFQ, Q, P );

input A2, EN;
input FFCLK;
input FFCLR;
output FFQ;
input I_FFEN, O_FFEN;
inout P;
output Q;

wire  VCC, GND;

assign VCC = 1'b1;
assign GND = 1'b0;

gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(I_FFEN) , .IQR(FFCLR),
                      .IQZ(FFQ) , .IZ(Q) , .OQE(O_FFEN) , .OQI(A2) , .OSEL(GND),
                      .WPD(GND) );


endmodule /* bipadioff */

(* blackbox *)
module qlal4s3_mult_32x32_cell (
    input [31:0] Amult,
    input [31:0] Bmult,
    input [1:0] Valid_mult,
    output [63:0] Cmult);

endmodule /* qlal4s3_32x32_mult_cell */

(* blackbox *)
module qlal4s3_mult_16x16_cell (
    input [15:0] Amult,
    input [15:0] Bmult,
    input [1:0] Valid_mult,
    output [31:0] Cmult);

endmodule /* qlal4s3_16x16_mult_cell */


/* Verilog model of QLAL4S3 Multiplier */
/*qlal4s3_mult_cell*/
module signed_mult(
    A,
    B,
    Valid,
    C
);

parameter	WIDTH	= 0;
parameter	CWIDTH  = 2*WIDTH;
    
input [WIDTH-1:0] A, B;
input Valid;
output[CWIDTH-1:0] C;

reg signed [WIDTH-1:0] A_q, B_q;
wire signed [CWIDTH-1:0] C_int;

assign C_int = A_q * B_q;
assign valid_int = Valid;
assign C = C_int;

always @(*)
    if(valid_int == 1'b1)
        A_q <= A;

always @(*)
    if(valid_int == 1'b1)
        B_q <= B;

endmodule

(* blackbox *)
module qlal4s3_mult_cell_macro ( Amult, Bmult, Valid_mult, sel_mul_32x32, Cmult);

input [31:0] Amult;
input [31:0] Bmult;
input [1:0] Valid_mult;
input sel_mul_32x32;
output [63:0] Cmult;

wire    [15:0]  A_mult_16_0;
wire    [15:0]  B_mult_16_0;
wire    [31:0]  C_mult_16_0;
wire    [15:0]  A_mult_16_1;
wire    [15:0]  B_mult_16_1;
wire    [31:0]  C_mult_16_1;
wire    [31:0]  A_mult_32;
wire    [31:0]  B_mult_32;
wire    [63:0]  C_mult_32;
wire            Valid_mult_16_0;
wire            Valid_mult_16_1;
wire            Valid_mult_32;


assign Cmult = sel_mul_32x32 ? C_mult_32 : {C_mult_16_1, C_mult_16_0};

assign A_mult_16_0     = sel_mul_32x32 ? 16'h0  : Amult[15:0];
assign B_mult_16_0     = sel_mul_32x32 ? 16'h0  : Bmult[15:0];
assign A_mult_16_1     = sel_mul_32x32 ? 16'h0  : Amult[31:16];
assign B_mult_16_1     = sel_mul_32x32 ? 16'h0  : Bmult[31:16];

assign A_mult_32       = sel_mul_32x32 ? Amult : 32'h0;
assign B_mult_32       = sel_mul_32x32 ? Bmult : 32'h0;

assign Valid_mult_16_0 = sel_mul_32x32 ? 1'b0 : Valid_mult[0];
assign Valid_mult_16_1 = sel_mul_32x32 ? 1'b0 : Valid_mult[1];
assign Valid_mult_32   = sel_mul_32x32 ? Valid_mult[0] : 1'b0;

signed_mult #(.WIDTH(16)) u_signed_mult_16_0(
.A                      (A_mult_16_0),                //I: 16 bits
.B                      (B_mult_16_0),                //I: 16 bits
.Valid                  (Valid_mult_16_0),            //I
.C                      (C_mult_16_0)                 //O: 32 bits
);

signed_mult #(.WIDTH(16)) u_signed_mult_16_1(
.A                      (A_mult_16_1),                //I: 16 bits
.B                      (B_mult_16_1),                //I: 16 bits
.Valid                  (Valid_mult_16_1),            //I
.C                      (C_mult_16_1)                 //O: 32 bits
);

signed_mult #(.WIDTH(32)) u_signed_mult_32(
.A                      (A_mult_32),                  //I: 32 bits
.B                      (B_mult_32),                  //I: 32 bits
.Valid                  (Valid_mult_32),              //I
.C                      (C_mult_32)                   //O: 64 bits
);

endmodule
/*qlal4s3_mult_cell*/


