module RegisterFile(
	input      [4:0]  readreg1, readreg2, writereg,
	input      [31:0] writedata,
	input             write,clk,rst_n,
	output reg [31:0] readdata1, readdata2	
);


//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [31:0] register [0:31];
//=======================================================
//  Behavioral coding
//=======================================================
integer i;
always @ (posedge clk) begin
if (!rst_n) begin
		for (i=0;i<32;i=i+1) begin
		register[i] <= 32'b0;
	   end
end
else begin
		if (write && writereg !=0) begin
			register[writereg]<=writedata;
		end
end
end
always @ (*) begin
	if(!rst_n||readreg1==0) begin
		readdata1<=0;
	end else if (!write && readreg1 == writereg) begin
		readdata1 <= writedata;
	end else begin
		readdata1 <= register[readreg1];
	end
end
always @ (*) begin
	if(!rst_n||readreg2==0) begin
		readdata2<=0;
	end else if (!write && readreg2 == writereg) begin
		readdata2 <= writedata;
	end else begin
		readdata2 <= register[readreg2];
	end
end
endmodule
