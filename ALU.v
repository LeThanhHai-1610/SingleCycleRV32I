module ALU (
    input [31:0] in1,
	 input [31:0] in2,
	 input [3:0] sel,
	 output [31:0] ALU_result,
	 output ALU_of,
	 output ALU_zero,
	 output ALU_lt,
	 output ALU_neg
);
wire [31:0] r1, r2, r0,r;
wire r3;
wire OF, OF1, ZERO, w_ALU_of,w_zero_compare;
shifter block(
	.i_a       (in1),
	.i_b       (in2),
	.i_mode    (sel[1:0]),
	.o_shifted (r1)
);
CLA (
    .i_A (in1),
	 .i_B (in2),
	 .i_mode (sel[0]),
	 .S (r0),
	 .overflow (OF),
	 .zero (ZERO)
);
comparator (
    .i_Mode (sel[0]),
    .i_a       (in1),
	 .i_b       (in2),
	 .lt (r3),
	 .zero (w_zero_compare),
	 .of (OF1)
);
assign ALU_lt = r3 ;
logic_unit (
    .a (in1),
	 .b (in2),
	 .sel (sel[1:0]),
	 .out (r2),
);

mux_4to1 (
    .a (r0),
	 .b (r1),
	 .c (r2),
	 .d (r3),
	 .sel (sel[3:2]),
	 .out (r)
);
assign ALU_result = r;
assign ALU_of = OF & ~(sel[0] ^  sel[1]);
assign ALU_zero = (ZERO & (~sel[0] & ~sel[1])) | w_zero_compare ;
assign ALU_neg = r[31] & (~sel[0] & ~sel[1]);
endmodule
