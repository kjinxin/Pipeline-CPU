library verilog;
use verilog.vl_types.all;
entity lab2_121220307_ARM32 is
    port(
        Shift_in        : in     vl_logic_vector(31 downto 0);
        Shift_amount    : in     vl_logic_vector(4 downto 0);
        Shift_op        : in     vl_logic_vector(1 downto 0);
        Carry_flag      : in     vl_logic;
        Shift_out       : out    vl_logic_vector(31 downto 0);
        Shift_carry_out : out    vl_logic
    );
end lab2_121220307_ARM32;
