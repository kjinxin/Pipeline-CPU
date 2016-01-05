module MEM_WB
(
		input clk,                // the clock
		input stall,              // pause
		input flush,
		input [31:0] memdata,     // the input memdata
		output reg [31:0] MemData,// the output MemData
		input [3:0] wbtype,       // the input wbtype,
		output reg [3:0] WBType,  // the output WBType,
		input [31:0] wbdata,      // the input wbdata,
		output reg [31:0] WBData, // the output WBData,
		input memread,            // the input memread,
		output reg MemRead,       // the output MemRead,
		input regwrite,           // the input regwrite,
		output reg RegWrite,      // the ourput regwrite,
		input [4:0] rd,           // the input rd,
		output reg [4:0] Rd      // the output Rd
);

initial begin
	MemRead<=0;
	RegWrite<=0;
	MemData<=0;
	WBData<=0;
	WBType<=0;
	Rd<=0;
end


always @ (posedge clk)
begin
		if (stall==0)
		begin
			MemData<=memdata;
			WBType<=wbtype;
			WBData<=wbdata;
			MemRead<=memread;
			RegWrite<=regwrite;
			Rd<=rd;
		end
		if (flush==1)
		begin
			MemData<=32'h0;
			WBType<=4'h0;
			WBData<=32'h0;
			MemRead<=1'h0;
			RegWrite<=1'h0;
			Rd<=5'h0;
		end 
end 
endmodule 