library verilog;
use verilog.vl_types.all;
entity sel_32_03 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        C               : in     vl_logic_vector(31 downto 0);
        Op              : in     vl_logic_vector(1 downto 0);
        result          : out    vl_logic_vector(31 downto 0)
    );
end sel_32_03;
