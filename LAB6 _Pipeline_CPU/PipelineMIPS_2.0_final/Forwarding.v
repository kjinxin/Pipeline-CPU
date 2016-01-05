// 转发处理模块
module Forwarding
(
		input [4:0] RsIF_ID,
		input [4:0] RtIF_ID,
		input [4:0] RsID_EX,
		input [4:0] RtID_EX,
		input [4:0] RdEX_MEM,
		input RegWriteEX_MEM,
		input RegWriteMEM_WB,
		input [4:0] RdMEM_WB,
		output [1:0] C_A,
		output [1:0] C_B,
		output C_RsIF,
		output C_RtIF,
		input MemReadID_EX
);

assign C_A[0]= RegWriteEX_MEM && (RdEX_MEM!=0) && (RdEX_MEM==RsID_EX);
assign C_B[0]= RegWriteEX_MEM && (RdEX_MEM!=0) && (RdEX_MEM==RtID_EX);
assign C_A[1]= RegWriteMEM_WB && (RdMEM_WB!=0) && (RdEX_MEM!=RsID_EX) && (RdMEM_WB==RsID_EX);
assign C_B[1]= RegWriteMEM_WB && (RdMEM_WB!=0) && (RdEX_MEM!=RtID_EX) && (RdMEM_WB==RtID_EX);

assign C_RsIF= MemReadID_EX && (RtID_EX==RsIF_ID);
assign C_RtIF= MemReadID_EX && (RtID_EX==RtIF_ID);
endmodule 