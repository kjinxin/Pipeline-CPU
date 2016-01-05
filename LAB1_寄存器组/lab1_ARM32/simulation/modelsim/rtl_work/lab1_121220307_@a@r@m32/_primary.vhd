library verilog;
use verilog.vl_types.all;
entity lab1_121220307_ARM32 is
    generic(
        data_width      : integer := 32;
        addr_width      : integer := 4
    );
    port(
        Rn_r_addr       : in     vl_logic_vector;
        Rm_r_addr       : in     vl_logic_vector;
        Rs_r_addr       : in     vl_logic_vector;
        Rd_r_addr       : in     vl_logic_vector;
        Rn_w_addr       : in     vl_logic_vector;
        Rd_w_addr       : in     vl_logic_vector;
        Rd_in           : in     vl_logic_vector;
        Rn_in           : in     vl_logic_vector;
        PC_in           : in     vl_logic_vector;
        CPSR_in         : in     vl_logic_vector;
        SPSR_in         : in     vl_logic_vector;
        CPSR_byte_w_en  : in     vl_logic_vector(3 downto 0);
        SPSR_byte_w_en  : in     vl_logic_vector(3 downto 0);
        Rd_byte_w_en    : in     vl_logic_vector(3 downto 0);
        Rn_byte_w_en    : in     vl_logic_vector(3 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        Rn_out          : out    vl_logic_vector;
        Rm_out          : out    vl_logic_vector;
        Rs_out          : out    vl_logic_vector;
        Rd_out          : out    vl_logic_vector;
        PC_out          : out    vl_logic_vector;
        CPSR_out        : out    vl_logic_vector;
        SPSR_out        : out    vl_logic_vector;
        Mode_out        : out    vl_logic_vector(4 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of data_width : constant is 1;
    attribute mti_svvh_generic_type of addr_width : constant is 1;
end lab1_121220307_ARM32;
