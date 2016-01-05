library verilog;
use verilog.vl_types.all;
entity PC_counter is
    port(
        clk             : in     vl_logic;
        PC_in           : in     vl_logic_vector(31 downto 0);
        IR              : in     vl_logic_vector(31 downto 0);
        Ex_offset       : in     vl_logic_vector(31 downto 0);
        Op              : in     vl_logic;
        Jump            : in     vl_logic;
        PC_out          : out    vl_logic_vector(31 downto 0)
    );
end PC_counter;
