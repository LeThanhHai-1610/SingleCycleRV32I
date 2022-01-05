module shifter16(
	input   [1:0]  i_mode16,
	input   [31:0] i_a16,
	input          i_active16,
	output  [31:0] o_shifted16
);
wire [31:0] w_shifted16;
shifter8 block1(
	.i_mode8    (i_mode16),
	.i_a8       (i_a16),
	.i_active8   (i_active16),
	.o_shifted8 (w_shifted16)
);
shifter8 block2  (
	.i_mode8    (i_mode16),
	.i_a8       (w_shifted16),
	.i_active8   (i_active16),
	.o_shifted8 (o_shifted16)
);
endmodule

module shifter8(
	input [1:0]  i_mode8,
	input [31:0] i_a8,
	input        i_active8,
	output [31:0] o_shifted8
);
wire [31:0] w_shifted8;
shifter4 block1(
	.i_mode4    (i_mode8),
	.i_a4       (i_a8),
	.i_active4   (i_active8),
	.o_shifted4 (w_shifted8)
);
shifter4 block2  (
	.i_mode4    (i_mode8),
	.i_a4       (w_shifted8),
	.i_active4   (i_active8),
	.o_shifted4 (o_shifted8)
);
endmodule

module shifter4(
	input [1:0] i_mode4,
	input [31:0] i_a4,
	input        i_active4,
	output  [31:0] o_shifted4
);
wire [31:0] w_shifted4;
shifter2 block1(
	.i_mode2    (i_mode4),
	.i_a2       (i_a4),
	.i_active2   (i_active4),
	.o_shifted2 (w_shifted4)
);
shifter2 block2  (
	.i_mode2    (i_mode4),
	.i_a2       (w_shifted4),
	.i_active2   (i_active4),
	.o_shifted2 (o_shifted4)
);
endmodule

module shifter2(
	input [1:0] i_mode2,
	input [31:0] i_a2,
	input        i_active2,
	output  [31:0] o_shifted2
);
wire [31:0] w_shifted2;
shifter1 block1(
	.i_mode1    (i_mode2),
	.i_a1       (i_a2),
	.i_active   (i_active2),
	.o_shifted1 (w_shifted2)
);
shifter1 block2  (
	.i_mode1    (i_mode2),
	.i_a1       (w_shifted2),
	.i_active   (i_active2),
	.o_shifted1 (o_shifted2)
);
endmodule
	
	/* 2'b00  Shift Right Logical      
   2'b01;  Shift Right Arithmetic
   2'b10;  Shift Left Logical
   2'b11;  Shift Left Arithmeticl*/
	
module shifter1(
	input [1:0] i_mode1,
	input [31:0] i_a1,
	input        i_active,
	output [31:0] o_shifted1
);

reg [31:0] r_shifted1;
always @(*)
begin
  if (i_active == 0) r_shifted1 = i_a1;
  else
  begin
    if (i_mode1[1] == 0) // shift RIGHT
	 begin
	     if (i_mode1[0] == 0) r_shifted1 = {1'b0,i_a1[31:1]};//i_a1 >> 1;
	     else                 r_shifted1 = {i_a1[31],i_a1[31:1]};//i_a1 >>> 1;
		 //end
		 //else                     r_shifted1 = {i_a1[0],i_a1[31:1]};//RoR
	 end
	 else 
	 begin
	    //if (i_mode1[1] == 0)
		 //begin
		 if (i_mode1[0] == 0) r_shifted1 = {i_a1[30:0],1'b0};//i_a1 << 1;
		 else                 r_shifted1 = {i_a1[30:0],1'b0};//i_a1 <<< 1;
		 //end
		 //else                     r_shifted1 = {i_a1[30:0],i_a1[31]};//RoL
	 end
  end
end
assign o_shifted1 = r_shifted1;
endmodule

module mux2to1 (
input      [31:0] in0,
input      [31:0] in1,
input             mux_sel,
output reg [31:0] r
);
always @(*)
begin
	if (mux_sel == 1'b0) r =  in0; // mode 0: shift left
	else                 r =  in1;
end
endmodule
