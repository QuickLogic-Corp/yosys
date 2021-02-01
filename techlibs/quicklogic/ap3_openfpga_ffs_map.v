module \$_DFF_P_ (D, Q, C);
    input D;
    input C;
    output Q;
    openfpga_ff _TECHMAP_REPLACE_ (.Q(Q), .D(D), .C(C));
endmodule


