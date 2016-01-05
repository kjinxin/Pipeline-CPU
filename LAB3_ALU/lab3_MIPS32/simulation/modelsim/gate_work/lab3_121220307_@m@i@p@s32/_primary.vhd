library verilog;
use verilog.vl_types.all;
entity lab3_121220307_MIPS32 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        ALU_op          : in     vl_logic_vector(3 downto 0);
        ALU_out         : out    vl_logic_vector(31 downto 0);
        Zero            : out    vl_logic;
        Less            : out    vl_logic;
        Overflow        : out    vl_logic
    );
end lab3_121220307_MIPS32;
