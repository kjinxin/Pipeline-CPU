module lab1_121220307_ARM32
#(parameter data_width=32,parameter addr_width=4)
(
    input [addr_width-1:0] Rn_r_addr,Rm_r_addr,Rs_r_addr,Rd_r_addr,  // the address of the register we read
    input [addr_width-1:0] Rn_w_addr,Rd_w_addr,  //the address of register we write
    input [data_width-1:0] Rd_in,Rn_in,  // the data we want to write
    input [data_width-1:0] PC_in, // the counter
    input [data_width-1:0] CPSR_in,SPSR_in, // the data we want to write in CPSR and SPSR(Current/Saved Program Status Register)
    input [3:0] CPSR_byte_w_en,SPSR_byte_w_en,Rd_byte_w_en,Rn_byte_w_en,
    input clk,rst,
    output reg [data_width-1:0] Rn_out,Rm_out,Rs_out,Rd_out, // the data we want to read
    output reg [data_width-1:0] PC_out,CPSR_out,SPSR_out,
    output reg [4:0] Mode_out
);

//the group of the 37 registers
reg [data_width-1:0] register_ge[15:0];  //common general register
reg [data_width-1:0] register_fiq[14:8];  //the general register of the state of fip
reg [data_width-1:0] register_svc[14:13];  //the general register of the state of svc
reg [data_width-1:0] register_abt[14:13];  //the general register of the state of  abt
reg [data_width-1:0] register_irq[14:13];  //the general register of the state of irq
reg [data_width-1:0] register_und[14:13];  //the general register of the state of und
reg [data_width-1:0] register_CPSR;
reg [data_width-1:0] register_SPSR[4:0];  //the SPSR register under five states(fiq,svc,abt,irq,und)

//to initial or not register_CPSR

parameter [4:0] user=5'b10000,fiq=5'b10001,irq=5'b10010,svc=5'b10011,abt=5'b10111,und=5'b11011,sys=5'b11111;// the definition of 7 modes

always @ (posedge clk)
begin
    register_ge[15]<={PC_in[31:2],2'b0};  //the [1:0] of pc under ARM is 0 and the rest is the counter
    if (CPSR_byte_w_en[0]==0) register_CPSR[7:0]<=CPSR_in[7:0];
    if (CPSR_byte_w_en[1]==0) register_CPSR[15:8]<=CPSR_in[15:8];
    if (CPSR_byte_w_en[2]==0) register_CPSR[23:16]<=CPSR_in[23:16];
    if (CPSR_byte_w_en[3]==0) register_CPSR[31:24]<=CPSR_in[31:24];
    if (rst==1) //reset the flags
    begin
        register_CPSR[31:28]<=4'b0;  //make the higher flags be zeros
    end
    case (register_CPSR[4:0])
        user,sys://user and sys modes
            begin
                if (Rn_w_addr>=0&&Rn_w_addr<15)
                begin
                    if (Rn_byte_w_en[0]==0) register_ge[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_ge[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_ge[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_ge[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
					 if (Rd_w_addr>=0&&Rd_w_addr<15)
					 begin
						  if (Rd_byte_w_en[0]==0) register_ge[Rd_w_addr][7:0]<=Rd_in[7:0];
						  if (Rd_byte_w_en[1]==0) register_ge[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_ge[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_ge[Rd_w_addr][31:24]<=Rd_in[31:24];
					 end
                //choose the register that the input Rn to write in
            end
            fiq:  // fiq mode
            begin
                if (Rn_w_addr>=0&&Rn_w_addr<8)
                begin
                    if (Rn_byte_w_en[0]==0) register_ge[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_ge[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_ge[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_ge[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rn_w_addr>7&&Rn_w_addr<15)
                begin
                    if (Rn_byte_w_en[0]==0) register_fiq[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_fiq[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_fiq[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_fiq[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rd_w_addr>=0&&Rd_w_addr<8)
                begin
                    if (Rd_byte_w_en[0]==0) register_ge[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_ge[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_ge[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_ge[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
                if (Rd_w_addr>7&&Rd_w_addr<15)
                begin
                    if (Rd_byte_w_en[0]==0) register_fiq[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_fiq[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_fiq[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_fiq[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
			 	    if (SPSR_byte_w_en[0]==0) register_SPSR[0][7:0]=SPSR_in[7:0];
                if (SPSR_byte_w_en[1]==0) register_SPSR[0][15:8]=SPSR_in[15:8];
                if (SPSR_byte_w_en[2]==0) register_SPSR[0][23:16]=SPSR_in[23:16];
                if (SPSR_byte_w_en[3]==0) register_SPSR[0][31:24]=SPSR_in[31:24];
                //choose which SPSR byte to write in
            end
            svc:  // svc mode 
            begin
                if (Rn_w_addr>=0&&Rn_w_addr<13)
                begin
                    if (Rn_byte_w_en[0]==0) register_ge[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_ge[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_ge[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_ge[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rn_w_addr>12&&Rn_w_addr<15)
                begin
                    if (Rn_byte_w_en[0]==0) register_svc[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_svc[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_svc[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_svc[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rd_w_addr>=0&&Rd_w_addr<13)
                begin
                    if (Rd_byte_w_en[0]==0) register_ge[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_ge[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_ge[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_ge[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
                if (Rd_w_addr>12&&Rd_w_addr<15)
                begin
                    if (Rd_byte_w_en[0]==0) register_svc[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_svc[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_svc[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_svc[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
                if (SPSR_byte_w_en[0]==0) register_SPSR[1][7:0]=SPSR_in[7:0];
                if (SPSR_byte_w_en[1]==0) register_SPSR[1][15:8]=SPSR_in[15:8];
                if (SPSR_byte_w_en[2]==0) register_SPSR[1][23:16]=SPSR_in[23:16];
                if (SPSR_byte_w_en[3]==0) register_SPSR[1][31:24]=SPSR_in[31:24];
                //choose which SPSR byte to write in
            end
            abt:  // abt mode 
            begin
                if (Rn_w_addr>=0&&Rn_w_addr<13)
                begin
                    if (Rn_byte_w_en[0]==0) register_ge[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_ge[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_ge[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_ge[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rn_w_addr>12&&Rn_w_addr<15)
                begin
                    if (Rn_byte_w_en[0]==0) register_abt[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_abt[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_abt[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_abt[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rd_w_addr>=0&&Rd_w_addr<13)
                begin
                    if (Rd_byte_w_en[0]==0) register_ge[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_ge[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_ge[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_ge[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
                if (Rd_w_addr>12&&Rd_w_addr<15)
                begin
                    if (Rd_byte_w_en[0]==0) register_abt[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_abt[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_abt[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_abt[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
                if (SPSR_byte_w_en[0]==0) register_SPSR[2][7:0]=SPSR_in[7:0];
                if (SPSR_byte_w_en[1]==0) register_SPSR[2][15:8]=SPSR_in[15:8];
                if (SPSR_byte_w_en[2]==0) register_SPSR[2][23:16]=SPSR_in[23:16];
                if (SPSR_byte_w_en[3]==0) register_SPSR[2][31:24]=SPSR_in[31:24];
                //choose which SPSR byte to write in
            end
            irq: //irq mode 
            begin
                if (Rn_w_addr>=0&&Rn_w_addr<13)
                begin
                    if (Rn_byte_w_en[0]==0) register_ge[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_ge[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_ge[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_ge[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rn_w_addr>12&&Rn_w_addr<15)
                begin
                    if (Rn_byte_w_en[0]==0) register_irq[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_irq[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_irq[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_irq[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rd_w_addr>=0&&Rd_w_addr<13)
                begin
                    if (Rd_byte_w_en[0]==0) register_ge[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_ge[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_ge[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_ge[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
                if (Rd_w_addr>12&&Rd_w_addr<15)
                begin
                    if (Rd_byte_w_en[0]==0) register_irq[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_irq[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_irq[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_irq[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
                if (SPSR_byte_w_en[0]==0) register_SPSR[3][7:0]=SPSR_in[7:0];
                if (SPSR_byte_w_en[1]==0) register_SPSR[3][15:8]=SPSR_in[15:8];
                if (SPSR_byte_w_en[2]==0) register_SPSR[3][23:16]=SPSR_in[23:16];
                if (SPSR_byte_w_en[3]==0) register_SPSR[3][31:24]=SPSR_in[31:24];
                //choose which SPSR byte to write in
            end
            und:  // und mode 
            begin
                if (Rn_w_addr>=0&&Rn_w_addr<13)
                begin
                    if (Rn_byte_w_en[0]==0) register_ge[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_ge[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_ge[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_ge[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rn_w_addr>12&&Rn_w_addr<15)
                begin
                    if (Rn_byte_w_en[0]==0) register_und[Rn_w_addr][7:0]<=Rn_in[7:0];
                    if (Rn_byte_w_en[1]==0) register_und[Rn_w_addr][15:8]<=Rn_in[15:8];
                    if (Rn_byte_w_en[2]==0) register_und[Rn_w_addr][23:16]<=Rn_in[23:16];
                    if (Rn_byte_w_en[3]==0) register_und[Rn_w_addr][31:24]<=Rn_in[31:24];
                end  //choose the register that the input Rn to write in
                if (Rd_w_addr>=0&&Rd_w_addr<13)
                begin
                    if (Rd_byte_w_en[0]==0) register_ge[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_ge[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_ge[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_ge[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
                if (Rd_w_addr>12&&Rd_w_addr<15)
                begin
                    if (Rd_byte_w_en[0]==0) register_und[Rd_w_addr][7:0]<=Rd_in[7:0];
                    if (Rd_byte_w_en[1]==0) register_und[Rd_w_addr][15:8]<=Rd_in[15:8];
                    if (Rd_byte_w_en[2]==0) register_und[Rd_w_addr][23:16]<=Rd_in[23:16];
                    if (Rd_byte_w_en[3]==0) register_und[Rd_w_addr][31:24]<=Rd_in[31:24];
                end  //choose the register that the input Rd to write in
                if (SPSR_byte_w_en[0]==0) register_SPSR[4][7:0]=SPSR_in[7:0];
                if (SPSR_byte_w_en[1]==0) register_SPSR[4][15:8]=SPSR_in[15:8];
                if (SPSR_byte_w_en[2]==0) register_SPSR[4][23:16]=SPSR_in[23:16];
                if (SPSR_byte_w_en[3]==0) register_SPSR[4][31:24]=SPSR_in[31:24];
                //choose which SPSR byte to write in
            end
        endcase
end

always @ (*)   // read from the registers 
begin
	    case (register_CPSR[4:0])
        user,sys://user and sys modes
            begin
                if (Rn_r_addr>=0&&Rn_r_addr<15) Rn_out<=register_ge[Rn_r_addr];
                if (Rm_r_addr>=0&&Rm_r_addr<15) Rm_out<=register_ge[Rm_r_addr];
                if (Rs_r_addr>=0&&Rs_r_addr<15) Rs_out<=register_ge[Rs_r_addr];
                if (Rd_r_addr>=0&&Rd_r_addr<15) Rd_out<=register_ge[Rd_r_addr];
                PC_out=register_ge[15];
                CPSR_out=register_CPSR;
                Mode_out=register_CPSR[4:0];
            end
            fiq:  // the fiq mode 
            begin
                if (Rn_r_addr>=0&&Rn_r_addr<8) Rn_out=register_ge[Rn_r_addr];
                if (Rm_r_addr>=0&&Rm_r_addr<8) Rm_out=register_ge[Rm_r_addr];
                if (Rs_r_addr>=0&&Rs_r_addr<8) Rs_out=register_ge[Rs_r_addr];
                if (Rd_r_addr>=0&&Rd_r_addr<8) Rd_out=register_ge[Rd_r_addr];
                if (Rn_r_addr>7&&Rn_r_addr<15) Rn_out=register_fiq[Rn_r_addr];
                if (Rm_r_addr>7&&Rm_r_addr<15) Rm_out=register_fiq[Rm_r_addr];
                if (Rs_r_addr>7&&Rs_r_addr<15) Rs_out=register_fiq[Rs_r_addr];
                if (Rd_r_addr>7&&Rd_r_addr<15) Rd_out=register_fiq[Rd_r_addr];
                PC_out=register_ge[15];
                CPSR_out=register_CPSR;
                SPSR_out=register_SPSR[0];
                Mode_out=register_CPSR[4:0];
            end
            svc:  // the svc mode 
            begin
                if (Rn_r_addr>=0&&Rn_r_addr<13) Rn_out=register_ge[Rn_r_addr];
                if (Rm_r_addr>=0&&Rm_r_addr<13) Rm_out=register_ge[Rm_r_addr];
                if (Rs_r_addr>=0&&Rs_r_addr<13) Rs_out=register_ge[Rs_r_addr];
                if (Rd_r_addr>=0&&Rd_r_addr<13) Rd_out=register_ge[Rd_r_addr];
                if (Rn_r_addr>12&&Rn_r_addr<15) Rn_out=register_svc[Rn_r_addr];
                if (Rm_r_addr>12&&Rm_r_addr<15) Rm_out=register_svc[Rm_r_addr];
                if (Rs_r_addr>12&&Rs_r_addr<15) Rs_out=register_svc[Rs_r_addr];
                if (Rd_r_addr>12&&Rd_r_addr<15) Rd_out=register_svc[Rd_r_addr];
                PC_out=register_ge[15];
                CPSR_out=register_CPSR;
                SPSR_out=register_SPSR[1];
                Mode_out=register_CPSR[4:0];
            end
            abt:  // the abt mode 
            begin
                if (Rn_r_addr>=0&&Rn_r_addr<13) Rn_out=register_ge[Rn_r_addr];
                if (Rm_r_addr>=0&&Rm_r_addr<13) Rm_out=register_ge[Rm_r_addr];
                if (Rs_r_addr>=0&&Rs_r_addr<13) Rs_out=register_ge[Rs_r_addr];
                if (Rd_r_addr>=0&&Rd_r_addr<13) Rd_out=register_ge[Rd_r_addr];
                if (Rn_r_addr>12&&Rn_r_addr<15) Rn_out=register_abt[Rn_r_addr];
                if (Rm_r_addr>12&&Rm_r_addr<15) Rm_out=register_abt[Rm_r_addr];
                if (Rs_r_addr>12&&Rs_r_addr<15) Rs_out=register_abt[Rs_r_addr];
                if (Rd_r_addr>12&&Rd_r_addr<15) Rd_out=register_abt[Rd_r_addr];
                PC_out=register_ge[15];
                CPSR_out=register_CPSR;
                SPSR_out=register_SPSR[2];
                Mode_out=register_CPSR[4:0];
            end
            irq:// the irq mode 
            begin
                if (Rn_r_addr>=0&&Rn_r_addr<13) Rn_out=register_ge[Rn_r_addr];
                if (Rm_r_addr>=0&&Rm_r_addr<13) Rm_out=register_ge[Rm_r_addr];
                if (Rs_r_addr>=0&&Rs_r_addr<13) Rs_out=register_ge[Rs_r_addr];
                if (Rd_r_addr>=0&&Rd_r_addr<13) Rd_out=register_ge[Rd_r_addr];
                if (Rn_r_addr>12&&Rn_r_addr<=15) Rn_out=register_irq[Rn_r_addr];
                if (Rm_r_addr>12&&Rm_r_addr<=15) Rm_out=register_irq[Rm_r_addr];
                if (Rs_r_addr>12&&Rs_r_addr<=15) Rs_out=register_irq[Rs_r_addr];
                if (Rd_r_addr>12&&Rd_r_addr<=15) Rd_out=register_irq[Rd_r_addr];
                PC_out=register_ge[15];
                CPSR_out=register_CPSR;
                SPSR_out=register_SPSR[3];
                Mode_out=register_CPSR[4:0];
            end
            und:  // the und mode 
            begin
                if (Rn_r_addr>=0&&Rn_r_addr<13) Rn_out=register_ge[Rn_r_addr];
                if (Rm_r_addr>=0&&Rm_r_addr<13) Rm_out=register_ge[Rm_r_addr];
                if (Rs_r_addr>=0&&Rs_r_addr<13) Rs_out=register_ge[Rs_r_addr];
                if (Rd_r_addr>=0&&Rd_r_addr<13) Rd_out=register_ge[Rd_r_addr];
                if (Rn_r_addr>12&&Rn_r_addr<=15) Rn_out=register_und[Rn_r_addr];
                if (Rm_r_addr>12&&Rm_r_addr<=15) Rm_out=register_und[Rm_r_addr];
                if (Rs_r_addr>12&&Rs_r_addr<=15) Rs_out=register_und[Rs_r_addr];
                if (Rd_r_addr>12&&Rd_r_addr<=15) Rd_out=register_und[Rd_r_addr];
                PC_out=register_ge[15];
                CPSR_out=register_CPSR;
                SPSR_out=register_SPSR[4];
                Mode_out=register_CPSR[4:0];
            end
        endcase
end 
endmodule
