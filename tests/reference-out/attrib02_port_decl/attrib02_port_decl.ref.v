/* Generated by Yosys 0.8+498 (git sha1 1bdc7e9d, gcc 7.4.0-1ubuntu1~18.04 -fPIC -Os) */

(* cells_not_processed =  1  *)
(* src = "attrib02_port_decl.v:1" *)
module bar(clk, rst, inp, out);
  (* src = "attrib02_port_decl.v:10" *)
  reg _0_;
  (* src = "attrib02_port_decl.v:12" *)
  wire _1_;
  (* src = "attrib02_port_decl.v:3" *)
  (* this_is_clock = 32'd1 *)
  input clk;
  (* src = "attrib02_port_decl.v:6" *)
  input inp;
  (* an_output_register = 32'd1 *)
  (* src = "attrib02_port_decl.v:8" *)
  output out;
  reg out;
  (* src = "attrib02_port_decl.v:5" *)
  (* this_is_reset = 32'd1 *)
  input rst;
  assign _1_ = ~ (* src = "attrib02_port_decl.v:12" *) inp;
  always @* begin
    _0_ = out;
    casez (rst)
      1'h1:
          _0_ = 1'h0;
      default:
          _0_ = _1_;
    endcase
  end
  always @(posedge clk) begin
      out <= _0_;
  end
endmodule

(* cells_not_processed =  1  *)
(* src = "attrib02_port_decl.v:16" *)
module foo(clk, rst, inp, out);
  (* src = "attrib02_port_decl.v:18" *)
  (* this_is_the_master_clock = 32'd1 *)
  input clk;
  (* src = "attrib02_port_decl.v:20" *)
  input inp;
  (* src = "attrib02_port_decl.v:21" *)
  output out;
  (* src = "attrib02_port_decl.v:19" *)
  input rst;
  (* module_not_derived = 32'd1 *)
  (* src = "attrib02_port_decl.v:23" *)
  bar bar_instance (
    clk,
    rst,
    inp,
    out
  );
endmodule
