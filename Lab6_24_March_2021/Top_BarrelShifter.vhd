library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";


entity Top_BarrelShifter is
    generic(
        WIDTH_TOP : integer := 8
    );
    Port ( 
        -- Inputs
        TOP_CLK : in std_logic;
        TOP_RST : in std_logic;
        TOP_VAL     : in std_logic_vector(WIDTH_TOP-1 downto 0);
        TOP_SHIFT   : in std_logic_vector(integer(ceil(log2(real(WIDTH_TOP))))-1 downto 0);
        -- Barrel Shifter outputs
        TOP_BARREL_LED  : out std_logic_vector(WIDTH_TOP-1 downto 0);
        -- 7-seg outputs
        TOP_CAG : out std_logic_vector(6 downto 0);
        TOP_AN  : out std_logic_vector(7 downto 0);
        TOP_DP  : out std_logic
    );
end Top_BarrelShifter;

architecture Behavioral of Top_BarrelShifter is

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
        
        -- IN_X is packed
        -- IN(3 downto 0) = Input Value
        -- IN(4): 1 = Enabled, 0 = Disabled
        IN_0 : in std_logic_vector(4 downto 0);
        IN_1 : in std_logic_vector(4 downto 0);
        IN_2 : in std_logic_vector(4 downto 0);
        IN_3 : in std_logic_vector(4 downto 0);
        IN_4 : in std_logic_vector(4 downto 0);
        IN_5 : in std_logic_vector(4 downto 0);
        IN_6 : in std_logic_vector(4 downto 0);
        IN_7 : in std_logic_vector(4 downto 0);
        
        -- Decimal point control
        -- 1 = Disabled, 0 = Enabled
        IN_DP : in std_logic;   
        
        -- Outputs
        OUT_CAG : out std_logic_vector(6 downto 0);
        OUT_AN  : out std_logic_vector(7 downto 0);
        OUT_DP  : out std_logic             
    );
end component Top_7seg;

    signal TOP_BSHIFT : std_logic_vector(WIDTH_TOP-1 downto 0);
    
    signal TOP_VAL_BCD, TOP_BSHIFT_BCD  : std_logic_vector(WIDTH_TOP-1 downto 0);
    signal TOP_SHIFT_BCD                : std_logic_vector(3 downto 0);
    signal VAL_BCD1, VAL_BCD2           : std_logic_vector(4 downto 0);
    signal SHIFT_BCD1                   : std_logic_vector(4 downto 0);
    signal BSHIFT_BCD1, BSHIFT_BCD2     : std_logic_vector(4 downto 0);

begin

    BSHIFT : BarrelShifter
    generic map(
        WIDTH => WIDTH_TOP
    )
    port map(
        VAL_IN  => TOP_VAL,
        SHIFT_IN=> TOP_SHIFT,
        VAL_OUT => TOP_BSHIFT
    );

    SEL_B2BCD : B2BCD_Nbit
    generic map(
        WIDTH   => integer(ceil(log2(real(WIDTH_TOP)))),
        DIGITS  => 1
    )
    port map(
        BCD_IN  => TOP_SHIFT,
        BCD_OUT => TOP_SHIFT_BCD
    );
    
    -- Pack inputs into 7-segment display with '1' to mark as enable
    VAL_BCD1 <= '1' & TOP_VAL(3 downto 0);
    VAL_BCD2 <= '1' & TOP_VAL(7 downto 4);
    
    SHIFT_BCD1 <= '1' & TOP_SHIFT_BCD;
    
    BSHIFT_BCD1 <= '1' & TOP_BSHIFT(3 downto 0);
    BSHIFT_BCD2 <= '1' & TOP_BSHIFT(7 downto 4);

    DISP : Top_7seg
    port map(
        IN_CLK => TOP_CLK,
        IN_RST => TOP_RST,
        IN_0 => VAL_BCD1,
        IN_1 => VAL_BCD2,
        IN_2 => "00000",
        IN_3 => "00000",
        IN_4 => BSHIFT_BCD1,
        IN_5 => BSHIFT_BCD2,
        IN_6 => "00000",
        IN_7 => SHIFT_BCD1,
        IN_DP => '1',
        OUT_CAG => TOP_CAG,
        OUT_AN => TOP_AN,
        OUT_DP => TOP_DP
    );  

    TOP_BARREL_LED <= TOP_BSHIFT;
end Behavioral;
