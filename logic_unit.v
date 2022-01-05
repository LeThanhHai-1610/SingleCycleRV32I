module logic_unit ( 
 input [31:0] a,
 input [31:0] b,
 input [1:0] sel,
 output [31:0] out);

 assign out = sel[1] ? (sel[0] ? ~a : a ^ b) : (sel[0] ? a | b : a & b);
endmodule
