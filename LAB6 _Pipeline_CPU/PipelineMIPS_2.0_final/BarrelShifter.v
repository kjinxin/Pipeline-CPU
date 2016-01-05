module BarrelShifter(
	input [31:0] Shift_in,
	input [4:0] Shift_amount,
	input [1:0] Shift_op,
	output [31:0] Shift_out
);
	//分别是移了1位、2位、4位、8位、16位的结果
	wire [31:0] shift0, shift1, shift2, shift3;

	//如果Shift_amount[0]有效，则按照各模式移动1位，下同
	assign shift0=Shift_amount[0]?
					  ((Shift_op[1]==1'b0)?
					  ((Shift_op[0]==1'b0)?{Shift_in[30:0],1'b0}:{1'b0,Shift_in[31:1]}):
					  ((Shift_op[0]==1'b0)?{Shift_in[31],Shift_in[31:1]}:{Shift_in[0],Shift_in[31:1]})
					  ):Shift_in;
	assign shift1=Shift_amount[1]?
					  ((Shift_op[1]==1'b0)?
					  ((Shift_op[0]==1'b0)?{shift0[29:0],2'b0}:{2'b0,shift0[31:2]}):
					  ((Shift_op[0]==1'b0)?{{2{Shift_in[31]}},shift0[31:2]}:{shift0[1:0],shift0[31:2]})
					  ):shift0;
	assign shift2=Shift_amount[2]?
					  ((Shift_op[1]==1'b0)?
					  ((Shift_op[0]==1'b0)?{shift1[27:0],4'b0}:{4'b0,shift1[31:4]}):
					  ((Shift_op[0]==1'b0)?{{4{Shift_in[31]}},shift1[31:4]}:{shift1[3:0],shift1[31:4]})
					  ):shift1;
	assign shift3=Shift_amount[3]?
					  ((Shift_op[1]==1'b0)?
					  ((Shift_op[0]==1'b0)?{shift2[23:0],8'b0}:{8'b0,shift2[31:8]}):
					  ((Shift_op[0]==1'b0)?{{8{Shift_in[31]}},shift2[31:8]}:{shift2[7:0],shift2[31:8]})
					  ):shift2;
	assign Shift_out=Shift_amount[4]?
						  ((Shift_op[1]==1'b0)?
						  ((Shift_op[0]==1'b0)?{shift3[15:0],16'b0}:{16'b0,shift3[31:16]}):
						  ((Shift_op[0]==1'b0)?{{16{Shift_in[31]}},shift3[31:16]}:{shift3[15:0],shift3[31:16]})
						  ):shift3;
endmodule


/* Shift_op	Function
  ---------------------
	00			逻辑左移
	01			逻辑右移
	10			算术右移
	11			循环右移
*/
