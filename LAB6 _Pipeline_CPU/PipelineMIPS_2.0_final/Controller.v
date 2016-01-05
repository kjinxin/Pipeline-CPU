// CPU 控制器
module Controller
(
		input [5:0] Op,
		input [5:0] Func,
		input [4:0] Rt,
		input R21, R6,  // 用于区分 rotr\srl 和 rotrv\srlv
		output reg RtRead,
		output reg Overflow,
		output reg [2:0] Condition,
		output reg Branch,
		output reg [3:0] MemOp,
		output reg MemWrite,
		output reg RegWrite,
		output reg MemRead,
		output reg Jump,
		output reg [1:0] ExResultSrc,
		output reg ALUSrcA,
		output reg [1:0] ALUSrcB,
		output reg [3:0] ALUOp,
		output reg [1:0] regdst,
		output reg [1:0] ShiftAmountSel,
		output reg [1:0] ShiftOp,
		output reg [1:0] ExtendI
);

always @ (*)
begin
	case (Op)
		6'b000000:
			begin
				case (Func)
					6'b100000: //add
						begin
							Overflow <= 1'b1;
							Condition <= 3'b000;
							Branch <= 1'b0;
							MemOp <= 4'b0000;
							MemWrite <= 1'b0;
							RegWrite <= 1'b1;
							MemRead <= 1'b0;
							Jump <= 1'b0;
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00; // modified
							ALUOp <= 4'b1110;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1; // modified
						end
					6'b100001: //addu (new)
						begin
							Overflow <= 1'b0;			
							Condition <= 3'b000;				
							Branch <= 1'b0;			
							MemOp <= 4'b0000;			
							MemWrite <= 1'b0;			
							RegWrite <= 1'b1;			
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00; // modified
							ALUOp <= 4'b1110;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1; // modified
						end
					6'b100010: // sub
						begin
							Overflow <= 1'b1;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;	// modified			
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;			
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b1111;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;	
						end
					6'b100011: // subu
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0001;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end 
					6'b100111: // nor
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b1000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end 
					6'b100110: // xor (new)
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b1001;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end 
					6'b100100: // and (new)
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0100;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end 
					6'b100101: // or (new)
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0110;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end 
					6'b101011: // sltu
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0111;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end 
					6'b101010: // slt (new)
						begin
							Overflow <= 1'b1;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0101;	// modified			
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end 
					6'b000011:   // SRA
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b10;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b10;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end
					6'b000111: // SRAV
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b10;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b10; // modified				
							ShiftOp <= 2'b10; //modified				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end 
					6'b000000:   // SLL (new)
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b10;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end
					6'b000100:   // SLLV (new)
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b10;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b10;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end
					6'b000010: 
						if (R21) // rotr
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b10;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;	
							ShiftOp <= 2'b11; //modified
							ExtendI <= 2'b01;				
							RtRead <= 1'b1;		
						end
						else // SRL (new)
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b10;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b01;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end
					6'b000110: 
						if (R6) // rotrv (new)
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b10;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b10;	
							ShiftOp <= 2'b11; //modified
							ExtendI <= 2'b01;				
							RtRead <= 1'b1;		
						end
						else // SRLV (new)
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b10;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b10;				
							ShiftOp <= 2'b01;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b1;		
						end
					default:
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b0;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b00;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b0;
						end 
				endcase 
			end
		6'b011100: // clo or clz
			begin
				case (Func)
					6'b100001: // clo 
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0011;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b0;		
						end
					6'b100000://clz 
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b01;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0010;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b0;		
						end
					default:
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b0;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b00;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b0;
						end 
				endcase 
			end 
		6'b000001:   // b 指令
				begin
					case (Rt)
					5'b10001: // BGEZAL & BAL
						begin
							Overflow <= 1'b1;				
							Condition <= 3'b100;				
							Branch <= 1'b1;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;			// modified	
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b00;	// modified
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b10;				
							ALUOp <= 4'b0001;	// modified			
							regdst <= 2'b10;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b10;				
							RtRead <= 1'b0;		
						end 
					5'b00001:  // BGEZ
						begin
							Overflow <= 1'b1;				
							Condition <= 3'b100;				
							Branch <= 1'b1;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b0;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b00;			
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b10;				
							ALUOp <= 4'b0001;				
							regdst <= 2'b10;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b10;				
							RtRead <= 1'b0;		
						end
					5'b10000:   //BLTZAL
						begin
							Overflow <= 1'b1;				
							Condition <= 3'b101;				
							Branch <= 1'b1;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b1;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b00;			
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b10;				
							ALUOp <= 4'b0001;				
							regdst <= 2'b10;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b10;				
							RtRead <= 1'b0;		
						end
					default:
						begin
							Overflow <= 1'b0;				
							Condition <= 3'b000;				
							Branch <= 1'b0;				
							MemOp <= 4'b0000;				
							MemWrite <= 1'b0;				
							RegWrite <= 1'b0;				
							MemRead <= 1'b0;				
							Jump <= 1'b0;				
							ExResultSrc <= 2'b00;				
							ALUSrcA <= 1'b0;				
							ALUSrcB <= 2'b00;				
							ALUOp <= 4'b0000;				
							regdst <= 2'b00;				
							ShiftAmountSel <= 2'b00;				
							ShiftOp <= 2'b00;				
							ExtendI <= 2'b00;				
							RtRead <= 1'b0;
						end 
					endcase 
				end 
		6'b001000:  // addi
			begin
				Overflow <= 1'b1;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;				
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b1110;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end 
		6'b001001:// addiu
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;			
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0; // modified				
				RegWrite <= 1'b1;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;				
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b01;				
				RtRead <= 1'b0;		
			end
		6'b001100:  // andi (new)
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;				
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0100;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b01;	//modified			
				RtRead <= 1'b0;		
			end 
		6'b011111:  // seb 
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b00;				
				ALUOp <= 4'b1010;				
				regdst <= 2'b00;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b1;		
			end 
		6'b001110:  // xori 
			begin
				Overflow <= 1'b0;		// modified		
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b1001;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b01;				
				RtRead <= 1'b0;		
			end 
		6'b001101:  // ori (new)
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0110;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b01;	//modified			
				RtRead <= 1'b0;		
			end 
		6'b001010:  // slti 
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0101;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end 
		6'b000010: //  j
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b1;				
				ExResultSrc <= 2'b00;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b00;				
				ALUOp <= 4'b0000; //modified
				regdst <= 2'b00;
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end 
		6'b001111:  // LUI
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b1;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b11;				
				RtRead <= 1'b0;		
			end
		6'b000100:  // b (new)
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b111;				
				Branch <= 1'b1;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;				
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b00;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b10;				
				RtRead <= 1'b0;		
			end 
		6'b100010: //   lwl  
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0011;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b1;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end 
		6'b100110: //   lwr
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0101;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b1;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end 
		6'b100011:   // lw 
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0010;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b1;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end 
		6'b101011: //   sw 
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b1;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end 
		6'b101110:  //swr  modified
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0001;				
				MemWrite <= 1'b1;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end 
		6'b101010:  //swl
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0100;				
				MemWrite <= 1'b1;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end 
		6'b000110:    //  BLEZ
			begin
				Overflow <= 1'b1;				
				Condition <= 3'b110;				
				Branch <= 1'b1;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b00;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b10;				
				ALUOp <= 4'b0001;				
				regdst <= 2'b00;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b10;				
				RtRead <= 1'b0;		
			end
		6'b000101:  // BNB  
			begin
				Overflow <= 1'b1;				
				Condition <= 3'b010;				
				Branch <= 1'b1;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b00;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b00;				
				ALUOp <= 4'b0001;				
				regdst <= 2'b00;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b10;				
				RtRead <= 1'b1;		
			end
		6'b000011:  // JAL
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b111;				
				Branch <= 1'b1;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b00;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b10;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b10;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b10;				
				RtRead <= 1'b0;		
			end
		6'b100000:  // LB
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0110;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b1;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b10;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end
		6'b100100:  // LBU
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0111;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b1;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b10;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end
		6'b100001:  // LH
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b1000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b1;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b10;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end
		6'b100101:  // LHU
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b1001;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b1;				
				MemRead <= 1'b1;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b10;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;		
			end
		6'b101000:  // SB
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b1010;				
				MemWrite <= 1'b1;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b1;		
			end
		6'b101001:  // SH
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b1011;				
				MemWrite <= 1'b1;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b01;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b01;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b01;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b1;		
			end
		default:
			begin
				Overflow <= 1'b0;				
				Condition <= 3'b000;				
				Branch <= 1'b0;				
				MemOp <= 4'b0000;				
				MemWrite <= 1'b0;				
				RegWrite <= 1'b0;				
				MemRead <= 1'b0;				
				Jump <= 1'b0;				
				ExResultSrc <= 2'b00;			
				ALUSrcA <= 1'b0;				
				ALUSrcB <= 2'b00;				
				ALUOp <= 4'b0000;				
				regdst <= 2'b00;				
				ShiftAmountSel <= 2'b00;				
				ShiftOp <= 2'b00;				
				ExtendI <= 2'b00;				
				RtRead <= 1'b0;
			end 
	endcase 
end 
endmodule 