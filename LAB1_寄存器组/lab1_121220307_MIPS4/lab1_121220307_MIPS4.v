module lab1_121220307_MIPS4
#(parameter data_width=4,parameter addr_width=4)
(
    input [addr_width-1:0] rs_addr,rt_addr,rd_addr,  //the addresses of write and read
    input [data_width-1:0] rd_in,  //4 bits data that need to be input
    input [3:0] Rd_byte_w_en,  //write enable
    input clk,  //the clock
    output [data_width-1:0] rs_out,rt_out  //4 bits data to be output
);

reg [data_width-1:0] register[2**addr_width-1:0];  // the register group

always @ (posedge clk)
begin
    register[0]=4'b0;
    if (rd_addr!=0)
    begin
        if (Rd_byte_w_en[0]==0) register[rd_addr][0]<=rd_in[0]; //write in lower 1 bit
        if (Rd_byte_w_en[1]==0) register[rd_addr][1]<=rd_in[1]; //write in mid lower 1 bit
        if (Rd_byte_w_en[2]==0) register[rd_addr][2]<=rd_in[2]; //write in mid higher 1 bit
        if (Rd_byte_w_en[3]==0) register[rd_addr][3]<=rd_in[3]; //write in higher 1 bit
    end
end

assign	rs_out=register[rs_addr];  //read and output the data of the register
assign	rt_out=register[rt_addr];
endmodule
