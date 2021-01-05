(* techmap_celltype = "$alu" *)
module _80_quicklogic_alu (A, B, CI, BI, X, Y, CO);
    parameter A_SIGNED = 0;
    parameter B_SIGNED = 0;
    parameter A_WIDTH  = 1;
    parameter B_WIDTH  = 1;
    parameter Y_WIDTH  = 1;

    parameter _TECHMAP_CONSTMSK_CI_ = 0;
    parameter _TECHMAP_CONSTVAL_CI_ = 0;

    (* force_downto *)
    input [A_WIDTH-1:0] A;
    (* force_downto *)
    input [B_WIDTH-1:0] B;
    (* force_downto *)
    output [Y_WIDTH-1:0] X, Y;

    input CI, BI;
    (* force_downto *)
    output [Y_WIDTH-1:0] CO;

    wire _TECHMAP_FAIL_ = Y_WIDTH <= 2;

    (* force_downto *)
    wire [Y_WIDTH-1:0] A_buf, B_buf;
    \$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
    \$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(Y_WIDTH)) B_conv (.A(B), .Y(B_buf));

    (* force_downto *)
    wire [Y_WIDTH-1:0] AA = A_buf;
    (* force_downto *)
    wire [Y_WIDTH-1:0] BB = BI ? ~B_buf : B_buf;
    (* force_downto *)
    wire [Y_WIDTH-1:0] C = {CO, CI};

    wire ci;
    wire co;

//     genvar i;
//    generate for (i = 0; i < Y_WIDTH; i = i + 1) begin: slice
//        \$__AP3_CARRY_WRAPPER #(
//            .LUT(16'b 1110_1000_1001_0110),
//            .I2_IS_CI(1'b1)
//        ) carry (
//			.A(AA[i]),
//			.B(BB[i]),
//			.CI(C[i]),
//			.I2(1'bx),
//			.I3(1'b0),
//			.CO(CO[i]),
//			.O(Y[i])
//		);
//
//    end: slice
//    endgenerate

    genvar i;
    generate for (i = 0; i < Y_WIDTH; i = i + 1) begin: slice
        // First in chain
        generate if (i == 0) begin
            // Carry-chain init stub
            wire c0;
            CI_STUB stub (.C0(c0));

            // CI connected to a constant
            if (_TECHMAP_CONSTMSK_CI_ == 1) begin

                localparam INIT = (_TECHMAP_CONSTVAL_CI_ == 0) ?
                    16'b11100110_01100110 :
                    16'b11111000_10011001;

                // LUT4 configured as 1-bit adder with CI=const
                \$__AP3_CARRY_WRAPPER #(
                    .LUT(INIT),
                    .I2_IS_CI(1'b1)
                ) lut_ci_adder (
                    .A(AA[i]),
                    .B(BB[i]),
                    .I2(),
                    .I3(1'b0),
                    .O(Y[i]),
                    .CI(c0),
                    .CO(ci)
                );

            // CI connected to a non-const driver
            end else begin

                // LUT4 configured as passthrough to drive CI of the next stage
                \$__AP3_CARRY_WRAPPER #(
                    .LUT(16'b11000000_00001100),
                    .I2_IS_CI(1'b1)
                ) lut_ci (
                    .A(),
                    .B(CI[i]),
                    .I2(),
                    .I3(),
                    .O(),
                    .CI(c0),
                    .CO(ci)
                );
            end

        // Not first in chain
        end else begin
            assign ci = C[i];

        end endgenerate

        // ....................................................

        // Single 1-bit adder, mid-chain adder or non-const CI
        // adder
        generate if ((Y_WIDTH == 1) ||
                     (i == 0 && _TECHMAP_CONSTMSK_CI_ == 0) ||
                     (i > 0 && i < Y_WIDTH-1)) begin
            
            // LUT4 configured as full 1-bit adder
            \$__AP3_CARRY_WRAPPER #(
                    .LUT(16'b10000110_10010110),
                    .I2_IS_CI(1'b0)
                ) lut_adder (
                    .A(AA[i]),
                    .B(BB[i]),
                    .I2(),
                    .I3(1'b0),
                    .O(Y[i]),
                    .CI(ci),
                    .CO(co)
                );
                         
        end else begin
            assign co = ci;

        end endgenerate

        // ....................................................

        // Last in chain
        generate if (i == Y_WIDTH-1) begin
            // LUT4 configured for passing its CI input to output. This should
            // get pruned if the actual CO port is not connected anywhere.
            \$__AP3_CARRY_WRAPPER #(
                    .LUT(16'b11110000_11110000),
                    .I2_IS_CI(1'b0)
                ) lut_co (
                    .A(),
                    .B(),
                    .I2(),
                    .I3(),
                    .O(CO[i]),
                    .CI(co),
                    .CO()
                );
        // Not last in chain
        end else begin
            assign CO[i] = co;

        end endgenerate

    end: slice	  
    endgenerate

    /* End implementation */
    assign X = AA ^ BB;
endmodule
