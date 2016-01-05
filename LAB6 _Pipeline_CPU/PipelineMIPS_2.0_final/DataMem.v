// 数据存储器
module DataMem
(		input clk,      // the clock 
		input [31:0] Mem_addr,   // memory write address 
		input [31:0] Mem_data_in,   // memory write data
		input [3:0] MemOp,   // memory option
		input MemWrite,      // the MemWrite signal 
		output reg [31:0] Mem_data_out      // read from memory 
);

reg [7:0] mem[127:0];
reg [3:0] Mem_byte_w_en;

integer i;
initial begin
	for (i=0;i<128;i=i+1) mem[i]=8'b0;
end

always @ (posedge clk)
begin
	if (MemWrite)
	begin
		case (MemOp)
			4'b0000:   // sw instruction
				begin 
					mem[Mem_addr+3]=Mem_data_in[7:0]; //write in lower 8 bits
					mem[Mem_addr+2]=Mem_data_in[15:8]; //write in mid lower 8 bits
					mem[Mem_addr+1]=Mem_data_in[23:16]; //write in mid higher 8 bits
					mem[Mem_addr]=Mem_data_in[31:24]; //write in higher 8 bits
				end 
			4'b0001:   // swr instruction 
				begin 
					case(Mem_addr[1:0])
						2'b00: Mem_byte_w_en = 4'b1000;
						2'b01: Mem_byte_w_en = 4'b1100;
						2'b10: Mem_byte_w_en = 4'b1110;
						2'b11: Mem_byte_w_en = 4'b1111;
					endcase
					if (Mem_byte_w_en[3]==1) mem[Mem_addr]=Mem_data_in[7:0]; //write in lower 8 bits
					if (Mem_byte_w_en[2]==1) mem[Mem_addr-1]=Mem_data_in[15:8]; //write in mid lower 8 bits
					if (Mem_byte_w_en[1]==1) mem[Mem_addr-2]=Mem_data_in[23:16]; //write in mid higher 8 bits
					if (Mem_byte_w_en[0]==1) mem[Mem_addr-3]=Mem_data_in[31:24]; //write in higher 8 bits
				end
			4'b0100:  // swl instruction 
				begin
					case(Mem_addr[1:0])
						2'b00: Mem_byte_w_en = 4'b1111;
						2'b01: Mem_byte_w_en = 4'b0111;
						2'b10: Mem_byte_w_en = 4'b0011;
						2'b11: Mem_byte_w_en = 4'b0001;
					endcase
					if (Mem_byte_w_en[3]==1) mem[Mem_addr+3]=Mem_data_in[7:0]; //write in lower 8 bits
					if (Mem_byte_w_en[2]==1) mem[Mem_addr+2]=Mem_data_in[15:8]; //write in mid lower 8 bits
					if (Mem_byte_w_en[1]==1) mem[Mem_addr+1]=Mem_data_in[23:16]; //write in mid higher 8 bits
					if (Mem_byte_w_en[0]==1) mem[Mem_addr]=Mem_data_in[31:24]; //write in higher 8 bits
				end 
			4'b1010:   // sb instruction 
				begin
					mem[Mem_addr]=Mem_data_in[7:0];
				end 
			4'b1011:   // sh instruction 
				begin
					mem[Mem_addr+1]=Mem_data_in[7:0]; 
					mem[Mem_addr]=Mem_data_in[15:8];	
				end 
		endcase 
	end 
end 

/*assign Mem_data_out=(MemOp==3'b101)?{mem[Mem_addr-3],mem[Mem_addr-2],mem[Mem_addr-1],mem[Mem_addr]}:
												{mem[Mem_addr],mem[Mem_addr+1],mem[Mem_addr+2],mem[Mem_addr+3]};*/
always @ (*)
begin
		case (MemOp)
			4'b0010,4'b0011:   // lw, lwl
					Mem_data_out={mem[Mem_addr],mem[Mem_addr+1],mem[Mem_addr+2],mem[Mem_addr+3]};
			4'b0101:           // lwr
					Mem_data_out={mem[Mem_addr-3],mem[Mem_addr-2],mem[Mem_addr-1],mem[Mem_addr]};
			4'b0110:           // lb
					Mem_data_out={(mem[Mem_addr][7]==1'b1)?24'hffffff:24'h000000,mem[Mem_addr]};
			4'b0111:           // lbu
					Mem_data_out={24'h000000,mem[Mem_addr]};
			4'b1000:           // lh 
					Mem_data_out={(mem[Mem_addr][7]==1'b1)?16'hffff:16'h0000,mem[Mem_addr],mem[Mem_addr+1]};
			4'b1001:           // lhu
					Mem_data_out={16'h0000,mem[Mem_addr],mem[Mem_addr+1]};
			default:
					Mem_data_out={mem[Mem_addr],mem[Mem_addr+1],mem[Mem_addr+2],mem[Mem_addr+3]};
		endcase 
end 
endmodule 