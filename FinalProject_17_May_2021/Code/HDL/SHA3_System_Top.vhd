library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Top component for entire system
entity SHA3_System_Top is
    Port ( 
        TOP_CLK : in std_logic;
        TOP_RST : in std_logic;
        
        -- VGA component ports
        TOP_SW   : in std_logic_vector (1 downto 0);
        TOP_HSYNC: out std_logic;
        TOP_VSYNC: out std_logic; 
        TOP_RED  : out std_logic_vector (3 downto 0); 
        TOP_GREEN: out std_logic_vector (3 downto 0);
        TOP_BLUE : out std_logic_vector (3 downto 0);   
        
        -- 7-seg component ports
        TOP_CAG : out std_logic_vector(6 downto 0);
        TOP_AN  : out std_logic_vector(7 downto 0);
        TOP_DP  : out std_logic;      
                
        -- SHA-3 component ports
        TOP_GO      : in std_logic;
        TOP_RDY     : in std_logic;
        TOP_DATA_IN : in std_logic_vector(1143 downto 0); 
        TOP_DATA_OUT: out std_logic_vector(511 downto 0);
        TOP_FINISH  : out std_logic
    );
end SHA3_System_Top;

architecture Behavioral of SHA3_System_Top is

    -- VGA top component
    component VGA_TOP is
    generic (
        STRIP_HPIXELS   : positive := 800;   -- Value of pixels in a horizontal line = 800
        STRIP_VLINES    : positive := 512;   -- Number of horizontal lines in the display = 521
        STRIP_HBP       : positive := 10;    -- Horizontal back porch = 144 (128 + 16)
        STRIP_HFP       : positive := 784;   -- Horizontal front porch = 784 (128+16 + 640)
        STRIP_VBP       : positive := 31;    -- Vertical back porch = 31 (2 + 29)
        STRIP_VFP       : positive := 511    -- Vertical front porch = 511 (2+29+ 480)
    );
    Port ( 
            CLK  : in std_logic;
            RST  : in std_logic;
               
            SW   : in std_logic_vector (1 downto 0);
               
            HSYNC: out std_logic;
            VSYNC: out std_logic; 
               
            HASH_224 : in std_logic_vector (223 downto 0);
            HASH_256 : in std_logic_vector (255 downto 0);
            HASH_384 : in std_logic_vector (383 downto 0);
            HASH_512 : in std_logic_vector (511 downto 0);
               
            RED  : out std_logic_vector (3 downto 0); 
            GREEN: out std_logic_vector (3 downto 0);
            BLUE : out std_logic_vector (3 downto 0)   
    );
    end component VGA_TOP;
    
    -- Binary-to-BCD component
    component B2BCD_Nbit is
        generic(
            WIDTH  : integer := 8;  -- WIDTH of input binary
            DIGITS : integer := 3   -- Amount of output BCD digits
        );
        Port ( 
            BCD_IN  : in std_logic_vector(WIDTH-1 downto 0);
            BCD_OUT : out std_logic_vector(4*DIGITS-1 downto 0)
        );
    end component B2BCD_Nbit;
    
    -- 7-segment component
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
    
    -- Message preparation component
    component Message_Prepare is
        Port ( 
            RAW_MSG : in std_logic_vector(1143 downto 0);
            SW      : in std_logic_vector(1 downto 0);        
            MSG_OUT : out std_logic_vector(1599 downto 0)
        );
    end component Message_Prepare;
    
    -- SHA-3 component
    component SHA3 is
        Port ( 
            CLK : in std_logic;
            RST : in std_logic;
            GO  : in std_logic;
            RDY : in std_logic;
            DATA_IN : in std_logic_vector(1599 downto 0); 
            DATA_OUT : out std_logic_vector(1599 downto 0);
            FINISH : out std_logic
        );
    end component SHA3;

    signal SHA3_MSGIN  : std_logic_vector(1599 downto 0);
    signal SHA3_Output : std_logic_vector(1599 downto 0);
    
    signal CLK_25, CLK_100  : std_logic;
    signal LOCK_PLL         : std_logic; 
    signal STEADY_CLK25, STEADY_CLK100 : std_logic;

    signal B2BCD_IN : std_logic_vector(9 downto 0);
    signal B2BCD_OUT : std_logic_vector(11 downto 0);

begin

    -- VGA instantiation
    VGA : VGA_TOP
    port map(
        CLK     => TOP_CLK,
        RST     => TOP_RST,
        SW      => TOP_SW,
        HASH_224=> SHA3_Output(1599 downto 1376),
        HASH_256=> SHA3_Output(1599 downto 1344),
        HASH_384=> SHA3_Output(1599 downto 1216),
        HASH_512=> SHA3_Output(1599 downto 1088),
        HSYNC   => TOP_HSYNC,
        VSYNC   => TOP_VSYNC,
        RED     => TOP_RED,
        GREEN   => TOP_GREEN,
        BLUE    => TOP_BLUE
    );
 
    -- B2BCD input based on switch input, denotes which SHA-3 mode
    SEG_OUTPUT : process (TOP_SW) begin
        case TOP_SW is
            when "00" => B2BCD_IN <= std_logic_vector(to_unsigned(224, B2BCD_IN'length));   -- 224
            when "01" => B2BCD_IN <= std_logic_vector(to_unsigned(256, B2BCD_IN'length));   -- 256
            when "10" => B2BCD_IN <= std_logic_vector(to_unsigned(384, B2BCD_IN'length));   -- 384
            when "11" => B2BCD_IN <= std_logic_vector(to_unsigned(512, B2BCD_IN'length));   -- 512
        end case;
    end process SEG_OUTPUT;
 
    -- Binary-to-BCD instantation to pass values to 7-segment display
    B2BCD : B2BCD_Nbit
    generic map(
        WIDTH  => 10,  -- WIDTH of input binary
        DIGITS => 3   -- Amount of output BCD digits
    )
    port map ( 
        BCD_IN  => B2BCD_IN,
        BCD_OUT => B2BCD_OUT
    );
 
    -- 7-segment display instantiation
    SEG_DISP : Top_7seg 
    port map( 
        IN_CLK  => TOP_CLK,
        IN_RST  => TOP_RST,
        
        -- IN_X is 4-bit value for that digit
        IN_0    => B2BCD_OUT(3 downto 0),
        IN_1    => B2BCD_OUT(7 downto 4),
        IN_2    => B2BCD_OUT(11 downto 8),
        IN_3    => (others => '0'),
        IN_4    => (others => '0'),
        IN_5    => (others => '0'),
        IN_6    => (others => '0'),
        IN_7    => (others => '0'),
        
        -- Digit enable vector
        IN_EN   => "00000111",
        
        -- Decimal point control
        -- 1 = Disabled, 0 = Enabled
        IN_DP   => '1',
        
        -- Outputs
        OUT_CAG => TOP_CAG,
        OUT_AN  => TOP_AN,
        OUT_DP  => TOP_DP         
    );
 
    -- Message preparation component takes from input to SHA-3 component
    MSG_GEN : Message_Prepare
    port map( 
        RAW_MSG => TOP_DATA_IN,
        SW      => TOP_SW,    
        MSG_OUT => SHA3_MSGIN
    );
 
    -- SHA-3 component
    SHA_3 : SHA3
    port map(
        CLK     => TOP_CLK,
        RST     => TOP_RST,
        GO      => TOP_GO,
        RDY     => TOP_RDY,
        DATA_IN => SHA3_MSGIN,
        DATA_OUT=> SHA3_Output,
        FINISH  => TOP_FINISH
    );
    
    -- Pass output to output port
    TOP_DATA_OUT <= SHA3_Output (1599 downto 1088);

end Behavioral;