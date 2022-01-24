module Control_Unit(
    //input            clk      ,
    //input            rst_n    ,
    //input            BrEq     ,
    //input            BrLT     ,
    input            zero_control,
    input      [2:0] type      ,
    input      [6:0] opcode    ,  
    input      [6:0] funct7    ,
    input      [2:0] funct3    ,
    output reg       Branch    ,   // notify B-type instruction
    output reg       Jump      ,   // notify J-type instruction and Jump
    output reg       PCspecial ,   // only 1 when jalr (nextPC depends on rs1); otherwise NextPC depends on currentPC)
    output reg       MemtoReg  ,   // connect to Mux after DataMem
    output reg [1:0] ALUSrc    ,   // select input of 2nd operand of ALU
    output reg [1:0] Asel      ,   // select input of 1st operand of ALU
    output reg       MemRd     ,   // connect to DataMem  
    output reg       MemWr     ,   // connect to DataMem
    output reg       RegWr     ,   // connect to registers file  
    output reg [1:0] BrOp      ,   // select between B instructions
    output reg [2:0] Load_sel  ,   // select between load instructions; control Mux before WriteData of RegFile
    output reg [1:0] Store_sel ,   // select between S instructions; control Mux before WriteData of DataMem
    output reg [3:0] ALUOp         // connect to ALU
);

// Parameter file
//type parameter
/*parameter R = 3'b000;
parameter I = 3'b001;
parameter U = 3'b010;
parameter B = 3'b011;
parameter S = 3'b100;
parameter J = 3'b101;*/

//ALU operation
parameter ALUadd  =  4'b0000;
parameter ALUsub  =  4'b0001;
parameter ALUsrl  =  4'b0100; // Shift Right Logical
parameter ALUsra  =  4'b0101; // Shift Right Arithmetic
parameter ALUsll  =  4'b0110; // Shift Left  Logical
parameter ALUsla  =  4'b0111; // Shift Left  Arithmetic
parameter ALUand  =  4'b1000;
parameter ALUor   =  4'b1001;
parameter ALUxor  =  4'b1010;
parameter ALUnot  =  4'b1011;
parameter ALUslt  =  4'b1100; // less than
parameter ALUsltu =  4'b1101; // less than unsigned
parameter ALUnop  =  4'b0011;

//Instrucion type
parameter NoP     = 7'b0000000;
parameter R       = 7'b0110011;
parameter I       = 7'b0010011;
parameter ld      = 7'b0000011;
parameter st      = 7'b0100011;
parameter B       = 7'b1100011;
parameter jalr    = 7'b1100111;
parameter jal     = 7'b1101111;
parameter auipc   = 7'b0010111;
parameter lui     = 7'b0110111;
always @(*)
begin
  if (zero_control) 
    begin 
	     Branch      = 1'b0;      // PC = PC + 4
	     Jump        = 1'b0;      // no jump
	     PCspecial   = 1'b0;      // no jalr
	     MemtoReg    = 1'b0;      // ALU result -> registers files
	     Asel        = 2'b00;     // 1st ALU operand from rs1
	     ALUSrc      = 2'b00;     // 2nd ALU operand from rs2
	     MemRd       = 1'b0;      // don't rd or wr data memory
	     MemWr       = 1'b0;      // don't rd or wr data memory
	     RegWr       = 1'b0;      // No Write to rd
	     ALUOp       = ALUnop;    // ALU sll
	     BrOp        = 2'bxx;
	     Load_sel    = 3'b1xx;    // normal
	     Store_sel   = 2'b1x;     // normal
   end
  else 
    begin
      case(opcode)
      
      R:
        begin
	    Branch      = 1'b0;      // PC = PC + 4
	    Jump        = 1'b0;      // no jump
            PCspecial   = 1'b0;      // no jalr
            MemtoReg    = 1'b0;      // ALU result -> registers files
	    Asel        = 2'b00;     // 1st ALU operand from rs1
            ALUSrc      = 2'b00;     // 2nd ALU operand from rs2
            MemRd       = 1'b0;      // don't rd or wr data memory
            MemWr       = 1'b0;      // don't rd or wr data memory
            RegWr       = 1;         // Write to rd
	    BrOp        = 2'bxx;
	    Load_sel    = 3'b1xx;    // normal
            Store_sel   = 2'b1x;     // normal
	    case (funct3)
	        3'b000: /// add or sub
	          begin
		      case (funct7)
		          7'b0000000: ALUOp = ALUadd; // ALU add
		          7'b0100000: ALUOp = ALUsub; // ALU sub
		          default:    ALUOp = ALUadd; // ALU add
		      endcase			
		  end		 
	    	3'b001:  ALUOp = ALUsll;    // ALU sll
                3'b010:	 ALUOp = ALUslt;    // ALU slt
                3'b011:	 ALUOp = ALUsltu;   // ALU sllu
	        3'b100:	 ALUOp = ALUxor;    // ALU xor			
		3'b101: //srl or sra
		  begin  
		      case(funct7)
		          7'b0000000: ALUOp = ALUsrl; // ALU srl
			  7'b0100000: ALUOp = ALUsra; // ALU sra	
			  default:    ALUOp = ALUsrl; // ALU srl
		      endcase
		  end
		3'b110:  ALUOp = ALUor;     // ALU or
		3'b111:	 ALUOp = ALUand;    // ALU and
		default: ALUOp = ALUadd;
	    endcase
	  end
      I:
        begin
	    Branch      = 1'b0;      // PC = PC + 4
	    Jump        = 1'b0;      // no jump
 	    PCspecial   = 1'b0;      // no jalr
            MemtoReg    = 1'b0;      // ALU result -> registers files
	    Asel        = 2'b00;     // 1st ALU operand from rs1
            ALUSrc      = 2'b01;     // 2nd ALU operand from imm
            MemRd       = 1'b0;      // don't rd or wr data memory
	    MemWr       = 1'b0;      // don't rd or wr data memory
            RegWr       = 1;         // Write to rd
	    BrOp        = 2'bxx;
	    Load_sel    = 3'b1xx;    // normal
	    Store_sel   = 2'b1x;     // normal
	    case (funct3)
	        3'b000:  ALUOp = ALUadd;
	        3'b001:  ALUOp = ALUsll;    // ALU sll
      	        3'b010:  ALUOp = ALUslt;    // ALU slt
                3'b011:  ALUOp = ALUsltu;    // ALU sltu
                3'b100:  ALUOp = ALUxor;     // ALU xor
                3'b101: //srli or srai
                  begin  
	              case(funct7)
		          7'b0000000: ALUOp = ALUsrl; // ALU srl 
			  7'b0100000: ALUOp = ALUsra; // ALU sra
			  default:    ALUOp = ALUsra; // ALU sra
		      endcase
		  end
		3'b110:   ALUOp = ALUor;     // ALU or
		3'b111:	  ALUOp = ALUand;    // ALU and
		default:  ALUOp = ALUadd;
             endcase	 
	  end
		  
      ld:
        begin
            Branch      = 1'b0;      // PC = PC + 4
	    Jump        = 1'b0;      // no jump
	    PCspecial   = 1'b0;      // no jalr
	    MemtoReg    = 1'b1;      // data from DataMem -> registers files
	    Asel        = 2'b00;     // 1st ALU operand from rs1
	    ALUSrc      = 2'b01;     // 2nd ALU operand from imm
	    MemRd       = 1'b1;      // Read data memory
	    MemWr       = 1'b0;      // don't wr to data memory
	    RegWr       = 1'b1;      // Write to rd
	    BrOp        = 2'bxx;
	    Store_sel   = 2'bxx;     // normal
	    ALUOp       = ALUadd;    // ALU add
	    case (funct3)
	        3'b000:  Load_sel    = 3'b000;    // lb
	        3'b001:  Load_sel    = 3'b001;    // lh
	        3'b010:  Load_sel    = 3'b1xx;    // lw
	        3'b100:  Load_sel    = 3'b010;    // lbu
	        3'b101:  Load_sel    = 3'b011;    // lhu 
	        default: Load_sel    = 3'b1xx;    // lw
	    endcase
	end
      st:
        begin
            Branch      = 1'b0;      // PC = PC + 4
	    Jump        = 1'b0;      // no jump
	    PCspecial   = 1'b0;      // no jalr
	    MemtoReg    = 1'bx;      // don't need to wr to registers files
	    Asel        = 2'b00;     // 1st ALU operand from rs1
	    ALUSrc      = 2'b01;     // 2nd ALU operand from imm
	    MemRd       = 1'b0;      // Don't rd data memory
	    MemWr       = 1'b1;      // wr to data memory
	    RegWr       = 1'b0;      // Don't write to rd
	    BrOp        = 2'bxx;
	    Load_sel    = 3'bxxx;    // don't care
	    ALUOp       = ALUadd;    // ALU add
	    case(funct3)
	        3'b000:  Store_sel   = 2'b00;     // sb
	        3'b001:  Store_sel   = 2'b01;     // sh
		3'b010:  Store_sel   = 2'b1x;     // sw
		default: Store_sel   = 2'b1x;     // sw
            endcase
	end
      B:
        begin
            Branch      = 1;          // PC may not PC + 4, depends on zero flag from ALU
	    Jump        = 1'b0;       // no jump
	    PCspecial   = 1'b0;       // no jalr
	    MemtoReg    = 1'bx;       // don't need -> don't care
	    Asel        = 2'b00;      // 1st ALU operand from rs1
	    ALUSrc      = 2'b00;      // 2nd ALU operand from rs2
	    MemRd       = 1'b0;       // don't rd or wr data memory
	    MemWr       = 1'b0;       // don't rd or wr data memory
	    RegWr       = 1'b0;       // don't need to write to registers file
	    ALUOp       = ALUslt;     // ALU compare
	    Load_sel    = 3'b1xx;     // normal
	    Store_sel   = 2'b1x;      // normal
	    case(funct3)
                3'b000:  BrOp        = 2'b00; // beq
		3'b001:  BrOp        = 2'b01; // bne
		3'b100:  BrOp        = 2'b10; // blt
		3'b101:  BrOp        = 2'b11; // bge
		3'b110:  BrOp        = 2'b10; // bltu
		3'b111:  BrOp        = 2'b11; // bgeu
		default: BrOp        = 2'b00; // beq
            endcase
        end
      jalr:
        begin
            Branch      = 1'b0;       // PC = PC + 4
	   Jump        = 1'b1;       // jump
	   PCspecial   = 1'b1;       // jalr
	   MemtoReg    = 1'b0;       // ALU result -> registers files
	   Asel        = 2'b01;      // 1st ALU operand is PC
	   ALUSrc      = 2'b10;      // 2nd ALU operand is 4
	   MemRd       = 1'b0;       // don't rd or wr data memory
	   MemWr       = 1'b0;       // don't rd or wr data memory
	   RegWr       = 1;          // Write to rd
	   BrOp        = 2'bxx;
	   Load_sel    = 3'b1xx;     // normal
	   Store_sel   = 2'b1x;      // normal
	   ALUOp       = ALUadd;     // ALU add
        end
      jal:
        begin
	    Branch      = 1'b0;       // PC = PC + 4
	    Jump        = 1'b1;       // jump
	    PCspecial   = 1'b0;       // no jalr
	    MemtoReg    = 1'b0;       // ALU result -> registers files
	    Asel        = 2'b01;      // 1st ALU operand is PC
	    ALUSrc      = 2'b10;      // 2nd ALU operand is 4
	    MemRd       = 1'b0;       // don't rd or wr data memory
	    MemWr       = 1'b0;       // don't rd or wr data memory
	    RegWr       = 1;          // Write to rd
	    BrOp        = 2'bxx;
	    Load_sel    = 3'b1xx;     // normal
	    Store_sel   = 2'b1x;      // normal
	    ALUOp       = ALUadd;     // ALU add
        end
      auipc:
        begin
	    Branch      = 1'b0;       // PC = PC + 4
	    Jump        = 1'b0;       // no jump
	    PCspecial   = 1'b0;       // no jalr
	    MemtoReg    = 1'b0;       // ALU result -> registers files
	    Asel        = 2'b01;      // 1st ALU operand from PC
	    ALUSrc      = 2'b01;      // 2nd ALU operand from imm
	    MemRd       = 1'b0;       // don't rd or wr data memory
	    MemWr       = 1'b0;       // don't rd or wr data memory
	    RegWr       = 1;          // Write to rd
	    BrOp        = 2'bxx;
	    Load_sel    = 3'b1xx;     // normal
	    Store_sel   = 2'b1x;      // normal
	    ALUOp       = ALUadd;     // ALU add
        end
      lui:
         begin
	    Branch      = 1'b0;       // PC = PC + 4
	    Jump        = 1'b0;       // no jump
	    PCspecial   = 1'b0;       // no jalr
	    MemtoReg    = 1'b0;       // ALU result -> registers files
	    Asel        = 2'b10;      // 1st ALU operand is 0
	    ALUSrc      = 2'b01;      // 2nd ALU operand from imm
	    MemRd       = 1'b0;       // don't rd or wr data memory
	    MemWr       = 1'b0;       // don't rd or wr data memory
	    RegWr       = 1;          // Write to rd
	    BrOp        = 2'bxx;
	    Load_sel    = 3'b1xx;     // normal
	    Store_sel   = 2'b1x;      // normal
	    ALUOp       = ALUadd;     // ALU add
        end
     default: 
       begin
            Branch      = 1'b0;       // PC = PC + 4
	    Jump        = 1'b0;       // no jump
	    PCspecial   = 1'b0;       // no jalr
	    MemtoReg    = 1'b0;       // ALU result -> registers files
	    Asel        = 2'b00;      // 1st ALU operand from rs1
	    ALUSrc      = 2'b00;      // 2nd ALU operand from rs2
	    MemRd       = 1'b0;       // don't rd or wr data memory
	    MemWr       = 1'b0;       // don't rd or wr data memory
	    RegWr       = 1;          // Write to rd
	    ALUOp       = ALUnop;      // ALU or
	    BrOp        = 2'bxx;
	    Load_sel    = 3'b1xx;     // normal
	    Store_sel   = 2'b1x;      // normal
      end
    endcase
  end
end
endmodule
