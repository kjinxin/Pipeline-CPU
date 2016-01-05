// 立即数扩展模块
module ExtendImm(
	input [15:0] Imm,
	input [1:0] ExtendI,
	output reg [31:0] Imm32
);
	always @(*)
	begin
		case (ExtendI)
		2'd0:
			Imm32 <= {{16{Imm[15]}}, Imm};
		2'd1:
			Imm32 <= {{16{1'b0}}, Imm};
		2'd2:
			Imm32 <= {{14{Imm[15]}}, Imm, 2'b0};
		2'd3:
			Imm32 <= {Imm, 16'b0};
		endcase
	end
endmodule
