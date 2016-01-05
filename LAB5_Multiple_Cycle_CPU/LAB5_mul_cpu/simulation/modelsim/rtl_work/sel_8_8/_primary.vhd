library verilog;
use verilog.vl_types.all;
entity sel_8_8 is
    port(
        c7              : in     vl_logic_vector(7 downto 0);
        c6              : in     vl_logic_vector(7 downto 0);
        c5              : in     vl_logic_vector(7 downto 0);
        c4              : in     vl_logic_vector(7 downto 0);
        c3              : in     vl_logic_vector(7 downto 0);
        c2              : in     vl_logic_vector(7 downto 0);
        c1              : in     vl_logic_vector(7 downto 0);
        c0              : in     vl_logic_vector(7 downto 0);
        Condition       : in     vl_logic_vector(2 downto 0);
        Op              : out    vl_logic_vector(7 downto 0)
    );
end sel_8_8;
