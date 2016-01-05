// 条件检测模块：计算寄存器、存储器写入信号是否有效
module ConditionCheck(
	input [2:0] Condition,
	input Branch,
	input Overflow,
	input RegWrite,
	input Less, Zero, V,
	output reg BranchValid,
	output reg RegWriteValid
);
	always @(*)
	begin
		if (Overflow && V) // if overflow
		begin
			BranchValid <= 1'b0;
			RegWriteValid <= 1'b0;
		end
		else
		case (Condition)
		3'd0: begin  // no comparing
			BranchValid <= Branch;   //modified
			RegWriteValid <= RegWrite; //modified
		end
		3'd1: begin // =
			BranchValid <= Zero & Branch;
			RegWriteValid <= Zero & RegWrite;
		end
		3'd2: begin // !=
			BranchValid <= (~Zero) & Branch;
			RegWriteValid <= (~Zero) & RegWrite;
		end
		3'd3: begin // >
			BranchValid <= (~(Less | Zero)) & Branch;
			RegWriteValid <= (~(Less | Zero)) & RegWrite;
		end
		3'd4: begin // >=
			BranchValid <= (~Less) & Branch;
			RegWriteValid <= (~Less) & RegWrite;
		end
		3'd5: begin // <
			BranchValid <= Less & Branch;
			RegWriteValid <= Less & RegWrite;
		end
		3'd6: begin // <=
			BranchValid <= (Less | Zero) & Branch;
			RegWriteValid <= (Less | Zero) & RegWrite;
		end
		3'd7: begin
			// didn't use this
			BranchValid <= 1'b1;
			RegWriteValid <= 1'b1;
		end
		endcase
	end

endmodule
