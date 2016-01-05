library verilog;
use verilog.vl_types.all;
entity Cpu_control is
    port(
        IR              : in     vl_logic_vector(31 downto 0);
        Jump            : out    vl_logic;
        Shift_op        : out    vl_logic_vector(1 downto 0);
        Ex_op           : out    vl_logic;
        Shift_amountSrc : out    vl_logic;
        RegDst          : out    vl_logic;
        ALU_op          : out    vl_logic_vector(3 downto 0);
        ALUShift_sel    : out    vl_logic;
        Condition       : out    vl_logic_vector(2 downto 0);
        ALUsrcB         : out    vl_logic_vector(1 downto 0);
        Overflow        : in     vl_logic;
        Rd_write_byte_en: out    vl_logic_vector(3 downto 0);
        RegDst0         : out    vl_logic
    );
end Cpu_control;
