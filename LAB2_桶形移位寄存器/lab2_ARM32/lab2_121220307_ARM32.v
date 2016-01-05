module lab2_121220307_ARM32
(
	input [31:0] Shift_in,  // the data that we input
	input [4:0] Shift_amount, // the amount that we want to shift the data
	input [1:0] Shift_op, // the style that we want to use to shift
	input Carry_flag,  // the carry flag
	output reg [31:0] Shift_out,  // the data that after we shift the input data
	output reg Shift_carry_out   // the carry flag that we want to output
);
integer i;
always @ (*)
begin
	case (Shift_op)
		2'b00:  // logic left shift
			begin
				Shift_out=Shift_in<<Shift_amount;
				if (Shift_amount==5'b00000) Shift_carry_out=Carry_flag;
				else Shift_carry_out=Shift_in[32-Shift_amount];
			end
		2'b01:  // logic right shift
			begin
				if (Shift_amount==5'b00000) // ritht 32
				begin
					Shift_out=32'h00000000;
					Shift_carry_out=Shift_in[31];
				end
				else
				begin
					Shift_out=Shift_in>>Shift_amount;
					Shift_carry_out=Shift_in[Shift_amount-1];
				end
			end
		2'b10:  // algebra right shift  
			begin
				if (Shift_amount==5'b00000)
				begin
					if (Shift_in[31]==0)
						Shift_out=32'h00000000;
					else
						Shift_out=32'hffffffff;
					Shift_carry_out=Shift_in[31];
				end
				else
				begin
					for (i=31; i>=0; i=i-1)
					begin
						if (i>31-Shift_amount)
							Shift_out[i]=Shift_in[31];
						else
							Shift_out[i]=Shift_in[i+Shift_amount];
					end
					Shift_carry_out=Shift_in[Shift_amount-1];
				end
			end
		2'b11:   //circle right  shift 
			begin
				if (Shift_amount==5'b00000)  //ritht 32 shift 
				begin
					Shift_out[30:0]=Shift_in[31:1];
					Shift_out[31]=Carry_flag;
					Shift_carry_out=Shift_in[0];
				end
				else 
				begin
					for (i=31; i>=0; i=i-1)
					begin
						if (i>31-Shift_amount)
							Shift_out[i]=Shift_in[i-32+Shift_amount];
						else
							Shift_out[i]=Shift_in[i+Shift_amount];
					end
					Shift_carry_out=Shift_in[Shift_amount-1];
				end
			end
	endcase
end
endmodule
