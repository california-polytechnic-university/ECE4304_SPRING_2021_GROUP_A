library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity Top_Lab7 is
    Port ( 
        -- System signals
        TOP_CLK : in std_logic;
        TOP_RST : in std_logic;
        TOP_RX  : in std_logic;
        
        -- User inputs
        TOP_SHIFT_A : in std_logic_vector(2 downto 0);  -- A shift value
        TOP_SHIFT_B : in std_logic_vector(2 downto 0);  -- B shift value 
        TOP_PULL_A  : in std_logic;  -- Pull A from FIFO
        TOP_PULL_B  : in std_logic;  -- Pull B from FIFO
        TOP_ALU_SEL : in std_logic_vector(1 downto 0);  -- ALU operation select
        
        TOP_IN : in std_logic_vector(3 downto 0);
        
        -- FIFO status output
        TOP_FIFO_A_FULL : out std_logic;
        TOP_FIFO_B_FULL : out std_logic;
        TOP_FIFO_A_EMPTY: out std_logic;
        TOP_FIFO_B_EMPTY: out std_logic;
        
        -- ALU status output
        TOP_ALU_NEG : out std_logic;
        TOP_ALU_ERR : out std_logic;
        
        -- 7-segment display signals
        TOP_DSP_RST : in std_logic;
        TOP_CAG     : out std_logic_vector(6 downto 0);
        TOP_AN      : out std_logic_vector(7 downto 0);
        TOP_DP      : out std_logic
    );
end Top_Lab7;

architecture Behavioral of Top_Lab7 is

component UART_RX is
    port(
        CLK         : in  std_logic;
        RST         : in  std_logic; 
        RX_IN       : in  std_logic;
        DATAOUT     : out std_logic_vector(7 downto 0);
        DATAVALID   : out std_logic
    );
end component UART_RX;

component STD_FIFO is
	generic (
		DATA_WIDTH : integer :=   8;
		FIFO_DEPTH : integer := 256
	);
	Port ( 
		CLK		: in  STD_LOGIC;
		RST		: in  STD_LOGIC;
		WriteEn	: in  STD_LOGIC;
		DataIn	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		ReadEn	: in  STD_LOGIC;
		DataOut	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		Empty	: out STD_LOGIC;
		Full	: out STD_LOGIC
	);
end component STD_FIFO;

component BarrelShifter is
    generic(
        WIDTH : integer := 8
    );
    Port ( 
        VAL_IN  : in std_logic_vector(WIDTH-1 downto 0);
        SHIFT_IN: in std_logic_vector(integer(ceil(log2(real(WIDTH))))-1 downto 0);
        
        VAL_OUT : out std_logic_vector(WIDTH-1 downto 0)
    );
end component BarrelShifter;

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

component Top_7seg is
    Port ( 
        IN_CLK : in std_logic;
        IN_RST : in std_logic;
        
        -- IN_X is 4-bit value for that digit
        IN_0 : in std_logic_vector(3 downto 0);
        IN_1 : in std_logic_vector(3 downto 0);
        IN_2 : in std_logic_vector(3 downto 0);
        IN_3 : in std_logic_vector(3 downto 0);
        IN_4 : in std_logic_vector(3 downto 0);
        IN_5 : in std_logic_vector(3 downto 0);
        IN_6 : in std_logic_vector(3 downto 0);
        IN_7 : in std_logic_vector(3 downto 0);
        
        -- Digit enable vector
        IN_EN : in std_logic_vector(7 downto 0);
        
        -- Decimal point control
        -- 1 = Disabled, 0 = Enabled
        IN_DP : in std_logic;   
        
        -- Outputs
        OUT_CAG : out std_logic_vector(6 downto 0);
        OUT_AN  : out std_logic_vector(7 downto 0);
        OUT_DP  : out std_logic             
    );
end component Top_7seg;

signal RX_DATA : std_logic_vector(7 downto 0);  -- RX byte from RX module
signal RX_DONE : std_logic;                     -- Flag when data is valid

signal RX_FIFO_A_WR, RX_FIFO_B_WR       : std_logic;
signal RX_FIFO_A_FULL, RX_FIFO_B_FULL   : std_logic;
signal RX_FIFO_A_EMPTY, RX_FIFO_B_EMPTY : std_logic;
signal RX_FIFO_A_DATA, RX_FIFO_B_DATA   : std_logic_vector(7 downto 0);

signal SHIFT_A_DATA, SHIFT_B_DATA : std_logic_vector(7 downto 0);

signal ALU_DATA : std_logic_vector(15 downto 0);

signal tmp_busy : std_logic;

begin

    UART_INST : UART_RX 
    port map(
        CLK         => TOP_CLK,
        RST         => TOP_RST,
        RX_IN       => TOP_RX,
        DATAOUT     => RX_DATA,
        DATAVALID   => RX_DONE
    );
   
    -- Select for which FIFO RX component writes to.
    -- If FIFO A is full, write to FIFO B.
    RX_FIFO_A_WR    <= not RX_FIFO_A_FULL and RX_DONE;
    RX_FIFO_B_WR    <= RX_FIFO_A_FULL and RX_DONE;
      
    
    FIFO_A : STD_FIFO
	generic map (
		DATA_WIDTH =>   8,    -- 8 bits due to RX Byte
		FIFO_DEPTH =>   4     -- 4 rows described in lab description
	)
	port map ( 
		CLK		=> TOP_CLK,
		RST		=> TOP_RST,
		WriteEn	=> RX_FIFO_A_WR,
		DataIn	=> RX_DATA,
		ReadEn	=> TOP_PULL_A,
		DataOut	=> RX_FIFO_A_DATA,
		Empty	=> TOP_FIFO_A_EMPTY,
		Full	=> RX_FIFO_A_FULL
	);
	
	TOP_FIFO_A_FULL <= RX_FIFO_A_FULL;
	
	FIFO_B : STD_FIFO
	generic map (
		DATA_WIDTH =>   8,    -- 8 bits due to RX Byte
		FIFO_DEPTH =>   4     -- 4 rows described in lab description
	)
	port map ( 
		CLK		=> TOP_CLK,
		RST		=> TOP_RST,
		WriteEn	=> RX_FIFO_B_WR,
		DataIn	=> RX_DATA,
		ReadEn	=> TOP_PULL_B,
		DataOut	=> RX_FIFO_B_DATA,
		Empty	=> TOP_FIFO_B_EMPTY,
		Full	=> TOP_FIFO_B_FULL
	);
	
	BSHIFT_A : BarrelShifter
    generic map(
        WIDTH => 8
    )
    port map ( 
        VAL_IN   => RX_FIFO_A_DATA,
        SHIFT_IN => TOP_SHIFT_A,
        
        VAL_OUT  => SHIFT_A_DATA
    );
    
    BSHIFT_B : BarrelShifter
    generic map(
        WIDTH => 8
    )
    port map ( 
        VAL_IN   => RX_FIFO_B_DATA,
        SHIFT_IN => TOP_SHIFT_B,
        
        VAL_OUT  => SHIFT_B_DATA
    );
	
	ALU_INST : ALU
    generic map(
        WIDTH_ALU => 8
    )
    port map ( 
        CLK_ALU => TOP_CLK,
        RST_ALU => TOP_RST,
        A_ALU   => SHIFT_A_DATA,
        B_ALU   => SHIFT_B_DATA,
        SEL_ALU => TOP_ALU_SEL,
        
        RES_ALU => ALU_DATA, 
        NEG_ALU => TOP_ALU_NEG,
        ERR_ALU => TOP_ALU_ERR
    );
	
	DISP_7Seg : Top_7seg
    port map ( 
        IN_CLK => TOP_CLK,
        IN_RST => TOP_DSP_RST,
        IN_0 => SHIFT_B_DATA(3 downto 0),
        IN_1 => SHIFT_B_DATA(7 downto 4),
        IN_2 => SHIFT_A_DATA(3 downto 0),
        IN_3 => SHIFT_A_DATA(7 downto 4),
        IN_4 => ALU_DATA(3 downto 0),
        IN_5 => ALU_DATA(7 downto 4),
        IN_6 => ALU_DATA(11 downto 8),
        IN_7 => ALU_DATA(15 downto 12),   
        IN_EN => "11111111",
        IN_DP => '1', 
        
        OUT_CAG => TOP_CAG,
        OUT_AN  => TOP_AN,
        OUT_DP  => TOP_DP           
    );

end Behavioral;
