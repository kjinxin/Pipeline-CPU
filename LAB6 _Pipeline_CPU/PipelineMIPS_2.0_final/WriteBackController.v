//回写控制器
module WriteBackController(
	input [1:0] WBData, // the lowest 2 bits of WBData
	input [3:0] MemOp,
	output reg [3:0] WBType
);
	always @ (*)
	begin
		case (MemOp)
			4'b0010: // lw 
				WBType <= 4'b1111;
			4'b0011: // lwl
			case (WBData)
				2'b00: WBType <= 4'b1111;
				2'b01: WBType <= 4'b1110;
				2'b10: WBType <= 4'b1100;
				2'b11: WBType <= 4'b1000;
			endcase
			4'b0101: // lwr
			case (WBData)
				2'b00: WBType <= 4'b0001;
				2'b01: WBType <= 4'b0011;
				2'b10: WBType <= 4'b0111;
				2'b11: WBType <= 4'b1111;
			endcase	
			default:  //lb, lbu, lh, lhu
				WBType <= 4'b1111; //modified
		endcase
	end
endmodule
