library verilog;
use verilog.vl_types.all;
entity sel_32_5 is
    port(
        data4           : in     vl_logic_vector(31 downto 0);
        data3           : in     vl_logic_vector(31 downto 0);
        data2           : in     vl_logic_vector(31 downto 0);
        data1           : in     vl_logic_vector(31 downto 0);
        data0           : in     vl_logic_vector(31 downto 0);
        Op              : in     vl_logic_vector(2 downto 0);
        result          : out    vl_logic_vector(31 downto 0)
    );
end sel_32_5;
