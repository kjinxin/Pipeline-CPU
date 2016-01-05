module lab3_121220307_MIPS32
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
	Zero=(register==32'h00000000)?1:0;  // to judge if it is zero 
	Negative=(register[31])?1:0;   // to calculate whether the output is negative
	Overflow=((~tempA[31])&(~tempB[31])&register[31])|(tempA[31]&tempB[31]&(~register[31]));  // calculate the overflow
	Less=(ALU_op[1])?(Overflow^Negative):Carry;  // calculate whether it is less or more
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
				ALU_out=(Less)?32'hffffffff:32'h00000000;
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
				Overflow=(ALU_op[1]&ALU_op[2]&ALU_op[3])?Overflow:0;
			end 
	endcase
end 
endmodule 