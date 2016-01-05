library verilog;
use verilog.vl_types.all;
entity sel_7 is
    port(
        c7              : in     vl_logic;
        c6              : in     vl_logic;
        c5              : in     vl_logic;
        c4              : in     vl_logic;
        c3              : in     vl_logic;
        c2              : in     vl_logic;
        c1              : in     vl_logic;
        c0              : in     vl_logic;
        Condition       : in     vl_logic_vector(2 downto 0);
        Op              : out    vl_logic
    );
end sel_7;
