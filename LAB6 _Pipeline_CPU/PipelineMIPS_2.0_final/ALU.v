module ALU(
	input [31:0] A_in, B_in,
	input [3:0] ALU_op,
	output [31:0] ALU_out,
	output Zero, Overflow_out, Less
);
	wire [2:0] ALU_ctr;
	wire [31:0] sel[7:0];
	wire negative, carry, overflow;
	wire [31:0] o_out, b_not;
	
	ALU_controller ac(ALU_op, ALU_ctr);//ALU控制器
	adder adr(ALU_op[0], A_in, b_not, carry, overflow , o_out); //加法器
	
	assign b_not={32{ALU_op[0]}}^B_in;
	assign Zero = (o_out==0);
	assign negative = o_out[31];
	assign Less = (ALU_op[0] & ALU_op[2] & ~ALU_op[3] & ALU_op[1]) ? (~carry):(overflow^negative);
	assign Overflow_out = overflow & ALU_op[1] & ALU_op[2] & ALU_op[3];
	
	//计算Sel=0的线路
	calculate_zero cz(A_in^{32{ALU_op[0]}},sel[0]);
	
	//计算Sel=1的线路
	assign sel[1]=A_in^B_in;
	
	//计算Sel=2的线路
	assign sel[2]=A_in | B_in;
	
	//计算Sel=3的线路
	assign sel[3]=~sel[2];
	
	//计算Sel=4的线路
	assign sel[4]=A_in & B_in;
	
	//计算Sel=5的线路
	assign sel[5]=Less?1:0;

	//计算Sel=6的线路
	assign sel[6]=ALU_op[0]?{{16{B_in[15]}}, B_in[15:0]}:{{24{B_in[7]}}, B_in[7:0]};
	
	//计算Sel=7的线路
	assign sel[7]=o_out;

	//使用ALU_ctr选择一个作为ALU_out
	assign ALU_out=sel[ALU_ctr];
	
endmodule

//计算前导0
module calculate_zero(
	input [31:0] in,
	output reg [31:0] out
);
	always @ (in)
	begin
		if (in[31]) out<=0;
		else if (in[30]) out<=1;
		else if (in[29]) out<=2;
		else if (in[28]) out<=3;
		else if (in[27]) out<=4;
		else if (in[26]) out<=5;
		else if (in[25]) out<=6;
		else if (in[24]) out<=7;
		else if (in[23]) out<=8;
		else if (in[22]) out<=9;
		else if (in[21]) out<=10;
		else if (in[20]) out<=11;
		else if (in[19]) out<=12;
		else if (in[18]) out<=13;
		else if (in[17]) out<=14;
		else if (in[16]) out<=15;
		else if (in[15]) out<=16;
		else if (in[14]) out<=17;
		else if (in[13]) out<=18;
		else if (in[12]) out<=19;
		else if (in[11]) out<=20;
		else if (in[10]) out<=21;
		else if (in[9]) out<=22;
		else if (in[8]) out<=23;
		else if (in[7]) out<=24;
		else if (in[6]) out<=25;
		else if (in[5]) out<=26;
		else if (in[4]) out<=27;
		else if (in[3]) out<=28;
		else if (in[2]) out<=29;
		else if (in[1]) out<=30;
		else if (in[0]) out<=31;
		else out<=32;
	end
endmodule

module ALU_controller(
	input [3:0] ALU_op,
	output [2:0] ALU_ctr
);
	assign ALU_ctr[2]=(~ALU_op[3] & ~ALU_op[1])|(~ALU_op[3] & ALU_op[2] & ALU_op[0])|(ALU_op[3] & ALU_op[1]);
	assign ALU_ctr[1]=(~ALU_op[3] & ~ALU_op[2] & ~ALU_op[1])|(ALU_op[3] & ~ALU_op[2] & ~ALU_op[0])|(ALU_op[2] & ALU_op[1] & ~ALU_op[0])|(ALU_op[3] & ALU_op[1]);
	assign ALU_ctr[0]=(~ALU_op[2] & ~ALU_op[1])|(~ALU_op[3] & ALU_op[2] & ALU_op[0])|(ALU_op[3] & ALU_op[2] & ALU_op[1]);
endmodule

/*
ALU_op	ALU_ctr	功能
-----------------------------------
0 0 0 0	1 1 1		加法（不产生溢出）
0 0 0 1	1 1 1		减法（不产生溢出）
0 0 1 0	0 0 0		前导零
0 0 1 1	0 0 0		前导一
0 1 0 0	1 0 0		与
0 1 0 1	1 0 1		slt/slti
0 1 1 0	0 1 0		或
0 1 1 1	1 0 1		sltu/sltiu
1 0 0 0	0 1 1		或非
1 0 0 1	0 0 1		异或
1 0 1 0	1 1 0		seb
1 0 1 1	1 1 0		seh
1 1 1 0	1 1 1		加法（可产生溢出）
1 1 1 1	1 1 1		减法（可产生溢出）
*/
