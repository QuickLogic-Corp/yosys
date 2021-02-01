
module carry_follower(
	output CO,
	input A,
	input B,
	input CI
);
	assign CO = ((A ^ B) & CI) | (~(A ^ B) & (A & B)); 
endmodule

(* abc9_lut=1, lib_whitebox *)
module LUT4(
   output O, 
   input I0,
   input I1,
   input I2,
   input I3
);
    parameter [15:0] INIT = 16'h0;
    parameter EQN = "(I0)";
    
    assign O = INIT[{I3, I2, I1, I0}];
endmodule

(* abc9_flop, lib_whitebox *)
module openfpga_ff(
    output reg Q,
    input D,
    (* clkbuf_sink *)
    input C
);
    parameter [0:0] INIT = 1'b0;
    initial Q = INIT;

    always @(posedge C)
        Q <= D;
endmodule

module ck_buff(
    (* clkbuf_driver *)
    output out,
    input in);
  assign out = in;
endmodule

module ck_buff_int(
    (* clkbuf_driver *)
    output out,
    input in);
  assign out = in;
endmodule
