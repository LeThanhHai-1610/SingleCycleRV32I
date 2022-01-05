module module_32_D_FF (
    input i_clr,
    //input i_CE,
    input [31:0] i_D,
	 input i_clk,
	 output [31:0] o_Q
);
wire [31:0] w_Q;
genvar             m;
  generate 
      for (m=0; m<=31; m=m+1) 
      begin : D_FF
          mini_D_FF blk( 
              .clr (i_clr),
              //.CE (i_CE),
				  .D (i_D[m]),
				  .clk (i_clk),
			     .Q (w_Q[m])	  
              );
      end
  endgenerate
assign o_Q = w_Q;
endmodule

module mini_D_FF (
    input clr,
    //input CE,
    input D,
	 input clk,
	 output Q
);
reg r_Q;
always @(posedge clk or posedge clr)
begin
    if (clr) r_Q = 0;
	 else
	 begin
	     if (clk) r_Q = D;
		  else r_Q = r_Q;
    end	
end
assign Q = r_Q;
endmodule
