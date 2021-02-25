module \$_DFF_P_ (D, Q, C);
    input D;
    input C;
    output Q;
    openfpga_ff _TECHMAP_REPLACE_ (.Q(Q), .D(D), .C(C));
endmodule

module \$__SHREG_DFF_P_ (D, Q, C);
    input D;
    input C;
    output Q;

    parameter DEPTH = 2;
    reg [DEPTH-1:0] q;
    wire [DEPTH-1:0] d;
    genvar i;
    assign d[0] = D;
    generate for (i = 0; i < DEPTH; i = i + 1) begin: slice


        // First in chain
        generate begin
                 openfpga_shreg_ff #() _TECHMAP_REPLACE_ (
                    .Q(q[i]),
                    .D(d[i]),
                    .C(C)
                );
		assign d[i+1] = q[i]; 
        end endgenerate
   end: slice
   endgenerate
   assign Q = q[DEPTH-1];

endmodule
