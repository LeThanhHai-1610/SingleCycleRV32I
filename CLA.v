module CLA (
    input [31:0] i_A,
	 input [31:0] i_B,
	 input        i_mode,   //0: add; 1: sub
	 output [31:0] S,
	 output        overflow,
	 output        zero
);
wire [31:0] w_B;
wire [31:0] w_S;
wire [31:0] w_P;
wire [31:0] w_G;
wire [32:1] w_Cin;

  mini_CLA (.i_a (i_A[0]), .i_b (i_B[0]^i_mode), .i_Cin (i_mode), .S (w_S[0]), .P (w_P[0]), .G (w_G[0]));
  assign w_Cin[1] = w_G[0] | (w_P[0] & i_mode);
  genvar             m;
  generate 
      for (m=1; m<=31; m=m+1) 
      begin : block
		    assign w_B[m] = i_B[m] ^ i_mode;
		    assign w_Cin[m+1] = w_G[m] | (w_P[m] & w_Cin[m]);
          mini_CLA blk( 
              .i_a (i_A[m]),
              .i_b (w_B[m]),
				  .i_Cin (w_Cin[m]),
				  .S (w_S[m]),
				  .P (w_P[m]),
				  .G (w_G[m])
              );
      end
  endgenerate
assign S = w_S; 
assign overflow = (w_Cin[31] ^ w_Cin[32]);
assign zero = ~(|(w_S));
endmodule
module mini_CLA (
    input i_a,
	 input i_b,
	 input i_Cin,
	 output S,
	 output P,
	 output G
);
wire w_S, w_P, w_G;
assign w_S = i_a ^ i_b ^ i_Cin;
assign w_P = i_a ^ i_b;
assign w_G = i_a & i_b;
assign S = w_S; assign P = w_P; assign G = w_G;
endmodule
