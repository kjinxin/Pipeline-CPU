library verilog;
use verilog.vl_types.all;
entity addr_reg is
    port(
        clk             : in     vl_logic;
        AddrReg_in      : in     vl_logic_vector(31 downto 0);
        AddrReg_write_en: in     vl_logic;
        AddrReg_out     : out    vl_logic_vector(31 downto 0)
    );
end addr_reg;
