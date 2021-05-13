library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
        TOP_DATA_IN : in std_logic_vector(1599 downto 0); 
        TOP_DATA_OUT: out std_logic_vector(1599 downto 0);
        TOP_FINISH  : out std_logic
    );
end SHA3_System_Top;

architecture Behavioral of SHA3_System_Top is

component vga_initials_top is
 generic (strip_hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
          strip_vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
          strip_hbp     :positive:= 10;   -- Horizontal back porch = 144 (128 + 16)
          strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          strip_vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
         );
    Port ( clk  : in STD_LOGIC;
           rst  : in STD_LOGIC;
           
           SW   : in STD_LOGIC_VECTOR (1 downto 0);
           
           hsync: out STD_LOGIC;
           vsync: out STD_LOGIC; 
           
           hash_224 : in std_logic_vector (223 downto 0);
           hash_256 : in std_logic_vector (255 downto 0);
           hash_384 : in std_logic_vector (383 downto 0);
           hash_512 : in std_logic_vector (511 downto 0);
           
           red  : out STD_LOGIC_VECTOR (3 downto 0); 
           green: out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0)   
         );
end component vga_initials_top;

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

component Permutation_Loop is
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;
        GO  : in std_logic;
        RDY : in std_logic;
        DATA_IN : in std_logic_vector(1599 downto 0); 
        DATA_OUT : out std_logic_vector(1599 downto 0);
        FINISH : out std_logic
    );
end component Permutation_Loop;

    signal SHA3_Output : std_logic_vector(1599 downto 0);
    
    signal CLK_25, CLK_100  : std_logic;
    signal LOCK_PLL         : std_logic; 
    signal STEADY_CLK25, STEADY_CLK100 : std_logic;

    signal B2BCD_IN : std_logic_vector(9 downto 0);
    signal B2BCD_OUT : std_logic_vector(11 downto 0);

begin

    VGA : vga_initials_top
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
 
    SEG_OUTPUT : process (TOP_SW) begin
        case TOP_SW is
            when "00" => B2BCD_IN <= std_logic_vector(to_unsigned(224, B2BCD_IN'length));
            when "01" => B2BCD_IN <= std_logic_vector(to_unsigned(256, B2BCD_IN'length));
            when "10" => B2BCD_IN <= std_logic_vector(to_unsigned(384, B2BCD_IN'length));
            when "11" => B2BCD_IN <= std_logic_vector(to_unsigned(512, B2BCD_IN'length));
        end case;
    end process SEG_OUTPUT;
 
    B2BCD : B2BCD_Nbit
    generic map(
        WIDTH  => 10,  -- WIDTH of input binary
        DIGITS => 3   -- Amount of output BCD digits
    )
    port map ( 
        BCD_IN  => B2BCD_IN,
        BCD_OUT => B2BCD_OUT
    );
 
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
 
    SHA_3 : Permutation_Loop
    port map(
        CLK     => TOP_CLK,
        RST     => TOP_RST,
        GO      => TOP_GO,
        RDY     => TOP_RDY,
        DATA_IN => TOP_DATA_IN,
        DATA_OUT=> SHA3_Output,
        FINISH  => TOP_FINISH
    );
    
    TOP_DATA_OUT <= SHA3_Output;

end Behavioral;