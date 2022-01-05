module mux_4to1 ( 
 input [31:0]  a,
 input [31:0] b,
 input [31:0] c,
 input [31:0] d,
 input [1:0] sel,
 output [31:0] out);

 assign out = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a);
endmodule


