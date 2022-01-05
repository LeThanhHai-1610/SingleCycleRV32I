module Instruction_Decode (
  //input                   clk             , // Clock
  //input                   rst_n           , // Asynchronous reset active low
  input  [31:0]           instruction     , // Instruction from Instruction Memory
  output [6:0]            opcode          ,
  output [4:0]            rd              ,
  output [4:0]            rs1             ,
  output [4:0]            rs2             ,
  output [2:0]            funct3          ,
  output [6:0]            funct7          ,
  output [2:0]            type
);
wire [6:0] w_opcode;
reg [2:0] r_type;
  assign w_opcode = instruction[6:0]  ; //Opcode to Control Unit
  assign rd       = instruction[11:7] ; //Register Destination
  assign rs1      = instruction[19:15]; //Register Source 1
  assign rs2      = instruction[24:20]; //Register Source 2
  assign funct3   = instruction[14:12];
  assign funct7   = instruction[31:25];
always @(*)
begin
    case (w_opcode)
    7'b0110011: r_type = 3'b000; // R_type
	 7'b0010011: r_type = 3'b110; // I_type, ALU
	 7'b0000011: r_type = 3'b001; // I_type, LOAD
	 7'b1100111: r_type = 3'b001; // I_type, jalr
	 7'b0110111: r_type = 3'b010; // U_type
	 7'b0010111: r_type = 3'b010; // U_type
	 7'b1100011: r_type = 3'b011; // B_type 
	 7'b0100011: r_type = 3'b100; // S_type 
	 7'b1101111: r_type = 3'b101; // J_type
	 default     r_type = 3'b111;
	 endcase
end
assign opcode = w_opcode;
assign type = r_type;
endmodule
