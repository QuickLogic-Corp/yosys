/* Generated by Yosys 0.8+498 (git sha1 1bdc7e9d, gcc 7.4.0-1ubuntu1~18.04 -fPIC -Os) */

(* cells_not_processed =  1  *)
(* src = "attrib06_operator_suffix.v:1" *)
module bar(clk, rst, inp_a, inp_b, out);
  (* src = "attrib06_operator_suffix.v:8" *)
  reg [7:0] _0_;
  (* src = "attrib06_operator_suffix.v:10" *)
  wire [7:0] _1_;
  (* src = "attrib06_operator_suffix.v:2" *)
  input clk;
  (* src = "attrib06_operator_suffix.v:4" *)
  input [7:0] inp_a;
  (* src = "attrib06_operator_suffix.v:5" *)
  input [7:0] inp_b;
  (* src = "attrib06_operator_suffix.v:6" *)
  output [7:0] out;
  reg [7:0] out;
  (* src = "attrib06_operator_suffix.v:3" *)
  input rst;
  assign _1_ = inp_a + (* ripple_adder = 32'd1 *) (* src = "attrib06_operator_suffix.v:10" *) inp_b;
  always @* begin
    _0_ = out;
    casez (rst)
      1'h1:
          _0_ = 8'h00;
      default:
          _0_ = _1_;
    endcase
  end
  always @(posedge clk) begin
      out <= _0_;
  end
endmodule

(* cells_not_processed =  1  *)
(* src = "attrib06_operator_suffix.v:14" *)
module foo(clk, rst, inp_a, inp_b, out);
  (* src = "attrib06_operator_suffix.v:15" *)
  input clk;
  (* src = "attrib06_operator_suffix.v:17" *)
  input [7:0] inp_a;
  (* src = "attrib06_operator_suffix.v:18" *)
  input [7:0] inp_b;
  (* src = "attrib06_operator_suffix.v:19" *)
  output [7:0] out;
  (* src = "attrib06_operator_suffix.v:16" *)
  input rst;
  (* module_not_derived = 32'd1 *)
  (* src = "attrib06_operator_suffix.v:21" *)
  bar bar_instance (
    clk,
    rst,
    inp_a,
    inp_b,
    out
  );
endmodule
