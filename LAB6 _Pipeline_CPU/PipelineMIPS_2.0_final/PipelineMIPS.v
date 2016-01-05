module PipelineMIPS
(
	input clk,
	output [1:0] PCSrc, ExtendI, C_A, C_B,
	output IF_ID_RtRead, RegWrite, BranchValid, OperandA_mux, OperandB_mux,
	output IF_ID_Stall, IF_ID_Flush, ID_EX_Stall, ID_EX_Flush, EX_MEM_Stall, EX_MEM_Flush, MEM_WB_Stall, MEM_WB_Flush,
	output [31:0] PC, Shift_out, ALU_out,
	output [4:0] ReadReg1, ReadReg2, WriteReg, ShiftAmount,
	output [31:0] WB_WBData,
	output [31:0] WB_MemData,
	
	output [4:0] fwd_RsIF_ID,
	output [4:0] fwd_RtIF_ID,
	output [4:0] fwd_RsID_EX,
	output [4:0] fwd_RtID_EX,
	output [4:0] fwd_RdEX_MEM,
	output fwd_RegWriteEX_MEM,
	output fwd_RegWriteMEM_WB,
	output [4:0] fwd_RdMEM_WB,
	output fwd_MemReadID_EX,
	output [4:0] fwd_RdID_EX,
	output ID_Jump,
	output [31:0] MEM_Branch_addr,
	
	output [31:0] MEM_Addr, MEM_data_in,
	output [3:0] MEM_Op,
	output Mem_WriteEn,
	output [31:0] MEM_DataOut,
	output ID_MemWrite,
	output [3:0] WB_WBType,
	output [3:0] MEM_WBType,
	
	output [31:0] Readdata2, ALU_B
);	

	wire  [31:0] PC_in, ALU_A0, ALU_B0, Writedata, Readdata1, ALU_A;

	/*************   IF / ID   *************/
	wire [31:0] IF_IR;
	wire [31:0] IF_PCand4;
	
	wire [31:0] ID_PCand4;
	wire [5:0] ID_Op;
	wire [4:0] ID_Rs;
	wire [4:0] ID_Rt;
	wire [4:0] ID_Rd;
	wire [4:0] ID_Shamt;
	wire [5:0] ID_Func;
	
	//wire IF_ID_Stall, IF_ID_Flush;
	
	IF_ID mod_if_id(clk, IF_ID_Stall, IF_ID_Flush, IF_IR, IF_PCand4, ID_PCand4,
						 ID_Op, ID_Rs, ID_Rt, ID_Rd, ID_Shamt, ID_Func);

	/*************   ID / EX   *************/
	wire ID_ALUSrcA;
	wire [1:0] ID_ALUSrcB;
	wire ID_Branch;
	wire ID_MemRead;
	//wire ID_MemWrite; 
	wire ID_Overflow;
	wire ID_RegWrite;
	wire [1:0] ID_ShiftAmountSel;
	wire [1:0] ID_ExResultSrc;
	//wire ID_Jump;
	wire [3:0] ID_MemOp;
	wire [1:0] ID_RegDst;
	wire [1:0] ID_ShiftOp;
	wire [2:0] ID_Condition;
	wire [31:0] ID_Immediate32;
	wire [31:0] ID_OperandA;
	wire [31:0] ID_OperandB;
	wire [3:0] ID_ALUOp;
	
	wire EX_ALUSrcA;
	wire [1:0] EX_ALUSrcB;
	wire EX_Branch;
	wire EX_MemRead;
	wire EX_MemWrite;
	wire EX_Overflow;
	wire EX_RegWrite;
	wire [1:0] EX_ShiftAmountSel;
	wire [1:0] EX_ExResultSrc;
	wire EX_Jump;
	wire [3:0] EX_MemOp;
	wire [1:0] EX_RegDst;
	wire [1:0] EX_ShiftOp;
	wire [2:0] EX_Condition;
	wire [31:0] EX_Immediate32;
	wire [31:0] EX_OperandA;
	wire [31:0] EX_OperandB;
	wire [31:0] EX_PCand4;
	wire [3:0] EX_ALUOp;
	wire [4:0] EX_Rd;
	wire [4:0] EX_Rs;
	wire [4:0] EX_Rt;
	
	//wire ID_EX_Stall, ID_EX_Flush;
	
	ID_EX mod_id_ex(clk, ID_EX_Stall, ID_EX_Flush, ID_PCand4, EX_PCand4, ID_Overflow, EX_Overflow,
						 ID_Condition, EX_Condition, ID_Branch, EX_Branch, ID_MemOp, EX_MemOp, ID_MemWrite,
						 EX_MemWrite, ID_RegWrite, EX_RegWrite, ID_MemRead, EX_MemRead, ID_Jump, EX_Jump,
						 ID_ExResultSrc, EX_ExResultSrc, ID_ALUSrcA, EX_ALUSrcA, ID_ALUSrcB, EX_ALUSrcB,
						 ID_ALUOp, EX_ALUOp, ID_RegDst, EX_RegDst, ID_ShiftAmountSel, EX_ShiftAmountSel,
						 ID_ShiftOp, EX_ShiftOp, ID_OperandA, EX_OperandA, ID_OperandB, EX_OperandB,
						 ID_Rs, EX_Rs, ID_Rt, EX_Rt, ID_Rd, EX_Rd, ID_Immediate32, EX_Immediate32);

	/*************   EX / MEM *************/
	wire [31:0] EX_Branch_addr;
	wire EX_Less;
	wire EX_Z;
	wire EX_V;
	wire [4:0] EX_Rd_new;
	wire [31:0] EX_MemData;
	wire [31:0] EX_WBData;
	
	wire MEM_Overflow;
	//wire [31:0] MEM_Branch_addr;
	wire MEM_Branch;
	wire MEM_MemWrite;
	wire MEM_RegWrite;
	wire MEM_MemRead;
	wire MEM_Less;
	wire MEM_Z;
	wire MEM_V;
	wire [3:0] MEM_MemOp;
	wire [2:0] MEM_Condition;
	wire [4:0] MEM_Rd;
	wire [31:0] MEM_MemData;
	wire [31:0] MEM_WBData;
	
	//wire EX_MEM_Stall, EX_MEM_Flush;
	
	EX_MEM mod_ex_mem(EX_MEM_Stall, clk, EX_MEM_Flush, EX_Overflow, EX_Branch_addr,
						   EX_Condition, EX_Branch, EX_MemOp, EX_MemWrite, EX_RegWrite,
							EX_MemRead, EX_MemData, EX_WBData, EX_Less, EX_Z, EX_V, EX_Rd_new,
							MEM_Overflow, MEM_Branch_addr, MEM_Condition, MEM_Branch,
							MEM_MemOp, MEM_MemWrite, MEM_RegWrite, MEM_MemRead, MEM_MemData,
							MEM_WBData, MEM_Less, MEM_Z, MEM_V, MEM_Rd);
	
	assign EX_MemData = ALU_B0;
	
	/*************   MEM / WB *************/
	//wire [3:0] MEM_WBType; test
	wire [31:0] MEM_MemData_new;
	wire MEM_RegWrite_new;
	
	wire WB_MemRead;
	wire WB_RegWrite;
	//wire [31:0] WB_MemData;
	//wire [31:0] WB_WBData; 
	//wire [3:0] WB_WBType;
	wire [4:0] WB_Rd;

	//wire MEM_WB_Stall, MEM_WB_Flush;
	
	MEM_WB mod_mem_wb(clk, MEM_WB_Stall, MEM_WB_Flush, MEM_MemData_new, WB_MemData, MEM_WBType,
							WB_WBType, MEM_WBData, WB_WBData, MEM_MemRead, WB_MemRead, MEM_RegWrite_new,
							WB_RegWrite, MEM_Rd, WB_Rd);
	
		
	/*
   wire [1:0] PCSrc, ExtendI, C_A, C_B;
	wire IF_ID_RtRead, RegWrite, BranchValid, RegWriteValid ,WBFlush, OperandA_mux, OperandB_mux;
	wire [31:0] PC_in, PC, PCExtended, ALU_A0, ALU_B0, Writedata, Readdata1, Readdata2, ALU_A, ALU_B, Shift_out, ALU_out;
	wire [4:0] ReadReg1, ReadReg2, WriteReg, ShiftAmount;
	wire [3:0] WBType;
	*/
	
	wire [15:0] ID_Imm = {ID_Rd, ID_Shamt, ID_Func};	

	/* MUX before PC */
	wire [31:0] PC_in_mux[2:0];
	assign PC_in_mux[0] = ID_PCand4;
	assign PC_in_mux[1] = {EX_PCand4[31:28], EX_Rs, EX_Rt, EX_Immediate32[15:0], 2'b0};
	assign PC_in_mux[2] = MEM_Branch_addr;
	assign PC_in = PC_in_mux[PCSrc];
	
	/* PC register */
	PCRegister modpc(clk, PC_in, PC);
	
	/* Instruction Memery */
	InstructionMemery modic(PC, IF_IR);
	
	/* Generate PC+4 */
	assign IF_PCand4 = PC; // modified
	
	/* Controller */
	Controller mod_ctrl(ID_Op, ID_Func ,ID_Rt ,ID_Rs[0], ID_Shamt[0] ,IF_ID_RtRead, ID_Overflow, ID_Condition, ID_Branch,
							ID_MemOp, ID_MemWrite, ID_RegWrite, ID_MemRead, ID_Jump, ID_ExResultSrc,
							ID_ALUSrcA, ID_ALUSrcB, ID_ALUOp, ID_RegDst, ID_ShiftAmountSel,
							ID_ShiftOp, ExtendI);
	
	// use these lines to get forwarding data
	wire [31:0] fwd_data;
	wire [31:0] newMemData;
	assign newMemData = {WB_WBType[3] ? WB_MemData[31:24] : fwd_data[31:24],
								WB_WBType[2] ? WB_MemData[23:16] : fwd_data[23:16],
								WB_WBType[1] ? WB_MemData[15:8] : fwd_data[15:8],
								WB_WBType[0] ? WB_MemData[7:0] : fwd_data[7:0]};
	

	/* Register File */
	RegisterFile mod_reg(ReadReg1, ReadReg2, WriteReg, Writedata, RegWrite, WB_WBType, clk,
								Readdata1, Readdata2, WB_Rd, fwd_data);
	
	assign ReadReg1 = ID_Rs;
	assign ReadReg2 = ID_Rt;
	assign WriteReg = WB_Rd;
	//assign Writedata = WB_MemRead ? WB_MemData : WB_WBData;
	assign Writedata = WB_MemRead ? newMemData : WB_WBData;
	assign RegWrite = WB_RegWrite;
	
	/* Hazard Detection */
	HazardDetection mod_hd(ID_Rt, ID_Rs, IF_ID_RtRead, EX_Jump, EX_MemRead, EX_Rt, BranchValid,
								  PCSrc, IF_ID_Stall, IF_ID_Flush, ID_EX_Stall, ID_EX_Flush,
								  MEM_WB_Stall, MEM_WB_Flush, EX_MEM_Stall, EX_MEM_Flush);
	
	assign ID_OperandA = OperandA_mux ? Writedata : Readdata1;
	assign ID_OperandB = OperandB_mux ? Writedata : Readdata2;
	
	/* Extending Imm */
	ExtendImm mod_ei(ID_Imm, ExtendI, ID_Immediate32);
	
	/* Forwarding Unit */
	Forwarding mod_fw(ID_Rs, ID_Rt, EX_Rs, EX_Rt, MEM_Rd, MEM_RegWrite, WB_RegWrite, WB_Rd, C_A, C_B,
						OperandA_mux, OperandB_mux, EX_MemRead);
	
	// TEST ONLY
	assign fwd_RsIF_ID =        ID_Rs;
	assign fwd_RtIF_ID =        ID_Rt;
	assign fwd_RsID_EX =        EX_Rs;
	assign fwd_RtID_EX =        EX_Rt;
	assign fwd_RdEX_MEM =       MEM_Rd;
	assign fwd_RegWriteEX_MEM = MEM_RegWrite;
	assign fwd_RegWriteMEM_WB = WB_RegWrite;
	assign fwd_RdMEM_WB =       WB_Rd;
	assign fwd_MemReadID_EX =   EX_MemRead;
	
	assign fwd_RdID_EX = EX_Rd;
	
	/* the MUX before ALU_A0 */
	wire [31:0] ALU_A0_mux[2:0];
	assign ALU_A0_mux[0] = EX_OperandA;
	assign ALU_A0_mux[1] = MEM_WBData;
	assign ALU_A0_mux[2] = Writedata;
	assign ALU_A0 = ALU_A0_mux[C_A];
	
	/* the MUX before ALU_B0 */
	wire [31:0] ALU_B0_mux[2:0];
	assign ALU_B0_mux[0] = EX_OperandB;
	assign ALU_B0_mux[1] = MEM_WBData;
	assign ALU_B0_mux[2] = Writedata;
	assign ALU_B0 = ALU_B0_mux[C_B];
	
	/* the MUX before ALU_A */
	assign ALU_A = EX_ALUSrcA ? 32'b0: ALU_A0;
	
	/* the MUX before ALU_B */
	wire [31:0] ALU_B_mux[2:0];
	assign ALU_B_mux[0] = ALU_B0;
	assign ALU_B_mux[1] = EX_Immediate32;
	assign ALU_B_mux[2] = 32'b0;
	assign ALU_B = ALU_B_mux[EX_ALUSrcB];
	
	/* the MUX of RegDst */
	wire [4:0] EX_Rd_mux[2:0];
	assign EX_Rd_mux[0] = EX_Rd;
	assign EX_Rd_mux[1] = EX_Rt;
	assign EX_Rd_mux[2] = 5'b11111;
	assign EX_Rd_new = EX_Rd_mux[EX_RegDst];
	
	/* the MUX of ShiftAmount */
	//assign ShiftAmount = EX_ShiftAmountSel ? EX_Rs : EX_Immediate32[10:6];  // modified 
	wire [4:0] ShiftAmount_mux[2:0];
	assign ShiftAmount_mux[0] = EX_Immediate32[10:6];
	assign ShiftAmount_mux[1] = EX_Rs;
	assign ShiftAmount_mux[2] = EX_OperandA[4:0];
	assign ShiftAmount = ShiftAmount_mux[EX_ShiftAmountSel];
	
	
	/* Shifter Unit */
	BarrelShifter mod_bs(ALU_B0, ShiftAmount, EX_ShiftOp, Shift_out);
	
	/* the MUX of EX_WBData */
	wire [31:0] EX_WBData_mux[2:0];
	assign EX_WBData_mux[0] = EX_PCand4; // saving current PC+4
	assign EX_WBData_mux[1] = ALU_out;
	assign EX_WBData_mux[2] = Shift_out;
	assign EX_WBData = EX_WBData_mux[EX_ExResultSrc];
	
	/* ALU */
	ALU mod_alu(ALU_A, ALU_B, EX_ALUOp, ALU_out, EX_Z, EX_V, EX_Less);
	
	/* the Adder before Branch_addr */
	assign EX_Branch_addr = {EX_Immediate32[31:2] + EX_PCand4[31:2], 2'b0};
	
	/* Condition Check Unit */
	ConditionCheck mod_cc(MEM_Condition, MEM_Branch, MEM_Overflow, MEM_RegWrite, MEM_Less,
								 MEM_Z, MEM_V, BranchValid, MEM_RegWrite_new);
	
	/* Generating the WBReg Controlling signal */
	WriteBackController mod_wbc(MEM_WBData[1:0], MEM_MemOp, MEM_WBType);
	
	/* data cache */
	DataMem mod_dm(clk, MEM_WBData, MEM_MemData, MEM_MemOp, MEM_MemWrite, MEM_MemData_new);
	
	assign MEM_Addr = MEM_WBData;
	assign MEM_data_in = MEM_MemData;
	assign MEM_Op = MEM_MemOp;
	assign Mem_WriteEn = MEM_MemWrite;
	assign MEM_DataOut = MEM_MemData_new;

endmodule 