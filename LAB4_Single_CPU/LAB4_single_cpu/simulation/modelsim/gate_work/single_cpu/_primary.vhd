library verilog;
use verilog.vl_types.all;
entity single_cpu is
    port(
        clk             : in     vl_logic;
        PC_out          : out    vl_logic_vector(31 downto 0);
        IR              : out    vl_logic_vector(31 downto 0);
        busA            : out    vl_logic_vector(31 downto 0);
        busB            : out    vl_logic_vector(31 downto 0);
        ALU_out         : out    vl_logic_vector(31 downto 0);
        ALUShift_out    : out    vl_logic_vector(31 downto 0);
        Rd_write_byte_en: out    vl_logic_vector(3 downto 0);
        ALUsrcB         : out    vl_logic_vector(1 downto 0);
        Ex_top          : out    vl_logic;
        ALU_op          : out    vl_logic_vector(3 downto 0);
        RegDst          : out    vl_logic;
        Shift_amountSrc : out    vl_logic;
        ALUShift_sel    : out    vl_logic;
        Condition       : out    vl_logic_vector(2 downto 0);
        Shift_op        : out    vl_logic_vector(1 downto 0);
        Jump            : out    vl_logic;
        Overflow        : out    vl_logic;
        Less            : out    vl_logic;
        Zero            : out    vl_logic
    );
end single_cpu;
