module EX_MEM(
	input stall, clock, flush,
	input Overflow,
	input [31:0] Branch_addr,
	input [2:0] Condition,
	input Branch,
	input [3:0] MemOp,
	input MemWrite,
	input RegWrite,
	input MemRead,
	input [31:0] MemData,
	input [31:0] WBData,
	input Less,
	input Z,
	input V,
	input [4:0] Rd,
	output reg Overflow_out,
	output reg [31:0] Branch_addr_out,
	output reg [2:0] Condition_out,
	output reg Branch_out,
	output reg [3:0] MemOp_out,
	output reg MemWrite_out,
	output reg RegWrite_out,
	output reg MemRead_out,
	output reg [31:0] MemData_out,
	output reg [31:0] WBData_out,
	output reg Less_out,
	output reg Z_out,
	output reg V_out,
	output reg [4:0] Rd_out
);
	initial
	begin
		Overflow_out<=0;
		Branch_addr_out<=0;
		Condition_out<=0;
		Branch_out<=0;
		MemOp_out<=0;
		MemWrite_out<=0;
		RegWrite_out<=0;
		MemRead_out<=0;
		MemData_out<=0;
		WBData_out<=0;
		Less_out<=0;
		Z_out<=0;
		V_out<=0;
		Rd_out<=0;
	end
	

	always @ (posedge clock)
	begin
		if (!stall)
		begin
			Overflow_out <= Overflow;
			Branch_addr_out <= Branch_addr;
			Condition_out <= Condition;
			Branch_out <= Branch;
			MemOp_out <= MemOp;
			MemWrite_out <= MemWrite;
			RegWrite_out <= RegWrite;
			MemRead_out <= MemRead;
			MemData_out <= MemData;
			WBData_out <= WBData;
			Less_out <= Less;
			Z_out <= Z;
			V_out <= V;
		   Rd_out <= Rd;     
		end
		if (flush)
		begin
			Overflow_out <= 1'b0;
			Branch_addr_out <= 32'b0;
			Condition_out <= 3'b0;
			Branch_out <= 1'b0;
			MemOp_out <= 2'b0;
			MemWrite_out <= 1'b0;
			RegWrite_out <= 1'b0;
			MemRead_out <= 1'b0;
			MemData_out <= 32'b0;
			WBData_out <= 32'b0;
			Less_out <= 1'b0;
			Z_out <= 1'b0;
			V_out <= 1'b0;
		   Rd_out <= 4'b0;   
		end
	end
endmodule

