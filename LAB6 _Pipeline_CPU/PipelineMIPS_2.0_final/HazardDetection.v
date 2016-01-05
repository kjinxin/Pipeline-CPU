// 冒险检测模块
module HazardDetection(
	input [4:0] IF_ID_Rt, IF_ID_Rs,
	input IF_ID_RtRead,
	input Jump,
	input ID_EX_MemRead,
	input [4:0] ID_EX_Rt,
	input Branch,
	output reg [1:0] PCSrc,
	output reg IF_ID_Stall, IF_ID_Flush,
	output reg ID_EX_Stall, ID_EX_Flush,
	output reg MEM_WB_Stall, MEM_WB_Flush,
	output reg EX_MEM_Stall, EX_MEM_Flush 
);

	wire LoadUse = ID_EX_MemRead && ((ID_EX_Rt==IF_ID_Rs) || (ID_EX_Rt==IF_ID_Rt && IF_ID_RtRead));
	
	/* This pins are not used in this project */
	initial
	begin
		ID_EX_Stall <= 1'b0;
		MEM_WB_Flush <= 1'b0;
		EX_MEM_Stall <= 1'b0;
		MEM_WB_Stall <= 1'b0;
		IF_ID_Flush <= 1'b0;
		IF_ID_Stall <= 1'b0;
		ID_EX_Flush <= 1'b0;
		EX_MEM_Flush <= 1'b0;
		PCSrc <= 1'b0;
	end
	
	always @(*)
	begin
		if (Branch)	 // Branch
		begin
			IF_ID_Flush <= 1'b1;
			IF_ID_Stall <= 1'b0;
			ID_EX_Flush <= 1'b1;
			EX_MEM_Flush <= 1'b1;
			PCSrc <= 2'd2;
		end
		else if (Jump) // Jump
		begin
			IF_ID_Flush <= 1'b1;
			IF_ID_Stall <= 1'b0;
			ID_EX_Flush <= 1'b1;
			EX_MEM_Flush <= 1'b0;
			PCSrc <= 2'd1;
		end
		else if (LoadUse) // load-use
		begin
			IF_ID_Flush <= 1'b0;
			ID_EX_Flush <= 1'b1;
			IF_ID_Stall <= 1'b1;
			EX_MEM_Flush <= 1'b0;
			PCSrc <= 2'd0; 
		end
		else
		begin
			IF_ID_Flush <= 1'b0;
			IF_ID_Stall <= 1'b0;
			ID_EX_Flush <= 1'b0;
			EX_MEM_Flush <= 1'b0;
			PCSrc <= 1'b0;
		end
	end
endmodule

