module single_cpu
(
	input clk,                      // the clk signal
	output [31:0] PC_out,           // the IR 
	output [31:0] IR,               // the instrument that we read 
	output [31:0] busA,             // the data we get from registers
	output [31:0] busB,             // the data we get from registers
	output [31:0] ALU_out,          // the result after ALU operation
	output [31:0] ALUShift_out,     // the ALU result after shift operation 
	output [3:0] Rd_write_byte_en,  //  the writen enable of the register write operation 
	output [1:0] ALUsrcB,           //  
	output Ex_top,
	output [3:0] ALU_op,
	output RegDst,
	output Shift_amountSrc,
	output ALUShift_sel,
	output [2:0] Condition,
	output [1:0] Shift_op,
	output Jump,
	output Overflow,
	output Less,
	output Zero
);
wire [4:0] Rd,Rs,Rt,Shift_amount;
wire [31:0] result,B;
wire [31:0] Ex_offset,Shift_out;
wire RegDst0,Op;
GetIR GetIR_1(PC_out,IR);
assign Rs=IR[25:21];
Cpu_control Cpu_1(IR,Jump,Shift_op,Ex_top,Shift_amountSrc,RegDst,ALU_op,ALUShift_sel,Condition,ALUsrcB,Overflow,Rd_write_byte_en,RegDst0);
sel_5 sel_5_1(IR[15:11],IR[20:16],RegDst,Rd);
sel_5 sel_5_2(5'b00000,IR[20:16],RegDst0,Rt);
registers_32 reg_32(Rs,Rt,Rd,ALUShift_out,Rd_write_byte_en,~clk,busA,B);
Extend16_32 Ext_1(IR[15:0],Ex_top,Ex_offset);
sel_32_03 sel_32_03_1({IR[15:0],16'h0000},Ex_offset,B,ALUsrcB,busB);
ALU ALU_1(busA,busB,ALU_op,ALU_out,Zero,Less,Overflow);
sel_5 sel_5_3(busA[4:0],IR[10:6],Shift_amountSrc,Shift_amount);
shift_reg shift_reg_1(B,Shift_amount,Shift_op,Shift_out);
sel_32 sel_32_2(Shift_out,ALU_out,ALUShift_sel,ALUShift_out);
sel_7 sel_7_1(1'b1,Less,Less|Zero,~(Less|Zero),~Less,~Zero,Zero,1'b0,Condition,Op);
PC_counter PC_counter_1(clk,PC_out,IR,Ex_offset,Op,Jump,PC_out);
endmodule


// Cpu_control module
module Cpu_control
(
	input [31:0] IR,
	output Jump,
	output [1:0]Shift_op,
	output Ex_op,
	output Shift_amountSrc,
	output RegDst,
	output [3:0] ALU_op,
	output ALUShift_sel,
	output [2:0] Condition,
	output [1:0] ALUsrcB,
	input Overflow,
	output [3:0] Rd_write_byte_en,
	output RegDst0
); 
wire [5:0] op;
wire [5:0] fun;
assign op=IR[31:26];
assign fun=IR[5:0];                    
assign Jump=(op==6'b000010);
assign Shift_op[1]=((op==6'b000000)&((fun==6'b000111)|(fun==6'b000010)));
assign Shift_op[0]=((op==6'b000000)&(fun==6'b000010));
assign Ex_op=((op==6'b000001)|(op==6'b001000)|(op==6'b001010));
assign Shift_amountSrc=((op==6'b000000)&&(fun==6'b000111));
assign RegDst=((op==6'b000000)|(op==6'b011100)|(op==6'b011111));
assign ALU_op[3]=(((op==6'b000000)&((fun==6'b100000)|(fun==6'b100010)))|(op==6'b001000)|(op==6'b001110)|(op==6'b011111));
assign ALU_op[2]=(((op==6'b000000)&((fun==6'b100000)|(fun==6'b100010)|(fun==6'b101011)))|(op==6'b001000)|(op==6'b001010));
assign ALU_op[1]=(((op==6'b000000)&((fun==6'b100000)|(fun==6'b100010)|(fun==6'b101011)))|(op==6'b001000)|(op==6'b011100)|(op==6'b011111));
assign ALU_op[0]=(((op==6'b000000)&((fun==6'b100011)|(fun==6'b101011)|(fun==6'b100010)))|(op==6'b000001)|(op==6'b001010)|(op==6'b001110)|((op==6'b011100)&(fun==6'b100001)));
assign ALUShift_sel=((op==6'b000000)&((fun==6'b000111)|(fun==6'b000010)));
assign Condition[2]=1'b0;
assign Condition[1]=(op==6'b000001);
assign Condition[0]=(op==6'b000001);
assign ALUsrcB[1]=(op==6'b001111);
assign ALUsrcB[0]=((op==6'b001000)|(op==6'b001001)|(op==6'b001010)|(op==6'b001110));
assign Rd_write_byte_en[3]=~((Overflow==1'b0)|(~(((op==6'b000000)&((fun==6'b100000)|(fun==6'b100010)))|(op==6'b000001)|(op==6'b000010)|(op==6'b001000))));
assign Rd_write_byte_en[2]=~((Overflow==1'b0)|(~(((op==6'b000000)&((fun==6'b100000)|(fun==6'b100010)))|(op==6'b000001)|(op==6'b000010)|(op==6'b001000))));
assign Rd_write_byte_en[1]=~((Overflow==1'b0)|(~(((op==6'b000000)&((fun==6'b100000)|(fun==6'b100010)))|(op==6'b000001)|(op==6'b000010)|(op==6'b001000))));
assign Rd_write_byte_en[0]=~((Overflow==1'b0)|(~(((op==6'b000000)&((fun==6'b100000)|(fun==6'b100010)))|(op==6'b000001)|(op==6'b000010)|(op==6'b001000))));
assign RegDst0=(op==6'b000001);
endmodule
// get the Instrument 
module GetIR
(
	input [31:0] addr,   //the address of the IR that we want 
	output [31:0] IR     // store the IR
);
reg [7:0] inst[75:0];
initial
begin
	{inst[3],inst[2],inst[1],inst[0]} = 32'b00000000001000100010100000100000;       //add       R5 = R1+R2
	{inst[7],inst[6],inst[5],inst[4]} = 32'b00000000100000110011000000100000;       //add       R6 = R4+R3
	{inst[11],inst[10],inst[9],inst[8]} = 32'b00100000101001110110011100101010;     //addi      R7 = R5+16'b0110011100101010;
	{inst[15],inst[14],inst[13],inst[12]} = 32'b00100100111010000111001010110011;   //addiu     R8 = R7+16'b0111001010110011;
	{inst[19],inst[18],inst[17],inst[16]} = 32'b00000001000000100100100000100010;   //sub       R9 = R8-R2
	{inst[23],inst[22],inst[21],inst[20]} = 32'b00000001001000010101000000100010;   //sub       R10 = R9-R1
	{inst[27],inst[26],inst[25],inst[24]} = 32'b00000001001010100101100000100011;   //subu      R11 = R9-R10
	{inst[31],inst[30],inst[29],inst[28]} = 32'b01111100000010110110010000100000;   //seb       R12 = (R11[7:0]kuozhan)
	{inst[35],inst[34],inst[33],inst[32]} = 32'b00111100000011010111100011001011;   //lui       R13 = 16'b0111100011001011||16'h0000;
	{inst[39],inst[38],inst[37],inst[36]} = 32'b00111001100011101101010101011101;   //xori      R14 = R12^1101010101011101
	{inst[43],inst[42],inst[41],inst[40]} = 32'b01110001101000000111100000100000;   //clz       R15 = clz R13
	{inst[47],inst[46],inst[45],inst[44]} = 32'b01110001110000001000000000100001;   //clo       R16 = clo R14
	{inst[51],inst[50],inst[49],inst[48]} = 32'b00000001111000101000100000000111;   //srav      R17 = r2 >> r15;
	{inst[55],inst[54],inst[53],inst[52]} = 32'b00000000001000011001001010000010;   //rotr      R18 = R1[sa-1:0]||R1[31:sa]
	{inst[59],inst[58],inst[57],inst[56]} = 32'b00000000001000101001100000101011;   //sltu      R19 = R1<R2
	{inst[63],inst[62],inst[61],inst[60]} = 32'b00101000001101000111111111111111;   //slti      R20 = R1<16'b0111111111111111
	{inst[67],inst[66],inst[65],inst[64]} = 32'b00001000000000000000000000010010;   //j   18
	{inst[71],inst[70],inst[69],inst[68]} = 32'b00000000001000100001100000100000;   //add       R3 = R1+R2
	{inst[75],inst[74],inst[73],inst[72]} = 32'b00000100011000010000000000000111;   //bgez      if R3>0 then PC=PC+18'b000000000000011100
end
assign IR={inst[addr+3],inst[addr+2],inst[addr+1],inst[addr]};
endmodule 

// to calculate PC
module PC_counter
(	
	input clk,
	input [31:0] PC_in,
	input [31:0] IR,
	input [31:0] Ex_offset,
	input Op,
	input Jump,
	output reg [31:0] PC_out
);
initial 
begin
	PC_out=32'h00000000;
end 
reg [31:0] D_out;
reg [31:0] PC;
always @ (posedge clk)
begin
	PC=PC_in+4;
	if (Op==0&&Jump==0)
		PC_out=PC;
	else
	if (Jump==1)
		PC_out={PC[31:28],IR[25:0],2'b00};
	else
		PC_out=PC+{Ex_offset[29:0],2'b00};
end 
endmodule

//select module 
module sel_5   // five bits selecter
(
	input [4:0] A,
	input [4:0] B,
	input Op,
	output reg [4:0] result
);
always @ (A or B or Op)
	if (Op) result=A;
	else result=B;
endmodule 

module sel_32  // 32 bits selecter
(
	input [31:0] A,
	input [31:0] B,
	input Op,
	output reg [31:0] result
);
always @ (Op or A or B)
	if (Op) result=A;
	else result=B;
endmodule

module sel_32_03
(
	input [31:0] A,
	input [31:0] B,
	input [31:0] C,
	input [1:0] Op,
	output reg [31:0] result
);
always @ (*)
begin
	case (Op)
		2'b10: result=A;
		2'b01: result=B;
		2'b00: result=C;
		2'b11: result=C;
	endcase
end

endmodule
module sel_7  // 7 choose 1
(
	input c7,
	input c6,
	input c5,
	input c4,
	input c3,
	input c2,
	input c1,
	input c0,
	input [2:0] Condition,
	output reg Op
);
always @(*)
begin
	case (Condition[2:0])
		3'b000: Op=c0;
		3'b001: Op=c1;
		3'b010: Op=c2;
		3'b011: Op=c3;
		3'b100: Op=c4;
		3'b101: Op=c5;
		3'b110: Op=c6;
		3'b111: Op=c7;
	endcase 
end
endmodule
//Extend 16bits to 32bits
module Extend16_32
(
	input [15:0] cin,  // the 16 bits data that we want to extend
	input Op,          
	output reg [31:0] result  // the 32bits data after we extend
);
always @ (*)
	if (Op&&cin[15]) result=32'hffff0000|cin;
	else result=32'h0000ffff&cin;
endmodule



//registers group module 
module registers_32
#(parameter data_width=32,parameter addr_width=5)
(
    input [addr_width-1:0] rs_addr,rt_addr,rd_addr,  //the addresses of write and read
    input [data_width-1:0] rd_in,  //32 bits data that need to be input
    input [3:0] Rd_byte_w_en,  //write enable
    input clk,  //the clock
    output [data_width-1:0] rs_out,rt_out  //32 bits data to be output
);

reg [data_width-1:0] register[2**addr_width-1:0];  // the register group

integer i;
initial
begin
		for (i=0; i<32; i=i+1)
			register[i] = i;
		register[1] = 32'b11111010101011000000101100110101;
		register[2] = 32'b00000001010101010010001111010111;
		register[3] = 32'b01110010101001000010101100100101;
		register[4] = 32'b01001001010100010001001101010111; 
	
	/*register[1]=32'h93479873; register[2]=32'h93479873; register[3]=32'h93479873; register[4]=32'h93479873;
	register[5]=32'h93479873; register[6]=32'h93479873; register[7]=32'h93479873; register[8]=32'h93479873;
	register[9]=32'h93479873; register[10]=32'h93479873; register[11]=32'h93479873; register[12]=32'h93479873;
	register[13]=32'h93479873; register[14]=32'h93479873; register[15]=32'h93479873; register[16]=32'h93479873;
	register[17]=32'h93479873; register[18]=32'h93479873; register[19]=32'h93479873; register[20]=32'h93479873;
	register[21]=32'h93479873; register[22]=32'h93479873; register[23]=32'h93479873; register[24]=32'h93479873;
	register[25]=32'h93479873; register[26]=32'h93479873; register[27]=32'h93479873; register[28]=32'h93479873;
	register[29]=32'h93479873; register[30]=32'h93479873; register[31]=32'h93479873; */
end
always @ (posedge clk)
begin
	 register[0]=32'b0;
    if (rd_addr!=0)
    begin
        if (Rd_byte_w_en[0]==0) register[rd_addr][7:0]<=rd_in[7:0]; //write in lower 8 bits
        if (Rd_byte_w_en[1]==0) register[rd_addr][15:8]<=rd_in[15:8]; //write in mid lower 8 bits
        if (Rd_byte_w_en[2]==0) register[rd_addr][23:16]<=rd_in[23:16]; //write in mid higher 8 bits
        if (Rd_byte_w_en[3]==0) register[rd_addr][31:24]<=rd_in[31:24]; //write in higher 8 bits
    end
end

assign   rs_out=register[rs_addr];  //read from rs_addr
assign   rt_out=register[rt_addr];  //read from rt_addr 
endmodule

// the shift bits registers 
module shift_reg
(
	input [31:0] Shift_in, // the input data that we want to shif_in
	input [4:0] Shift_amount, // the amount that we want to shift the data
	input [1:0] Shift_op,   // choose which style that we want to shift
	output reg [31:0] Shift_out // the data that after we shift
);
integer i;
always @ (*)
begin
	case (Shift_op)
		2'b00:
				begin
					Shift_out=Shift_in<<Shift_amount;  //logic left shift
				end
		2'b01:
				begin
					Shift_out=Shift_in>>Shift_amount;  // logic right shift
				end
		2'b10:
				begin
					for (i=31; i>=0; i=i-1)
					begin
						if (i>31-Shift_amount)
							Shift_out[i]=Shift_in[31];
						else
							Shift_out[i]=Shift_in[i+Shift_amount];  // algebra right shift
					end
				end
		2'b11:
				begin
					for (i=31; i>=0; i=i-1)
					begin
						if (i>31-Shift_amount)
							Shift_out[i]=Shift_in[i-32+Shift_amount];
						else
							Shift_out[i]=Shift_in[i+Shift_amount];  // circle right shift 
					end
				end
	endcase
end
endmodule 


//ALU module 
module ALU
(
	input [31:0] A, // the operate data A
	input [31:0] B, // the operate data B
	input [3:0] ALU_op, // the control logic
	output reg [31:0] ALU_out, // the final data to output accoring the operation
	output reg Zero,  // the flag zero
	output reg Less,  // the flag Less
	output reg Overflow // the flag overflow 
);
reg [2:0] ALU_ctr;
reg [31:0] register,tempA,tempB;
reg Carry,Negative;
integer i,j;
reg k;
always @ (*)
begin
	ALU_ctr[2]=((~ALU_op[3])&(~ALU_op[1]))|((~ALU_op[3])&(ALU_op[2])&(ALU_op[0]))|((ALU_op[3])&(ALU_op[1]));
	ALU_ctr[1]=((~ALU_op[3])&(~ALU_op[2])&(~ALU_op[1]))|((ALU_op[3])&(~ALU_op[2])&(~ALU_op[0]))|((ALU_op[2])&(ALU_op[1])&(~ALU_op[0]))|((ALU_op[3])&(ALU_op[1]));
	ALU_ctr[0]=((~ALU_op[2])&(~ALU_op[1]))|((~ALU_op[3])&(ALU_op[2])&(ALU_op[0]))|((ALU_op[3])&(ALU_op[2])&(ALU_op[1]));
	// calculate the control numbers
	tempA=A; tempB=B; // 
	if (ALU_op[0]) tempB=~tempB;   // if it is the sub operation, we need to reverse
	{Carry,register}=tempA+tempB+ALU_op[0];  // to calculate the ALU_out
	Zero=(register==32'h00000000)?1'b1:1'b0;  // to judge if it is zero 
	Negative=(register[31])?1'b1:1'b0;   // to calculate whether the output is negative
	Overflow=((~tempA[31])&(~tempB[31])&register[31])|(tempA[31]&tempB[31]&(~register[31]));  // calculate the overflow
	Less=(ALU_op==4'b0111)?(~Carry):(Overflow^Negative);   //calculate whether it is less or more
	case (ALU_ctr)
		3'b000: // calculate the leading zero or the leading 1's
			begin
				if (ALU_op[0])
					tempA=~tempA;
				j=0; k=0;
				for (i=31; i>=0; i=i-1)
				begin
					if (tempA[i]==0&&k==0)
					begin 
						j=j+1;
					end 
					else k=1;
				end
				ALU_out=j;
			end
		3'b001:  // operation xor
			begin
				ALU_out=A^B;
			end
		3'b010:   // operation or 
			begin
				ALU_out=A|B;
			end
		3'b011:  // operation not or 
			begin
				ALU_out=~(A|B);
			end
		3'b100:  // operation and 
			begin
				ALU_out=A&B;
			end
		3'b101: // operation slt or sltu
			begin
				ALU_out=(Less)?32'h00000001:32'h00000000;
			end
		3'b110:  // operation seb or seh
			begin
				if (ALU_op[0])
				begin
					if (B[15])
					ALU_out={16'hffff,B[15:0]};
					else
					ALU_out={16'h0000,B[15:0]};
				end
				else
				begin
					if (B[7])
					ALU_out={24'hffffff,B[7:0]};
					else
					ALU_out={24'h000000,B[7:0]};
				end
			end
		3'b111:  // operation on add or sub
			begin
				ALU_out=register;
				Overflow=(ALU_op[1]&ALU_op[2]&ALU_op[3])?Overflow:1'b0;
			end 
	endcase
end 
endmodule