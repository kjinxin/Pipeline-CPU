library verilog;
use verilog.vl_types.all;
entity lab1_121220307_ARM32 is
    port(
        Rn_r_addr       : in     vl_logic_vector(3 downto 0);
        Rm_r_addr       : in     vl_logic_vector(3 downto 0);
        Rs_r_addr       : in     vl_logic_vector(3 downto 0);
        Rd_r_addr       : in     vl_logic_vector(3 downto 0);
        Rn_w_addr       : in     vl_logic_vector(3 downto 0);
        Rd_w_addr       : in     vl_logic_vector(3 downto 0);
        Rd_in           : in     vl_logic_vector(31 downto 0);
        Rn_in           : in     vl_logic_vector(31 downto 0);
        PC_in           : in     vl_logic_vector(31 downto 0);
        CPSR_in         : in     vl_logic_vector(31 downto 0);
        SPSR_in         : in     vl_logic_vector(31 downto 0);
        CPSR_byte_w_en  : in     vl_logic_vector(3 downto 0);
        SPSR_byte_w_en  : in     vl_logic_vector(3 downto 0);
        Rd_byte_w_en    : in     vl_logic_vector(3 downto 0);
        Rn_byte_w_en    : in     vl_logic_vector(3 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        Rn_out          : out    vl_logic_vector(31 downto 0);
        Rm_out          : out    vl_logic_vector(31 downto 0);
        Rs_out          : out    vl_logic_vector(31 downto 0);
        Rd_out          : out    vl_logic_vector(31 downto 0);
        PC_out          : out    vl_logic_vector(31 downto 0);
        CPSR_out        : out    vl_logic_vector(31 downto 0);
        SPSR_out        : out    vl_logic_vector(31 downto 0);
        Mode_out        : out    vl_logic_vector(4 downto 0)
    );
end lab1_121220307_ARM32;
