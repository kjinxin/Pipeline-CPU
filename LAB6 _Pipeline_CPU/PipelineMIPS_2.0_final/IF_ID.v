module IF_ID
(
		input clk,                // the clock
		input stall,              // pause
		input flush,              // 
		input [31:0] IR,          // the  current instruction
		input [31:0] PC_in,       // the input PC
		output reg [31:0] PC_out,     // the output PC
		output reg [5:0] Op,      // the type of the instruction 
		output reg [4:0] Rs,      // the address of Rs register
		output reg [4:0] Rt,      // the address of Rt register
		output reg [4:0] Rd,      // the address of Rd register 
		output reg [4:0] Shamt,   // the shift amount
		output reg [5:0] Func   // the specfic function 
);

initial
begin
	PC_out <= 0;
	Op <= 0;
	Rs <= 0;
	Rt <= 0;
	Rd <= 0;
	Shamt <= 0;
	Func <=0;
end

always @ (posedge clk)
begin
		if (stall==0)
		begin
			Op<=IR[31:26];
			Rs<=IR[25:21];
			Rt<=IR[20:16];
			Rd<=IR[15:11];
			Shamt<=IR[10:6];
			Func<=IR[5:0];
			PC_out<=PC_in + 4;
		end 
		if (flush==1) 
		begin
			Op<=6'h0; 
			Rs<=5'h0;
			Rt<=5'h0;
			Rd<=5'h0;
			Shamt<=5'h0;
			Func<=6'h0;
			//PC_out<=32'h0;
			PC_out<=PC_in;
		end 
end
endmodule 