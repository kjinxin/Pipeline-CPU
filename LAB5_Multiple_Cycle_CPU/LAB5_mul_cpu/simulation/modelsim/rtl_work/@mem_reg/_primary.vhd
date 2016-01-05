library verilog;
use verilog.vl_types.all;
entity Mem_reg is
    port(
        clk             : in     vl_logic;
        Mem_addr        : in     vl_logic_vector(31 downto 0);
        Mem_data_in     : in     vl_logic_vector(31 downto 0);
        Mem_byte_w_en   : in     vl_logic_vector(3 downto 0);
        Mem_data_out    : out    vl_logic_vector(31 downto 0)
    );
end Mem_reg;
