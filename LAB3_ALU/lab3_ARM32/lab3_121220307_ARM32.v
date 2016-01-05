module lab3_121220307_ARM32
(
	input [31:0] A, // the operate data A
	input [31:0] B, // the operate data B
	input [3:0] ALU_op, // the control logic
	input Cin,   // the data of Shift_carry_out
	output reg [31:0] ALU_out, // the final data to output accoring the operation
	output reg Zero,  // the flag zero
	output reg Negative, // the answer is negative
	output reg Carry,  // the flag Less
	output reg Overflow // the flag overflow 
);
always @ (*)
begin
	case (ALU_op)
		4'h0: // operation and 
			begin
				ALU_out=A&B;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Carry=Cin;
				Overflow=1'b0;
			end
		4'h1:  // operation xor
			begin
				ALU_out=A^B;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Carry=1'b0;
				Overflow=1'b0;
			end
		4'h2:   // operation sub 
			begin
				{Carry,ALU_out}=A+(~B)+1;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Overflow=((~A[31])&B[31]&ALU_out[31])|(A[31]&(~B[31])&(~ALU_out[31]));
			end
		4'h3:  // operation opposite sub 
			begin
				{Carry,ALU_out}=(~A)+B+1;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Overflow=(A[31]&(~B[31])&ALU_out[31])|((~A[31])&B[31]&(~ALU_out[31]));
			end
		4'h4:  // operation add
			begin
				{Carry,ALU_out}=A+B;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Overflow=((~A[31])&(~B[31])&ALU_out[31])|(A[31]&B[31]&(~ALU_out[31]));
			end
		4'h5: // operation carry add
			begin
				{Carry,ALU_out}=A+B+Cin;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Overflow=((~A[31])&(~B[31])&ALU_out[31])|(A[31]&B[31]&(~ALU_out[31]));
			end
		4'h6:  // operation seb or seh
			begin
				{Carry,ALU_out}=A+(~B)+1+Cin;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Overflow=((~A[31])&(B[31])&ALU_out[31])|(A[31]&(~B[31])&(~ALU_out[31]));
			end
		4'h7:  // operation carry opposite sub
			begin
				{Carry,ALU_out}=B+(~A)+1+Cin;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Overflow=((A[31])&(~B[31])&ALU_out[31])|((~A[31])&B[31]&(~ALU_out[31]));
			end
		4'h8:  //TST
			begin
				ALU_out=A&B;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Carry=Cin;
				Overflow=1'b0;
			end
		4'h9:  // TEQ
			begin
				ALU_out=A^B;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Carry=Cin;
				Overflow=1'b0;
			end
		4'ha:  // CMP
			begin
				{Carry,ALU_out}=A+(~B)+1;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Overflow=((~A[31])&(B[31])&ALU_out[31])|(A[31]&(~B[31])&(~ALU_out[31]));
			end
		4'hb:  // CMN
			begin
				{Carry,ALU_out}=A+B;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Overflow=((~A[31])&(~B[31])&ALU_out[31])|((~A[31])&(~B[31])&(~ALU_out[31]));
			end
		4'hc:  // ORR
			begin
				ALU_out=A|B;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Carry=Cin;
				Overflow=1'b0;
			end
		4'hd:  // MOV
			begin
				ALU_out=B;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Carry=Cin;
				Overflow=1'b0;
			end
		4'he:  // BIC
			begin
				ALU_out=A&(~B);
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Carry=Cin;
				Overflow=1'b0;
			end
		4'hf:  // MVN
			begin
				ALU_out=~B;
				Negative=ALU_out[31];
				Zero=(ALU_out==32'h00000000)?1:0;
				Carry=Cin;
				Overflow=1'b0;
			end
	endcase
end 
endmodule 