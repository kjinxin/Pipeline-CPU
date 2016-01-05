library verilog;
use verilog.vl_types.all;
entity GetIR is
    port(
        addr            : in     vl_logic_vector(31 downto 0);
        IR              : out    vl_logic_vector(31 downto 0)
    );
end GetIR;
