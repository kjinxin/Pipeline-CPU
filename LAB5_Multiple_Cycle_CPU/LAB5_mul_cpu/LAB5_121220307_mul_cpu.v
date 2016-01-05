module LAB5_121220307_mul_cpu
(
		input clk,   // the clock
		output PC_write_cond, // the condition that we need to control the PC write
		output PC_write,  // control whether to write in PC
		output Iord,     // IR selector control 
		output [1:0] MemtoReg, 
		output [31:0] Mem_addr_in,
		output [3:0] Mem_byte_write, // control whether to write in memory
		output RegDt0, 
		output IR_write,
		output [1:0] RegDst,
		output [2:0] Condition,
		output ALUSrcA,    // the selector control of ALU output of A
		output [2:0] ALUSrcB, // the selector control of ALU output of B
		output [3:0] ALU_op,  // ALU option control
		output Ex_top,
		output [1:0] Shift_op,  // the shift option 
		output Shift_amountSrc, // shift selector
		output [1:0] PC_source,  // PC selector
		output ALUShift_sel,   // ALU output selector
		output AddrReg_write_en,   
		output [3:0] Rd_write_byte_en,
		output [31:0] busA,
		output [31:0] busB,
		output [31:0] PC_out,
		output [31:0] ALU_out,
		output [31:0] AddrReg_out,
		output Overflow,
		output Less,
		output Zero,
		output [3:0] state,
		output [31:0] IR,
		output [31:0] ALUShift_out,
		output [31:0] Shift_out,
		output [4:0] Rs,Rd,Rt,
		output [31:0] A,B,
		output [31:0] Rt_out_shift,
		output [31:0] Rd_in
);
wire [4:0] Shift_amount;
wire [31:0] Ex_offset;
wire [31:0] Mem_data_shift,Mem_data_out;
wire [31:0] PC_in;
wire PC_write_en;
wire sel_out;

// PC control signal 
assign PC_write_en=PC_write|(PC_write_cond&sel_out);
// PC counter module 
PC_counter PC_counter_1(clk,PC_in,PC_write_en,PC_out);

// selector of Mem_addr_in
sel_32 sel_32_3(AddrReg_out,PC_out,Iord,Mem_addr_in);

// memory register 
Mem_reg Mem_reg_1(clk,Mem_addr_in,Rt_out_shift,Mem_byte_write,Mem_data_out);

// instruction register 
IR_reg IR_reg_1(clk,Mem_data_out,IR_write,IR);

// the control signal module of multipal cpu 
Cpu_control Cpu_1(clk,Overflow,IR,PC_write_cond,PC_write,Iord,MemtoReg,Mem_addr_in[1:0],
						Mem_byte_write,RegDt0,IR_write,RegDst,Condition,ALUSrcA,ALUSrcB,ALU_op,
						Ex_top,Shift_op,Shift_amountSrc,PC_source,ALUShift_sel,AddrReg_write_en,
						Rd_write_byte_en,state);
assign Rs=IR[25:21];

// selector of Rt address 
sel_5 sel_5_1(5'b00000,IR[20:16],RegDt0,Rt);

// selector of Rd address 
sel_5_4 sel_5_4_1(5'b00000,5'b11111,IR[15:11],IR[20:16],RegDst,Rd);

// extension of the 
Extend16_32 Ext_1(IR[15:0],Ex_top,Ex_offset);

// the group of registers 
registers_32 reg_32(Rs,Rt,Rd,Rd_in,Rd_write_byte_en,~clk,A,B);

// selector of busA
sel_32 sel_32_1(A, PC_out, ALUSrcA, busA);

// selector of busB 
sel_32_5 sel_32_5_1({IR[15:0],16'h0000},{Ex_offset[29:0],2'b00},Ex_offset,32'h00000004,B,ALUSrcB,busB);

// ALU calculation module 
ALU ALU_1(busA,busB,ALU_op,ALU_out,Zero,Less,Overflow);

// selector of Shift_amount
sel_5 sel_5_2(A[4:0],IR[10:6],Shift_amountSrc,Shift_amount);

// barrel shifter 
shift_reg shift_reg_1(B,Shift_amount,Shift_op,Shift_out);

// selector of ALUShift_out 
sel_32 sel_32_2(Shift_out,ALU_out,ALUShift_sel,ALUShift_out);

// selector of Rd_in 
sel_32_4 sel_32_4_1(32'h00000000,ALU_out,Mem_data_shift,AddrReg_out,MemtoReg,Rd_in);

// selector of sel_out 
sel_1_8 sel_1_8_1(1'b1,Less,Less|Zero,~(Less|Zero),~Less,~Zero,Zero,0,Condition,sel_out);

// address register 
addr_reg addr_reg_1(clk,ALUShift_out,AddrReg_write_en,AddrReg_out);

// selector of PC_in 
sel_32_4 sel_32_4_2(A,{PC_out[31:28],IR[25:0],2'b00},AddrReg_out,ALUShift_out,PC_source,PC_in);

// memory output shifter 
mem_shift mem_shift_1(Mem_addr_in[1:0],Mem_data_out,IR[31:26],Mem_data_shift);

// register output shifter 
reg_shift reg_shift_1(Mem_addr_in[1:0],B,IR[31:26],Rt_out_shift); 
endmodule

module Cpu_control
(
	input clk,
	input Overflow,
	input [31:0] IR,
	output reg PC_write_cond,
	output reg PC_write,
	output reg IorD,
	output reg [1:0] MemtoReg,
	input [1:0] Mem_adder_in,	
	output reg [3:0] Mem_byte_write,
	output reg RegDt0,
	output reg IR_write,
	output reg [1:0] RegDst,
	output reg [2:0] Condition,
	output reg ALUSrcA,
	output reg [2:0] ALUSrcB,
	output reg [3:0] ALU_op,
	output reg Ex_top,
	output reg [1:0] Shift_op,
	output reg Shift_amountSrc,
	output reg [1:0] PC_source,
	output reg ALUShift_sel,
	output reg AddrReg_write_en, 
	output reg [3:0] Rd_write_byte_en,
	output reg [3:0] state
);
initial 
begin 
	state<=4'h0;
end 
// Declare states
parameter [3:0] PCM = 4'h0, IFetch = 4'h1, RFetch_ID = 4'h2, MemAdr = 4'h3, lwFinish = 4'h4, SwFinish = 4'h5, 
			 Rexec = 4'h6, RFinish = 4'h7, Iexec = 4'h8 , Brexec = 4'h9, BrFinish = 4'ha, JumpFinish = 4'hb;
    
	 
// Determine the next state
always @ (posedge clk) 
begin
		case (state)
			PCM:
				state <= IFetch;
			IFetch:
				state <= RFetch_ID;
			RFetch_ID:
				begin
					case (IR[31:26])
						6'b000001: state<=Brexec;
						6'b000010: state<=JumpFinish;
						6'b100010,6'b100011: state<=MemAdr;
						6'b101110,6'b101011: state<=SwFinish;
						6'b000000,6'b011100,6'b011111: state<=Rexec;
						default: state<=Iexec;
					endcase
				end 
			MemAdr:
				state <= lwFinish;
			lwFinish:
				state <= PCM;
			SwFinish:
				state <= PCM;
			Rexec:
				state <= RFinish;
			RFinish:
				state <= PCM;
			Iexec:
				state <= PCM;
			Brexec:
				state <= BrFinish;
			BrFinish:
				state <= PCM;
			JumpFinish:
				state <= PCM;
			default:
				state <= PCM;
		endcase
end
// Output depends only on the state
always @ (*)
begin
		PC_write_cond=0;
		PC_write=0;
		IorD=0;
		MemtoReg=2'b00;	
		Mem_byte_write=4'b0000;
		RegDt0=0;
		IR_write=0;
		RegDst=2'b00;
		Condition=3'b000;
		ALUSrcA=0;
		ALUSrcB=3'b000;
		ALU_op=4'b0000;
		Ex_top=0;
		Shift_op=2'b00;
		Shift_amountSrc=0;
	 	PC_source=2'b01;
		ALUShift_sel=0;
		AddrReg_write_en=0;
		Rd_write_byte_en=4'b0000;
		case (state)
			PCM:
			begin
				IorD = 0;
				Mem_byte_write = 4'b0000;
			end
			IFetch:
			begin
				ALUSrcA = 0; 
				IR_write=1;
				AddrReg_write_en=0;
				ALUSrcB = 3'b001;
				ALU_op = 4'b0000;
				ALUShift_sel = 0;
				PC_source=2'b00;
				PC_write=1;
			end
			RFetch_ID:
			begin
				ALUSrcA=1;
				ALUShift_sel=0;
				AddrReg_write_en=1;
				case(IR[31:26])
					6'b001000:   //   addi 
						begin
							ALU_op=4'b1110;
							ALUSrcB=3'b010;
							Ex_top=1;
						end
					6'b001001:   //  addiu 
						begin
							ALU_op=4'b0000;
							ALUSrcB=3'b010;
							Ex_top=1;   // modified
						end
					6'b001111:   //  LUI 
						begin
							ALU_op=4'b0000;
							ALUSrcB=3'b100;
							Ex_top=0; //  modified
						end
					6'b001110:   //  XORI 
						begin
							ALU_op=4'b1001;   //modified 0110;
							ALUSrcB=3'b010;
							Ex_top=0;
						end
					6'b001010:   //  STLI  
						begin
							ALU_op=4'b0101;
							ALUSrcB=3'b010;
							Ex_top=1;
						end
					6'b101110,6'b101011:   // sw, swr 
						begin
							Ex_top=1;
							ALUSrcB=3'b010;
							ALU_op=4'b0000;
						end 
					default: Ex_top=0;
				endcase
			end
			MemAdr:
			begin
				ALUSrcA = 1;
				ALUSrcB = 3'b010;
				Ex_top = 1;
				ALU_op=4'b0000;
				ALUShift_sel=0;
				AddrReg_write_en=1;
			end
			lwFinish:
			begin
				IorD=1;
				MemtoReg=2'b01;
				if(IR[31:26]==6'b100010)
				begin
				if(Mem_adder_in==2'b00) Rd_write_byte_en=4'b1111;
				else if(Mem_adder_in==2'b01) Rd_write_byte_en=4'b1110;
				else if(Mem_adder_in==2'b10) Rd_write_byte_en=4'b1100;
				else Rd_write_byte_en=4'b1000;
				end
				else if(IR[31:26]==6'b100011)
				begin
				Rd_write_byte_en=4'b1111;
				end
				RegDst=2'b00;
			end
			SwFinish:
			begin
				RegDt0=0;
				Ex_top=1;
				ALUSrcA=1;
				ALUSrcB=3'b010;
				ALUShift_sel=0;
				AddrReg_write_en=1;
				ALU_op=4'b0000;
				IorD=1;
				if(IR[31:26]==6'b101110)
				begin
				if(Mem_adder_in==2'b00)Mem_byte_write=4'b1000;
				else if(Mem_adder_in==2'b01)Mem_byte_write=4'b1100;
				else if(Mem_adder_in==2'b10)Mem_byte_write=4'b1110;
				else Mem_byte_write=4'b1111;
				end
				else if(IR[31:26]==6'b101011)
				begin
				Mem_byte_write=4'b1111;
				end
			end
			Rexec:
			begin
				case(IR[31:26])
					6'b000000:
					begin
						case(IR[5:0])
						6'b100000:   // add 
							begin
								ALU_op=4'b1110;
								ALUShift_sel=0;
							end
						6'b100010:   // sub 
							begin
								ALU_op=4'b1111;
								ALUShift_sel=0;
							end
						6'b100011:   // subu
							begin
								ALU_op=4'b0001;
								ALUShift_sel=0;
							end
						6'b101011:   // sltu 
							begin
								ALU_op=4'b0111;
								ALUShift_sel=0;
							end
						6'b100111:     // nor
							begin
								ALU_op=4'b1000;
								ALUShift_sel=0;
							end 
						6'b000111:   // srav 
							begin
								ALUShift_sel=1;
								Shift_amountSrc=1;
								Shift_op=2'b10;
							end
						6'b000010:   //  srl
							begin
								ALUShift_sel=1;
								Shift_amountSrc=0;
								Shift_op=2'b11;
							end
						endcase
					end
					6'b011111:     // seb
						begin
							ALU_op=4'b1010;
							ALUShift_sel=0;
						end
					6'b011100:
					begin				
						case(IR[5:0])
							6'b100001:   //clo
								begin
									ALU_op=4'b0011;
									ALUShift_sel=0;
								end
							6'b100000:  //clz
								begin
									ALU_op=4'b0010;
									ALUShift_sel=0;
								end
						endcase
					end
				endcase
				ALUSrcA = 1;
				ALUSrcB = 3'b000;
				RegDt0=0;
				AddrReg_write_en=1;
			end
			RFinish:
			begin
				MemtoReg=2'b00;
				RegDst = 2'b01;
				if(Overflow==0)
				Rd_write_byte_en=4'b1111;
				else 
				Rd_write_byte_en=4'b0000;
			end
			Iexec:
			begin
				MemtoReg=2'b00;
				RegDst=2'b00;
				if(Overflow==0)
				Rd_write_byte_en=4'b1111;
				else 
				Rd_write_byte_en=4'b0000;
			end
			Brexec:
			begin
				ALUSrcA=0;
				ALUSrcB=3'b011;
				ALU_op=4'b0000;
				Ex_top=1;
				MemtoReg=2'b10;
				AddrReg_write_en=1;
				ALUShift_sel=0;
				RegDst=2'b10;
				Rd_write_byte_en=4'b1111;
			end
			BrFinish:
			begin
				Condition=3'b011;
				RegDt0=1;
				ALU_op=4'b0001;
				ALUSrcA=1;
				ALUSrcB=3'b000;
				PC_source=2'b01;
				PC_write=0;
				PC_write_cond=1;
			end
			JumpFinish:
			begin
				PC_source=2'b10;
				PC_write=1;
			end
			default:
			begin
				PC_write_cond=0;
				PC_write=0;
				IorD=0;
				MemtoReg=2'b00;	
				Mem_byte_write=4'b0000;
				RegDt0=0;
				IR_write=0;
				RegDst=2'b00;
				Condition=3'b000;
				ALUSrcA=0;
				ALUSrcB=3'b000;
				ALU_op=4'b0000;
				Ex_top=0;
				Shift_op=2'b00;
				Shift_amountSrc=0;
				PC_source=2'b01;
				ALUShift_sel=0;
				AddrReg_write_en=0;
				Rd_write_byte_en=4'b0000;
			end
		endcase
	end

endmodule


// register output shifter 
module reg_shift
(
		input [1:0] Mem_addr_in,  // the select option of sel_8_4
		input [31:0] Rt_out,      // the data input 
		input [31:26] IR,         // the select option of sel_8_8
		output [31:0] Rt_out_shift  // the output after shift
);

wire [2:0] Rt_out_shift_ctr;     // the shift controler 
assign Rt_out_shift_ctr[2]=IR[31]&~IR[30]&IR[29]&(~IR[28]&IR[27]||IR[27]&~IR[26]);
assign Rt_out_shift_ctr[1]=IR[31]&~IR[30]&IR[29]&(~IR[28]&~IR[27]&IR[26]||IR[28]&IR[27]&~IR[26]);
assign Rt_out_shift_ctr[0]=IR[31]&~IR[30]&IR[29]&(~IR[28]&IR[27]&~IR[26]);

wire [31:0] Rt_out_l,Rt_out_r;   // ultra variables 

// the selectors of Rt_out_l and Rt_out_r 
sel_8_4 sel_8_4_1(Rt_out[7:0],8'h00,8'h00,8'h00,Mem_addr_in,Rt_out_r[7:0]);
sel_8_4 sel_8_4_2(Rt_out[31:24],Rt_out[23:16],Rt_out[15:8],Rt_out[7:0],Mem_addr_in,Rt_out_l[7:0]);
sel_8_4 sel_8_4_3(Rt_out[15:8],Rt_out[7:0],8'h00,8'h00,Mem_addr_in,Rt_out_r[15:8]);
sel_8_4 sel_8_4_4(8'h00,Rt_out[31:24],Rt_out[23:16],Rt_out[15:8],Mem_addr_in,Rt_out_l[15:8]);
sel_8_4 sel_8_4_5(Rt_out[23:16],Rt_out[15:8],Rt_out[7:0],8'h00,Mem_addr_in,Rt_out_r[23:16]);
sel_8_4 sel_8_4_6(8'h00,8'h00,Rt_out[31:24],Rt_out[23:16],Mem_addr_in,Rt_out_l[23:16]);
sel_8_4 sel_8_4_7(Rt_out[31:24],Rt_out[23:16],Rt_out[15:8],Rt_out[7:0],Mem_addr_in,Rt_out_r[31:24]);
sel_8_4 sel_8_4_8(8'h00,8'h00,8'h00,Rt_out[31:24],Mem_addr_in,Rt_out_l[31:24]);

// the selectors of the Rt_out_shift 
sel_8_8 sel_8_8_1(8'h00,Rt_out_r[7:0],Rt_out_l[7:0],Rt_out_l[7:0],8'h00,Rt_out[7:0],8'h00,Rt_out[7:0],Rt_out_shift_ctr,Rt_out_shift[7:0]);
sel_8_8 sel_8_8_2(8'h00,Rt_out_r[15:8],Rt_out_l[15:8],Rt_out_l[15:8],8'h00,Rt_out[15:8],8'h00,Rt_out[7:0],Rt_out_shift_ctr,Rt_out_shift[15:8]);
sel_8_8 sel_8_8_3(8'h00,Rt_out_r[23:16],Rt_out_l[23:16],Rt_out_l[23:16],8'h00,Rt_out[7:0],8'h00,Rt_out[7:0],Rt_out_shift_ctr,Rt_out_shift[23:16]);
sel_8_8 sel_8_8_4(8'h00,Rt_out_r[31:24],Rt_out_l[31:24],Rt_out_l[31:24],8'h00,Rt_out[15:8],8'h00,Rt_out[7:0],Rt_out_shift_ctr,Rt_out_shift[31:24]);

endmodule


// memorty output shifter 
module mem_shift
(
		input [1:0] Mem_addr_in,   //the select option of sel_8_4
		input [31:0] Mem_data_out,  // the data input 
		input [31:26] IR,         // the select option of sel_8_8
		output [31:0] Mem_data_shift   // the output data after shift 
);

wire [2:0] Mem_data_shift_ctr;   // the shift controler 
assign Mem_data_shift_ctr[2]=IR[31]&~IR[30]&~IR[29]&(~IR[28]&IR[27]||IR[27]&~IR[26]);
assign Mem_data_shift_ctr[1]=IR[31]&~IR[30]&~IR[29]&(~IR[27]&IR[26]||IR[28]&IR[27]&~IR[26]);
assign Mem_data_shift_ctr[0]=IR[31]&~IR[30]&~IR[29]&(IR[28]&~IR[27]||~IR[28]&IR[27]&~IR[26]);

wire [31:0] Mem_d_l,Mem_d_r;
wire [7:0] Mem_31;

// the selectors of the Mem_d_l,Mem_d_r
sel_8_4 sel_8_4_9(Mem_data_out[7:0],Mem_data_out[15:8],Mem_data_out[23:16],Mem_data_out[31:24],Mem_addr_in,Mem_d_r[7:0]);
sel_8_4 sel_8_4_10(8'h00,8'h00,8'h00,Mem_data_out[7:0],Mem_addr_in,Mem_d_l[7:0]);
sel_8_4 sel_8_4_11(Mem_data_out[15:8],Mem_data_out[23:16],Mem_data_out[31:24],8'h00,Mem_addr_in,Mem_d_r[15:8]);
sel_8_4 sel_8_4_12(8'h00,8'h00,Mem_data_out[7:0],Mem_data_out[15:8],Mem_addr_in,Mem_d_l[15:8]);
sel_8_4 sel_8_4_13(Mem_data_out[23:16],Mem_data_out[31:24],8'h00,8'h00,Mem_addr_in,Mem_d_r[23:16]);
sel_8_4 sel_8_4_14(8'h00,Mem_data_out[7:0],Mem_data_out[15:8],Mem_data_out[23:16],Mem_addr_in,Mem_d_l[23:16]);
sel_8_4 sel_8_4_15(Mem_data_out[31:24],8'h00,8'h00,8'h00,Mem_addr_in,Mem_d_r[31:24]);
sel_8_4 sel_8_4_16(Mem_data_out[7:0],Mem_data_out[15:8],Mem_data_out[23:16],Mem_data_out[31:24],Mem_addr_in,Mem_d_l[31:24]);
assign Mem_31=(Mem_d_l[31])?8'hff:8'h00;

// the selectors of the Mem_data_shift
sel_8_8 sel_8_8_5(8'h00,Mem_d_r[7:0],Mem_d_l[7:0],Mem_d_l[7:0],Mem_d_l[23:16],Mem_d_l[23:16],Mem_d_l[31:24],Mem_d_l[31:24],Mem_data_shift_ctr,Mem_data_shift[7:0]);
sel_8_8 sel_8_8_6(8'h00,Mem_d_r[15:8],Mem_d_l[15:8],Mem_d_l[15:8],Mem_d_l[31:24],Mem_d_l[31:24],8'h00,Mem_31,Mem_data_shift_ctr,Mem_data_shift[15:8]);
sel_8_8 sel_8_8_7(8'h00,Mem_d_r[23:16],Mem_d_l[23:16],Mem_d_l[23:16],8'h00,Mem_31,8'h00,Mem_31,Mem_data_shift_ctr,Mem_data_shift[23:16]);
sel_8_8 sel_8_8_8(8'h00,Mem_d_r[31:24],Mem_d_l[31:24],Mem_d_l[31:24],8'h00,Mem_31,8'h00,Mem_31,Mem_data_shift_ctr,Mem_data_shift[31:24]);

endmodule
//select module 

module sel_8_4  // 8 bits 4 choose 1
(
	input [7:0] data3,  
	input [7:0] data2,
	input [7:0] data1,
	input [7:0] data0,
	input [1:0] Op,
	output reg [7:0] result
);

always @ (*)
begin
	case (Op)
		2'b11: result=data3;
		2'b10: result=data2;
		2'b01: result=data1;
		2'b00: result=data0;
	endcase 
end
endmodule


module sel_8_8  // 8 bit 8 choose 1
(
	input [7:0] c7,
	input [7:0] c6,
	input [7:0] c5,
	input [7:0] c4,
	input [7:0] c3,
	input [7:0] c2,
	input [7:0] c1,
	input [7:0] c0,
	input [2:0] Condition,
	output reg [7:0] Op
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

module sel_5   // five bits 2 choose 1
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

module sel_5_4  // 5 bits 4 choose 1
(
	input [4:0] data3,
	input [4:0] data2,
	input [4:0] data1,
	input [4:0] data0,
	input [1:0] Op,
	output reg [4:0] result
);

always @ (*)
begin
	case (Op)
		2'b11: result=data3;
		2'b10: result=data2;
		2'b01: result=data1;
		2'b00: result=data0;
	endcase 
end
endmodule

module sel_32  // 32 bits 2 choose 1
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

module sel_32_4  // 32 bits 4 choose 1
(
	input [31:0] data3,
	input [31:0] data2,
	input [31:0] data1,
	input [31:0] data0,
	input [1:0] Op,
	output reg [31:0] result
);

always @ (*)
begin
	case (Op)
		2'b11: result=data3;
		2'b10: result=data2;
		2'b01: result=data1;
		2'b00: result=data0;
	endcase 
end
endmodule

module sel_32_5  // 32 bits 5 choose 1
(
	input [31:0] data4,
	input [31:0] data3,
	input [31:0] data2,
	input [31:0] data1,
	input [31:0] data0,
	input [2:0] Op,
	output reg [31:0] result
);

always @ (*)
begin
	case (Op)
		3'b100: result=data4;
		3'b011: result=data3;
		3'b010: result=data2;
		3'b001: result=data1;
		3'b000: result=data0;
		default: result=32'h0;
	endcase 
end
endmodule

module sel_1_8  // 1 bit 8 choose 1
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

// the group of registers 
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
		for(i=0;i<32;i=i+1)
			register[i]=i;
		register[1] = 32'b11111010101011000000101100110101;
		register[2] = 32'b00000001010101010010001111010111;
		register[3] = 32'b01110010101001000010101100100101;
		register[4] = 32'b01001001010100010001001101010111; 
		register[31]=32'h7FFFFFFF;
		register[30]=32'h80000000;
		register[29]=32'h7FFFFFF0;
end
always @ (posedge clk)
begin
	 register[0]=32'b0;
    if (rd_addr!=0)
    begin
        if (Rd_byte_w_en[0]==1) register[rd_addr][7:0]<=rd_in[7:0]; //write in lower 8 bits
        if (Rd_byte_w_en[1]==1) register[rd_addr][15:8]<=rd_in[15:8]; //write in mid lower 8 bits
        if (Rd_byte_w_en[2]==1) register[rd_addr][23:16]<=rd_in[23:16]; //write in mid higher 8 bits
        if (Rd_byte_w_en[3]==1) register[rd_addr][31:24]<=rd_in[31:24]; //write in higher 8 bits
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

module Mem_reg
(
		input clk,      // the clock 
		input [31:0] Mem_addr,   // memory write address 
		input [31:0] Mem_data_in,   // memory write data
		input [3:0] Mem_byte_w_en,   // memory write control signal of each byte
		output [31:0] Mem_data_out      // read from memory 
);

reg [7:0] mem[127:0];
reg [31:0] temp;

initial begin
	$readmemb("testcode", mem);
end
initial 
begin
		{mem[3],mem[2],mem[1],mem[0]} = 32'b00000000001000100010100000100000;       //add       R5 = R1+R2
		{mem[7],mem[6],mem[5],mem[4]} = 32'b00000000100000110011000000100000;       //add       R6 = R4+R3
		{mem[11],mem[10],mem[9],mem[8]} = 32'b00100000101001110110011100101010;     //addi      R7 = R5+16'b0110011100101010;
		{mem[15],mem[14],mem[13],mem[12]} = 32'b00100100111010000111001010110011;   //addiu     R8 = R7+16'b0111001010110011;
		{mem[19],mem[18],mem[17],mem[16]} = 32'b00000001000000100100100000100010;   //sub       R9 = R8-R2
		{mem[23],mem[22],mem[21],mem[20]} = 32'b00000001001000010101000000100010;   //sub       R10 = R9-R1
		{mem[27],mem[26],mem[25],mem[24]} = 32'b00000001001010100101100000100011;   //subu      R11 = R9-R10
		{mem[31],mem[30],mem[29],mem[28]} = 32'b01111100000010110110010000100000;   //seb       R12 = (R11[7:0]kuozhan)
		{mem[35],mem[34],mem[33],mem[32]} = 32'b00111100000011010111100011001011;   //lui       R13 = 16'b0111100011001011||16'h0000;
		{mem[39],mem[38],mem[37],mem[36]} = 32'b00111001100011101101010101011101;   //xori      R14 = R12^1101010101011101
		{mem[43],mem[42],mem[41],mem[40]} = 32'b01110001101000000111100000100000;   //clz       R15 = clz R13
		{mem[47],mem[46],mem[45],mem[44]} = 32'b01110001110000001000000000100001;   //clo       R16 = clo R14
		{mem[51],mem[50],mem[49],mem[48]} = 32'b00000001111000101000100000000111;   //srav      R17 = r2 >> r15;
		{mem[55],mem[54],mem[53],mem[52]} = 32'b00000000001000011001001010000010;   //rotr      R18 = R1[sa-1:0]||R1[31:sa]
		{mem[59],mem[58],mem[57],mem[56]} = 32'b00000000001000101001100000101011;   //sltu      R19 = R1<R2
		{mem[63],mem[62],mem[61],mem[60]} = 32'b00101000001101000111111111111111;   //slti      R20 = R1<16'b0111111111111111
		{mem[67],mem[66],mem[65],mem[64]} = 32'b00001000000000000000000000010010;   //j   18
		{mem[71],mem[70],mem[69],mem[68]} = 32'b00000000001000100001100000100000;   //add       R3 = R1+R2
		{mem[75],mem[74],mem[73],mem[72]} = 32'b00000100000100010000000000000000;   //bgezal    if R17>0 then PC=PC+16'b00000000000000100
		{mem[79],mem[78],mem[77],mem[76]} = 32'b00000000101111110010100000100111;   //nor		 r5=~(r5|r31)
		{mem[83],mem[82],mem[81],mem[80]} = 32'b00101000001101000111111111111111;   //slti      R20 = R1<16'b0111111111111111
		{mem[87],mem[86],mem[85],mem[84]} = 32'b10001000000110000000000001111010; 	 //lwl 		 r24, 122(r0); 	r24=0x05040018;
		{mem[91],mem[90],mem[89],mem[88]} = 32'b00000000000110001100000000100000;   //add       R24 = R0+R24
		{mem[95],mem[94],mem[93],mem[92]} = 32'b10111000000000010000000001111001;	 //swr 		 r1, 121(r0); 		r1=32’hfaac0b35;
		{mem[99],mem[98],mem[97],mem[96]} = 32'b10001100000111000000000001111000;	 //lw 		 r28, 120(r0); 	r28=32’h0b350302;
		{mem[103],mem[102],mem[101],mem[100]} = 32'b00000000000111001110000000100000;   //add   R28 = R0+R28
		{mem[107],mem[106],mem[105],mem[104]} = 32'b10101100000000010000000001111000;	  //sw    r1, 120(r0); 		m[120]=32’hfaac0b35;
		{mem[111],mem[110],mem[109],mem[108]} = 32'b10001100000111010000000001111000;	  //lw    r29, 120(r0); 	r29=32’hfaac0b35;
		{mem[115],mem[114],mem[113],mem[112]} = 32'b00000000000111011110100000100000;   //add   R29 = R0+R29
		{mem[119],mem[118],mem[117],mem[116]} = 32'b00001000000000000000000000000010;   //j 2, the 8th instruction;
		{mem[123],mem[122],mem[121],mem[120]} = 32'b00000101000001000000001100000010;// m[123,122,121,120]=[5,4,3,2];
		{mem[127],mem[126],mem[125],mem[124]} = 32'b00000101000001000000001100000010;// m[123,122,121,120]=[5,4,3,2];
end 
always @ (posedge clk)
begin
		temp={Mem_addr[31:2],2'b00};
		if (Mem_byte_w_en[0]==1) mem[temp]<=Mem_data_in[7:0]; //write in lower 8 bits
      if (Mem_byte_w_en[1]==1) mem[temp+1]<=Mem_data_in[15:8]; //write in mid lower 8 bits
      if (Mem_byte_w_en[2]==1) mem[temp+2]<=Mem_data_in[23:16]; //write in mid higher 8 bits
      if (Mem_byte_w_en[3]==1) mem[temp+3]<=Mem_data_in[31:24]; //write in higher 8 bits
end 
assign Mem_data_out={mem[Mem_addr+3],mem[Mem_addr+2],mem[Mem_addr+1],mem[Mem_addr]};
endmodule 

module addr_reg
(
		input clk,   // the clock 
		input [31:0] AddrReg_in,   // the input data
		input AddrReg_write_en,   // the controler
		output reg [31:0] AddrReg_out    // the output 
);

initial
AddrReg_out=32'h00000000;
always @ (posedge clk)
if (AddrReg_write_en)
	AddrReg_out=AddrReg_in;
endmodule

module IR_reg
(
		input clk,  // the clock
		input [31:0] IR_in, // the input instruction
		input IR_write_en,   // the controler
		output reg [31:0] IR    // the instruction that we want 
);
initial 
IR=32'h00000000;
always @ (posedge clk)
if (IR_write_en)
	IR=IR_in;
endmodule 

module PC_counter
(
		input clk,  // the clock 
		input [31:0] PC_in, // the input PC
		input PC_write_en,   // the control signal 
		output reg [31:0] PC_out    // the output PC
);
initial
PC_out=32'h00000000;
always @ (posedge clk)
if (PC_write_en)
	PC_out=PC_in;
endmodule
