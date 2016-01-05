module lab1_121220307_MIPS32
#(parameter data_width=32,parameter addr_width=5)
(
    input [addr_width-1:0] rs_addr,rt_addr,rd_addr,  //the addresses of write and read
    input [data_width-1:0] rd_in,  //32 bits data that need to be input
    input [3:0] Rd_byte_w_en,  //write enable
    input clk,  //the clock
    output [data_width-1:0] rs_out,rt_out  //32 bits data to be output
);

reg [data_width-1:0] register[2**addr_width-1:0];  // the register group


always @ (posedge clk)
begin
	 register[0]=32'b0;
    if (rd_addr!=0)
    begin
        if (Rd_byte_w_en[0]==0) register[rd_addr][7:0]<=rd_in[7:0]; //write in lower 8 bits
        if (Rd_byte_w_en[1]==0) register[rd_addr][15:8]<=rd_in[15:8]; //write in mid lower 8 bits
        if (Rd_byte_w_en[2]==0) register[rd_addr][23:16]<=rd_in[23:16]; //write in mid higher 8 bits
        if (Rd_byte_w_en[3]==0) register[rd_addr][31:24]<=rd_in[31:24]; //write in higher 8 bits
    end
end

assign   rs_out=register[rs_addr];
assign   rt_out=register[rt_addr];
endmodule
