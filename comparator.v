module comparator (
    input i_Mode,  // 1: unsigned;   0: signed
	 input [31:0] i_a,
	 input [31:0] i_b,
	 output lt,zero,
	 output of
);
wire w_of,w_zero;
wire  w1,w2;
wire [31:0] w_S;
CLA blk (
		  .i_A (i_a),
	     .i_B (i_b),
	     .i_mode (1),
	     .S (w_S),
	     .overflow (w_of),
	     .zero (w_zero)
		  );
assign w1 = (i_a[31] ^ i_b[31]) & i_Mode ;
assign w2 = w1 ^ i_a[31];

assign lt = (i_Mode == 1 && w1 == 1) ? w2:w_S[31] ;
assign of = (i_Mode == 1 && w1 == 1) ? 0 : w_of;
assign zero = w_zero;
endmodule
