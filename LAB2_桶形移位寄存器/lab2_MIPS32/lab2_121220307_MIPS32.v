module lab2_121220307_MIPS32
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