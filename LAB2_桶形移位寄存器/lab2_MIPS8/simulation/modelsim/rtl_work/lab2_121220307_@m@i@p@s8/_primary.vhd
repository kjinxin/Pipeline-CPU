library verilog;
use verilog.vl_types.all;
entity lab2_121220307_MIPS8 is
    port(
        Shift_in        : in     vl_logic_vector(7 downto 0);
        Shift_amount    : in     vl_logic_vector(2 downto 0);
        Shift_op        : in     vl_logic_vector(1 downto 0);
        Shift_out       : out    vl_logic_vector(7 downto 0)
    );
end lab2_121220307_MIPS8;
