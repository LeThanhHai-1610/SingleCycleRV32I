module Instruction_Memory (
    input [31:0] pc         ,
    //input        clk        ,
    output[31:0] instruction 
);
  reg [31:0] IM [31:0];
  wire [31:0] addr = pc[31:2];
  initial begin
      $readmemb("IM.txt", IM);
  end
  assign instruction =  IM[addr]; 
endmodule
