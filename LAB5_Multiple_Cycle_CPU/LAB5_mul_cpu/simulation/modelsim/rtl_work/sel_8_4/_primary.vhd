library verilog;
use verilog.vl_types.all;
entity sel_8_4 is
    port(
        data3           : in     vl_logic_vector(7 downto 0);
        data2           : in     vl_logic_vector(7 downto 0);
        data1           : in     vl_logic_vector(7 downto 0);
        data0           : in     vl_logic_vector(7 downto 0);
        Op              : in     vl_logic_vector(1 downto 0);
        result          : out    vl_logic_vector(7 downto 0)
    );
end sel_8_4;
