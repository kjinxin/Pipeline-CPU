module ID_EX
(
		input clk,                // the clock
		input stall,              // pause
		input flush,              // 
		input [31:0] PC_in,       // the input PC
		output reg [31:0] PC_out,     // the output PC
		input overflow,			  // the input overflow
		output reg Overflow, 			  // the output overflow
		input [2:0] condition,			  // the input condition
		output reg [2:0] Condition,	  // the output condition
		input branch,				  // the input Branch
		output reg Branch,        // the output branch 
		input [3:0] memop,        // the input memop
		output reg [3:0] MemOp,   // the output memop
		input memwrite,           // the input memwrite
		output reg MemWrite,          // the output memWrite
		input regwrite,           // the input regwrite
		output reg RegWrite,          // the output RegWrite
		input memread,            // the input memread
		output reg MemRead,           // the output MemRead 
		input jump,         // the input jump
		output reg Jump,     // the output jump 
		input [1:0] exResultSrc,     // the input exResultSrc,
		output reg [1:0] ExResultSrc,    // the output exResultsrc,
		input alusrca,               // the input alusrca
		output reg ALUSrcA,          // the output ALUSrcA,
		input [1:0] alusrcb,               // the input alusrcb,
		output reg [1:0] ALUSrcB,          // the output ALUSrcB,
		input [3:0] aluop,			  // the input aluop
		output reg [3:0] ALUOp,      // the output ALUOp
		input [1:0] regdst,        // the input regdst,
		output reg [1:0] RegDst,   // the output RegDst
		input [1:0] shiftamountsel,        // the input ShiftAmountSel
		output reg [1:0] ShiftAmountSel,   // the output ShiftAmountSel
		input [1:0] shiftop,         // the input ShiftOp
		output reg [1:0] ShiftOp,    // the output ShiftOp
		input [31:0] operandA,       // the input operandA
		output reg [31:0] OperandA,  // the output operandA
		input [31:0] operandB,       // the input operandB
		output reg [31:0] OperandB,  // the output operandB
		input [4:0] rs,              // the input rs
		output reg [4:0] Rs,         // the output rs
		input [4:0] rt,              // the input rt
		output reg [4:0] Rt,         // the output rt
		input [4:0] rd,              // the input rd
		output reg [4:0] Rd,         // the output rd
		input [31:0] immediate32,    // the input immediate32
		output reg [31:0] Immediate32 // the output immediate32
);

initial begin
	ALUSrcA<=0;
	Branch<=0;
	Jump<=0;
	MemRead<=0;
	MemWrite<=0;
	Overflow<=0;
	RegWrite<=0;
	ShiftAmountSel<=0;
	ALUSrcB<=0;
	ExResultSrc<=0;
	MemOp<=0;
	RegDst<=0;
	ShiftOp<=0;
	Condition<=0;
	Immediate32<=0;
	OperandA<=0;
	OperandB<=0;
	PC_out<=0;
	ALUOp<=0;
	Rd<=0;
	Rs<=0;
	Rt<=0;
end


always @ (posedge clk)
begin
		if (stall==0)
		begin
				PC_out<=PC_in;
				Overflow<=overflow;			  			  			 
				Condition<=condition;	 
				Branch<=branch;  
				MemOp<=memop;
				MemWrite<=memwrite;          
				RegWrite<=regwrite;       
				MemRead<=memread;           
				Jump<=jump;    	
				ExResultSrc<=exResultSrc;
				ALUSrcA<=alusrca;       
				ALUSrcB<=alusrcb;  
				ALUOp<=aluop;      
				RegDst<=regdst;  
				ShiftAmountSel<=shiftamountsel;
				ShiftOp<=shiftop;    
				OperandA<=operandA;  
				OperandB<=operandB;  
				Rs<=rs;        
				Rt<=rt;         
				Rd<=rd;         
				Immediate32<=immediate32; 
		end 
		if (flush==1)
		begin
				PC_out<=32'h0;
				Overflow<=0;			  			  			 
				Condition<=3'h0;	 
				Branch<=1'h0; 
				MemOp<=2'h0;
				MemWrite<=1'h0;          
				RegWrite<=1'h0;       
				MemRead<=1'h0; 
				Jump<=1'b0;      	
				ExResultSrc<=2'h0;
				ALUSrcA<=1'h0;       
				ALUSrcB<=1'h0;  
				ALUOp<=4'h0;      
				RegDst<=2'h0;  
				ShiftAmountSel<=1'h0;
				ShiftOp<=2'h0;    
				OperandA<=32'h0;  
				OperandB<=32'h0;  
				Rs<=5'h0;        
				Rt<=5'h0;         
				Rd<=5'h0;         
				Immediate32<=32'h0;
		end 
end 
endmodule 