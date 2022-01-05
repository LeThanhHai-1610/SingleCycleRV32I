module shifter (
	input [31:0]   i_a,
	input [31:0]    i_b,
	input [1:0]    i_mode,
	output  [31:0]  o_shifted
);
wire [31:0] w_shifted1        ;
wire [31:0] w_shifted2        ;
wire [31:0] w_shifted4        ;
wire [31:0] w_shifted8        ;
wire [31:0] w_shifted16       ;
wire [31:0] w_shifted32       ;
wire w_b1 = |(i_b[31:5])      ;
wire [5:0]  w_b = (w_b1 == 1)? 6'b111111:{w_b1,i_b[4:0]}    ;

shifter1 blck1 (
	.i_mode1     (i_mode),
	.i_a1        (i_a),
	.i_active    (w_b[0]),
	.o_shifted1  (w_shifted1)
);

shifter2 blck2 (
	.i_mode2     (i_mode),
	.i_a2        (w_shifted1),
	.i_active2   (w_b[1]),
	.o_shifted2  (w_shifted2)
);

shifter4 blck3 (
	.i_mode4     (i_mode),
	.i_a4        (w_shifted2),
	.i_active4   (w_b[2]),
	.o_shifted4  (w_shifted4)
);

shifter8 blck4 (
	.i_mode8     (i_mode),
	.i_a8        (w_shifted4),
	.i_active8   (w_b[3]),
	.o_shifted8  (w_shifted8)
);

shifter16 blck5 (
	.i_mode16     (i_mode),
	.i_a16        (w_shifted8),
	.i_active16   (w_b[4]),
	.o_shifted16  (w_shifted16)
);
shifter1 blck6 (
	.i_mode1     (i_mode),
	.i_a1        (w_shifted16),
	.i_active    (w_b[5]),
	.o_shifted1  (w_shifted32)
);
assign o_shifted = w_shifted32;
endmodule
