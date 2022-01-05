module Control_Unit(
    //input            clk      ,
    //input            rst_n    ,
    //input            BrEq     ,
    //input            BrLT     ,
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
    case(opcode)
    R:
        case(funct3)
         3'b000:
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
					 case (funct7)
					     7'b0000000:    ALUOp = ALUadd; // ALU add
						  7'b0100000:    ALUOp = ALUsub; // ALU sub
		              default:       ALUOp = ALUadd; // ALU add
		          endcase				  
           end	
			3'b001: //sll
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
					 ALUOp       = ALUsll;    // ALU sll
					 BrOp        = 2'bxx;
					 Load_sel    = 3'b1xx;    // normal
					 Store_sel   = 2'b1x;     // normal
            end
			3'b010: //slt
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
					 ALUOp       = ALUslt;    // ALU slt
					 BrOp        = 2'bxx;
					 Load_sel    = 3'b1xx;    // normal
					 Store_sel   = 2'b1x;     // normal
            end
        3'b011: //sllu
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
					 ALUOp       = ALUsltu;    // ALU sllu
					 BrOp        = 2'bxx;
					 Load_sel    = 3'b1xx;    // normal
					 Store_sel   = 2'b1x;     // normal
            end	
	     3'b100: //xor
            begin
                Branch      = 1'b0;       // PC = PC + 4
					 Jump        = 1'b0;       // no jump
					 PCspecial   = 1'b0;      // no jalr
					 MemtoReg    = 1'b0;       // ALU result -> registers files
					 Asel        = 2'b00;      // 1st ALU operand from rs1
					 ALUSrc      = 2'b00;      // 2nd ALU operand from rs2
					 MemRd       = 1'b0;       // don't rd or wr data memory
					 MemWr       = 1'b0;       // don't rd or wr data memory
					 RegWr       = 1;          // Write to rd
					 ALUOp       = ALUxor;     // ALU xor
					 BrOp        = 2'bxx;
					 Load_sel    = 3'b1xx;    // normal
					 Store_sel   = 2'b1x;     // normal
            end			
		  3'b101: //srl or sra
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
					 case(funct7)
				        7'b0000000: ALUOp = ALUsrl; // ALU srl
			           7'b0100000: ALUOp = ALUsra; // ALU sra	
				        default:    ALUOp = ALUsrl; // ALU srl
			       endcase
				  end
		  3'b110: //or
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
					 ALUOp       = ALUor;     // ALU or
					 BrOp        = 2'bxx;
					 Load_sel    = 3'b1xx;    // normal
					 Store_sel   = 2'b1x;     // normal
            end
		  3'b111: //and
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
					 ALUOp       = ALUand;    // ALU and
					 BrOp        = 2'bxx;
					 Load_sel    = 3'b1xx;    // normal
					 Store_sel   = 2'b1x;     // normal
            end
        endcase
	 
    I:
        case(funct3)
        3'b000: //addi
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
					 ALUOp       = ALUadd;
				end
			3'b001: //sll
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
					 ALUOp       = ALUsll;    // ALU sll
            end
			3'b010: //slti
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
					 ALUOp       = ALUslt;    // ALU slt
            end
        3'b011: //sltui
            begin
                Branch      = 1'b0;       // PC = PC + 4
					 Jump        = 1'b0;       // no jump
					 PCspecial   = 1'b0;       // no jalr
					 MemtoReg    = 1'b0;       // ALU result -> registers files
					 Asel        = 2'b00;      // 1st ALU operand from rs1
					 ALUSrc      = 2'b01;      // 2nd ALU operand from imm
					 MemRd       = 1'b0;       // don't rd or wr data memory
					 MemWr       = 1'b0;       // don't rd or wr data memory
					 RegWr       = 1;          // Write to rd
					 BrOp        = 2'bxx;
					 Load_sel    = 3'b1xx;     // normal
					 Store_sel   = 2'b1x;      // normal
					 ALUOp       = ALUsltu;    // ALU sltu
            end	
	     3'b100: //xori
            begin
                Branch      = 1'b0;       // PC = PC + 4
					 Jump        = 1'b0;       // no jump
					 PCspecial   = 1'b0;       // no jalr
					 MemtoReg    = 1'b0;       // ALU result -> registers files
					 Asel        = 2'b00;      // 1st ALU operand from rs1
					 ALUSrc      = 2'b01;      // 2nd ALU operand from imm
					 MemRd       = 1'b0;       // don't rd or wr data memory
					 MemWr       = 1'b0;       // don't rd or wr data memory
					 RegWr       = 1;          // Write to rd
					 BrOp        = 2'bxx;
					 Load_sel    = 3'b1xx;     // normal
					 Store_sel   = 2'b1x;      // normal
					 ALUOp       = ALUxor;     // ALU xor
            end			
		  3'b101: //srli or srai
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
					 case(funct7)
			           7'b0000000: ALUOp = ALUsrl; // ALU srl 
			           7'b0100000: ALUOp = ALUsra; // ALU sra
			           default:    ALUOp = ALUsra; // ALU sra
			       endcase
			    end
		  3'b110: //ori
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
					 ALUOp       = ALUor;     // ALU or
            end
		  3'b111: //andi
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
					 ALUOp       = ALUand;    // ALU and
            end
        endcase	 
    ld:
	     case(funct3)
		  3'b000: // lb
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
					 Load_sel    = 3'b000;    // lb
					 Store_sel   = 2'bxx;     // normal
					 ALUOp       = ALUadd;    // ALU add
            end
		3'b001: // lh
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
					 Load_sel    = 3'b001;    // lb
					 Store_sel   = 2'bxx;     // normal
					 ALUOp       = ALUadd;    // ALU add
            end
		  3'b010: // lw
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
					 Load_sel    = 3'b1xx;    // lw
					 Store_sel   = 2'bxx;     // normal
					 ALUOp       = ALUadd;    // ALU add
            end
		  3'b100: // lbu
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
					 Load_sel    = 3'b010;    // lbu
					 Store_sel   = 2'bxx;     // normal
					 ALUOp       = ALUadd;    // ALU add
            end
		  3'b101: // lb
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
					 Load_sel    = 3'b011;    // lhu
					 Store_sel   = 2'bxx;     // normal
					 ALUOp       = ALUadd;    // ALU add
            end
		  default:
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
					 Load_sel    = 3'b1xx;    // lw
					 Store_sel   = 2'bxx;     // normal
					 ALUOp       = ALUadd;    // ALU add
            end
		  endcase
    st:
	     case(funct3)
		  3'b000: //sb
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
					 Store_sel   = 2'b00;     // sb
					 ALUOp       = ALUadd;    // ALU add
            end 
		 3'b001: //sh
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
					 Store_sel   = 2'b01;     // sh
					 ALUOp       = ALUadd;    // ALU add
            end 
		  3'b010: //sw
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
					 Store_sel   = 2'b1x;     // sw
					 ALUOp       = ALUadd;    // ALU add
            end 
		  default:
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
					 Store_sel   = 2'b1x;     // sw
					 ALUOp       = ALUadd;    // ALU add
            end 
		  endcase
    B:
		  case(funct3)
        3'b000: //beq
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
				BrOp        = 2'b00;
				Load_sel    = 3'b1xx;     // normal
				Store_sel   = 2'b1x;      // normal
        end
		  3'b001: //bne
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
				BrOp        = 2'b01;
				Load_sel    = 3'b1xx;     // normal
				Store_sel   = 2'b1x;      // normal
        end
		  3'b100: //blt
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
				BrOp        = 2'b10;
				Load_sel    = 3'b1xx;     // normal
				Store_sel   = 2'b1x;      // normal
        end
		  3'b101: //bge
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
				BrOp        = 2'b11;
				Load_sel    = 3'b1xx;     // normal
				Store_sel   = 2'b1x;      // normal
        end
		  3'b110: //bltu
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
				ALUOp       = ALUsltu;    // ALU compare
				BrOp        = 2'b10;
				Load_sel    = 3'b1xx;     // normal
				Store_sel   = 2'b1x;      // normal
        end
		  3'b111: //bgeu
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
				ALUOp       = ALUsltu;    // ALU compare
				BrOp        = 2'b11;
				Load_sel    = 3'b1xx;    // normal
				Store_sel   = 2'b1x;      // normal
        end
		  default:
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
				BrOp        = 2'b00;
				Load_sel    = 3'b1xx;    // normal
				Store_sel   = 2'b1x;      // normal
		  end
	  endcase
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
				ALUOp       = ALUor;      // ALU or
				BrOp        = 2'bxx;
				Load_sel    = 3'b1xx;     // normal
				Store_sel   = 2'b1x;      // normal
		  end
    endcase
end
endmodule
