library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
    generic (
        WIDTH_TOP : integer := 4
    );
    Port ( 
        FPGA_CLK: in std_logic;
        RST_TOP : in std_logic;
        IN_A    : in std_logic_vector(WIDTH_TOP-1 downto 0);
        IN_B    : in std_logic_vector(WIDTH_TOP-1 downto 0);
        SEL_A   : in std_logic;
        SEL_B   : in std_logic;
        SEL_ALU : in std_logic_vector(1 downto 0);
    
        AN_CYCLE_TOP: out std_logic_vector(7 downto 0);
        CURRENT_CAG : out std_logic_vector(6 downto 0);
        RESULT_NEG  : out std_logic;
        RESULT_ERR  : out std_logic
    );
end TOP;

architecture Behavioral of TOP is
-- SIGNALS ---------------------------------------------------------                               

signal SLOW_CLK_SIGNAL: std_logic;
signal REG_A, REG_B: std_logic_vector(WIDTH_TOP-1 downto 0) := (others => '0');     -- two diigt BCD (8 bits) version of the HEX input 

signal DISP_A, DISP_B, DISP_CH, DISP_CL: std_logic_vector(WIDTH_TOP-1 downto 0) := (others => '0');    -- BCD or lower half of two digit BCD that will be converted to CAG form

signal SEL_4X1: std_logic_vector(1 downto 0) := (others =>'0'); -- Select for 4x1 mux which comes from the CLK divider
signal OUT_4X1: std_logic_vector(WIDTH_TOP-1 downto 0) := (others =>'0'); -- Output from 4x1 mux which is converted to CAG and read by 7segs
signal OUT_BCD: std_logic_vector(WIDTH_TOP*2-1 downto 0);
signal OUT_ALU: std_logic_vector(WIDTH_TOP*2-1 downto 0);

-- COMPONENTS-------------------------------------------------------
component CLK_DIVIDER
    Port ( 
        SYS_CLK     : in std_logic;
        RST_SS      : in std_logic;
        SLOW_CLK    : out std_logic;
        AN_CYCLE    : out std_logic_vector(7 downto 0);
        MUX_CYCLE   : out std_logic_vector(1 downto 0)
    );
end component;

component MUX2X1
    Port ( 
        MUX_HEX : in std_logic_vector(3 downto 0);
        MUX_BCD : in std_logic_vector(3 downto 0);
        MUX_S   : in std_logic;
        MUX_OUT : out std_logic_vector(3 downto 0)
    );
end component;

component MUX4X1
    Port (         
        MUX_A   : in std_logic_vector(3 downto 0);
        MUX_B   : in std_logic_vector(3 downto 0);
        MUX_CH  : in std_logic_vector(3 downto 0);
        MUX_CL  : in std_logic_vector(3 downto 0);
        MUX_S   : in std_logic_vector(1 downto 0);
        MUX_OUT : out std_logic_vector(3 downto 0)
    );
end component;
component SS_DECODER
    Port ( 
        DECODER_IN  : in std_logic_vector(3 downto 0);
        DECODER_OUT : out std_logic_vector(6 downto 0)   
    );
end component;

component ALU is
    generic(
        WIDTH_ALU : integer:=4
    );
    Port ( 
        CLK_ALU : in std_logic;
        RST_ALU : in std_logic;
        A_ALU   : in std_logic_vector(WIDTH_ALU-1 downto 0);
        B_ALU   : in std_logic_vector(WIDTH_ALU-1 downto 0);
        SEL_ALU : in std_logic_vector(1 downto 0);
        
        RES_ALU : out std_logic_vector(WIDTH_ALU*2-1 downto 0);
        NEG_ALU : out std_logic;
        ERR_ALU : out std_logic  
    );
end component ALU;

begin
-- Process --------------------------------------------------------

process(IN_A, IN_B)
begin
    if to_integer(unsigned(IN_A)) > 9 then      -- If HEX input A greater than 9
        REG_A <= std_logic_vector(unsigned(IN_A) + 6);            
    else
        REG_A <= IN_A;
    end if;   
    if to_integer(unsigned(IN_B)) > 9 then      -- If HEX input B greater than 9
        REG_B <= std_logic_vector(unsigned(IN_B) + 6);
    else
        REG_B <= IN_B;
    end if;                   
end process;

-- PORT MAPS-------------------------------------------------------
CLK_MAP: CLK_DIVIDER
    port map(
        SYS_CLK     => FPGA_CLK,
        RST_SS      => RST_TOP,
        SLOW_CLK    => SLOW_CLK_SIGNAL,
        AN_CYCLE    => AN_CYCLE_TOP,
        MUX_CYCLE   => SEL_4X1
    );

MUX_A: MUX2X1
    port map(
        MUX_HEX => IN_A,
        MUX_BCD => REG_A,
        MUX_S   => SEL_A,
        MUX_OUT => DISP_A
    );

MUX_B: MUX2X1
    port map(
        MUX_HEX => IN_B,
        MUX_BCD => REG_B,
        MUX_S   => SEL_B,
        MUX_OUT => DISP_B
    );

DISPLAY_MUX: MUX4X1
    port map(
        MUX_A   => DISP_A,
        MUX_B   => DISP_B,
        MUX_CH  => DISP_CH,
        MUX_CL  => DISP_CL,
        MUX_S   => SEL_4X1,
        MUX_OUT => OUT_4X1   
    );

BINARY2BCD: B2BCD
    generic map(
        N => WIDTH_TOP*2,
        digits => 2
        )
    port map(
        clk     => FPGA_CLK,
        reset   => RST_TOP,
		binary_in	=> OUT_ALU,		
		bcd     => OUT_BCD
    );    
    
GET_CAG: SS_DECODER
    port map(
        DECODER_IN  => OUT_4X1,
        DECODER_OUT => CURRENT_CAG
    );    

ALU_INST : ALU
    generic map(
        WIDTH_ALU => WIDTH_TOP
    )
    port map ( 
        CLK_ALU => FPGA_CLK,
        RST_ALU => RST_TOP,
        A_ALU   => REG_A,
        B_ALU   => REG_B,
        SEL_ALU => SEL_ALU,
        
        RES_ALU => OUT_ALU,
        NEG_ALU => RESULT_NEG,
        ERR_ALU => RESULT_ERR
    );

DISP_CH <= OUT_BCD(WIDTH_TOP*2-1 downto WIDTH_TOP);
DISP_CL <= OUT_BCD(WIDTH_TOP-1 downto 0);
end Behavioral;
