library verilog;
use verilog.vl_types.all;
entity IR_reg is
    port(
        clk             : in     vl_logic;
        IR_in           : in     vl_logic_vector(31 downto 0);
        IR_write_en     : in     vl_logic;
        IR              : out    vl_logic_vector(31 downto 0)
    );
end IR_reg;
