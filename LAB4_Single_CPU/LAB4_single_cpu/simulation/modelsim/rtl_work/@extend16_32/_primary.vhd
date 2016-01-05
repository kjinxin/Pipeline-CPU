library verilog;
use verilog.vl_types.all;
entity Extend16_32 is
    port(
        cin             : in     vl_logic_vector(15 downto 0);
        Op              : in     vl_logic;
        result          : out    vl_logic_vector(31 downto 0)
    );
end Extend16_32;
