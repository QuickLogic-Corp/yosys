
module carry_follower(
	output CO,
	input A,
	input B,
	input CI
);
	assign CO = ((A ^ B) & CI) | (~(A ^ B) & (A & B)); 
endmodule

