library verilog;
use verilog.vl_types.all;
entity LAB5_121220307_mul_cpu is
    port(
        clk             : in     vl_logic;
        PC_write_cond   : out    vl_logic;
        PC_write        : out    vl_logic;
        Iord            : out    vl_logic;
        MemtoReg        : out    vl_logic_vector(1 downto 0);
        Mem_addr_in     : out    vl_logic_vector(31 downto 0);
        Mem_byte_write  : out    vl_logic_vector(3 downto 0);
        RegDt0          : out    vl_logic;
        IR_write        : out    vl_logic;
        RegDst          : out    vl_logic_vector(1 downto 0);
        Condition       : out    vl_logic_vector(2 downto 0);
        ALUSrcA         : out    vl_logic;
        ALUSrcB         : out    vl_logic_vector(2 downto 0);
        ALU_op          : out    vl_logic_vector(3 downto 0);
        Ex_top          : out    vl_logic;
        Shift_op        : out    vl_logic_vector(1 downto 0);
        Shift_amountSrc : out    vl_logic;
        PC_source       : out    vl_logic_vector(1 downto 0);
        ALUShift_sel    : out    vl_logic;
        AddrReg_write_en: out    vl_logic;
        Rd_write_byte_en: out    vl_logic_vector(3 downto 0);
        busA            : out    vl_logic_vector(31 downto 0);
        busB            : out    vl_logic_vector(31 downto 0);
        PC_out          : out    vl_logic_vector(31 downto 0);
        ALU_out         : out    vl_logic_vector(31 downto 0);
        AddrReg_out     : out    vl_logic_vector(31 downto 0);
        Overflow        : out    vl_logic;
        Less            : out    vl_logic;
        Zero            : out    vl_logic;
        state           : out    vl_logic_vector(3 downto 0);
        IR              : out    vl_logic_vector(31 downto 0);
        ALUShift_out    : out    vl_logic_vector(31 downto 0);
        Shift_out       : out    vl_logic_vector(31 downto 0);
        Rs              : out    vl_logic_vector(4 downto 0);
        Rd              : out    vl_logic_vector(4 downto 0);
        Rt              : out    vl_logic_vector(4 downto 0);
        A               : out    vl_logic_vector(31 downto 0);
        B               : out    vl_logic_vector(31 downto 0);
        Rt_out_shift    : out    vl_logic_vector(31 downto 0);
        Rd_in           : out    vl_logic_vector(31 downto 0)
    );
end LAB5_121220307_mul_cpu;
