// 寄存器组模块
module RegisterFile
#(parameter data_width=32,parameter addr_width=5)
(
    input [addr_width-1:0] rs_addr,rt_addr,rd_addr,  //the addresses of write and read
    input [data_width-1:0] rd_in,  //32 bits data that need to be input
	 input RegWrite,
    input [3:0] Rd_byte_w_en,  //write enable
    input clk,  //the clock
    output [data_width-1:0] rs_out,rt_out,  //32 bits data to be output
	 input [addr_width-1:0] fwd_data_addr,
	 output [data_width-1:0] fwd_data_out
);

reg [data_width-1:0] register[2**addr_width-1:0];  // the register group

integer i;
initial
begin
		for (i=0; i<32; i=i+1) register[i] = 0;
		
		// following registers are set for test.
		register[16] = 32'h75000000;
		register[17] = 32'habcd4321; 
end
always @ (negedge clk) // modified
begin
	//register[0]=32'b0;
    if (rd_addr!=0 && RegWrite)
    begin
        if (Rd_byte_w_en[0]==1) register[rd_addr][7:0]<=rd_in[7:0]; //write in lower 8 bits
        if (Rd_byte_w_en[1]==1) register[rd_addr][15:8]<=rd_in[15:8]; //write in mid lower 8 bits
        if (Rd_byte_w_en[2]==1) register[rd_addr][23:16]<=rd_in[23:16]; //write in mid higher 8 bits
        if (Rd_byte_w_en[3]==1) register[rd_addr][31:24]<=rd_in[31:24]; //write in higher 8 bits
    end
end

assign   rs_out=register[rs_addr];  //read from rs_addr
assign   rt_out=register[rt_addr];  //read from rt_addr 
assign   fwd_data_out=register[fwd_data_addr];  //read from rt_addr 

endmodule
