library verilog;
use verilog.vl_types.all;
entity lab1_121220307_MIPS4 is
    generic(
        data_width      : integer := 4;
        addr_width      : integer := 4
    );
    port(
        rs_addr         : in     vl_logic_vector;
        rt_addr         : in     vl_logic_vector;
        rd_addr         : in     vl_logic_vector;
        rd_in           : in     vl_logic_vector;
        Rd_byte_w_en    : in     vl_logic_vector(3 downto 0);
        clk             : in     vl_logic;
        rs_out          : out    vl_logic_vector;
        rt_out          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of data_width : constant is 1;
    attribute mti_svvh_generic_type of addr_width : constant is 1;
end lab1_121220307_MIPS4;
