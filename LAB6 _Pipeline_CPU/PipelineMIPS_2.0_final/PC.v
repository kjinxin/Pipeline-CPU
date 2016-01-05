// PC 寄存器
module PCRegister
(	
	input clk,     // the clock
	input [31:0] PC_in,    // the input PC data 
	output reg [31:0] PC_out   // the output PC result
);
initial 
begin
	PC_out=32'h00000000;    // initialize PC to zero
end 
always @ (negedge clk)
begin
	PC_out <= PC_in;
end 
endmodule 