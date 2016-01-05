module lab2_121220307_MIPS8
(
	input [7:0] Shift_in, // the input data that we want to shif_in
	input [2:0] Shift_amount, // the amount that we want to shift the data
	input [1:0] Shift_op,   // choose which style that we want to shift
	output reg [7:0] Shift_out // the data that after we shift
);
integer i;
always @ (*)
begin
	case (Shift_op)
		2'b00:
				begin
					Shift_out=Shift_in<<Shift_amount;  // logic left shift 
				end
		2'b01:
				begin
					Shift_out=Shift_in>>Shift_amount;  // logic right shift 
				end
		2'b10:
				begin
					for (i=7; i>=0; i=i-1)
					begin
						if (i>7-Shift_amount)
							Shift_out[i]=Shift_in[7];
						else
							Shift_out[i]=Shift_in[i+Shift_amount];  // algebra right shift 
					end
				end
		2'b11:
				begin
					for (i=7; i>=0; i=i-1)
					begin
						if (i>7-Shift_amount)
							Shift_out[i]=Shift_in[i-8+Shift_amount];  // circle right shift 
						else
							Shift_out[i]=Shift_in[i+Shift_amount];
					end
				end
	endcase
end
endmodule 