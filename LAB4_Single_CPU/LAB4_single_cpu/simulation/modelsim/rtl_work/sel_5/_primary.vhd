library verilog;
use verilog.vl_types.all;
entity sel_5 is
    port(
        A               : in     vl_logic_vector(4 downto 0);
        B               : in     vl_logic_vector(4 downto 0);
        Op              : in     vl_logic;
        result          : out    vl_logic_vector(4 downto 0)
    );
end sel_5;
