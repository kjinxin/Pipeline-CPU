library verilog;
use verilog.vl_types.all;
entity Cpu_control is
    generic(
        PCM             : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi0);
        IFetch          : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi1);
        RFetch_ID       : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi0);
        MemAdr          : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi1);
        lwFinish        : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi0);
        SwFinish        : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi1);
        Rexec           : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi0);
        RFinish         : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi1);
        Iexec           : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi0, Hi0);
        Brexec          : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi0, Hi1);
        BrFinish        : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi1, Hi0);
        JumpFinish      : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        Overflow        : in     vl_logic;
        IR              : in     vl_logic_vector(31 downto 0);
        PC_write_cond   : out    vl_logic;
        PC_write        : out    vl_logic;
        IorD            : out    vl_logic;
        MemtoReg        : out    vl_logic_vector(1 downto 0);
        Mem_adder_in    : in     vl_logic_vector(1 downto 0);
        Mem_byte_write  : out    vl_logic_vector(3 downto 0);
        RegDt0          : out    vl_logic;
        IR_write        : out    vl_logic;
        RegDst          : out    vl_logic_vector(1 downto 0);
        Condition       : out    vl_logic_vector(2 downto 0);
        ALUSrcA         : out    vl_logic;
        ALUSrcB         : out    vl_logic_vector(2 downto 0);
        ALU_op          : out    vl_logic_vector(3 downto 0);
        Ex_top          : out    vl_logic;
        Shift_op        : out    vl_logic_vector(1 downto 0);
        Shift_amountSrc : out    vl_logic;
        PC_source       : out    vl_logic_vector(1 downto 0);
        ALUShift_sel    : out    vl_logic;
        AddrReg_write_en: out    vl_logic;
        Rd_write_byte_en: out    vl_logic_vector(3 downto 0);
        state           : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PCM : constant is 2;
    attribute mti_svvh_generic_type of IFetch : constant is 2;
    attribute mti_svvh_generic_type of RFetch_ID : constant is 2;
    attribute mti_svvh_generic_type of MemAdr : constant is 2;
    attribute mti_svvh_generic_type of lwFinish : constant is 2;
    attribute mti_svvh_generic_type of SwFinish : constant is 2;
    attribute mti_svvh_generic_type of Rexec : constant is 2;
    attribute mti_svvh_generic_type of RFinish : constant is 2;
    attribute mti_svvh_generic_type of Iexec : constant is 2;
    attribute mti_svvh_generic_type of Brexec : constant is 2;
    attribute mti_svvh_generic_type of BrFinish : constant is 2;
    attribute mti_svvh_generic_type of JumpFinish : constant is 2;
end Cpu_control;
