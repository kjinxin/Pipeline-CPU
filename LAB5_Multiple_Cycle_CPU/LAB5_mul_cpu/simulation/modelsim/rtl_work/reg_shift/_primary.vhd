library verilog;
use verilog.vl_types.all;
entity reg_shift is
    port(
        Mem_addr_in     : in     vl_logic_vector(1 downto 0);
        Rt_out          : in     vl_logic_vector(31 downto 0);
        IR              : in     vl_logic_vector(31 downto 26);
        Rt_out_shift    : out    vl_logic_vector(31 downto 0)
    );
end reg_shift;
