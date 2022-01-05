module Data_Memory(
 input           clk            ,
 //input           rst_n          ,
 input  [31:0]   Address        ,
 input  [31:0]   DataWrite      ,
 input           MemWr,MemRd    ,
 output [31:0]   ReadData           
);
initial begin
    $readmemh("DataMem.txt",DataMem);
	 //$writememh("DataMem.txt",DataMem);
end
//(* mem1 = "mem1.mif" *) 
 reg [31:0] DataMem[0:255];
 wire [7:0] addr = Address[7:0];
  
always @(posedge clk) 
  begin
    if (MemWr == 1)                  
         DataMem[addr] <= DataWrite;
  end
assign ReadData = (MemRd == 1) ? DataMem[addr] : 0; 

endmodule
