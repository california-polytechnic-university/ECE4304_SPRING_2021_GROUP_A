library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity Top_7seg is
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
end Top_7seg;

architecture Behavioral of Top_7seg is

component Counter is
    generic(
        COUNT_VAL : integer := 131071   -- Equivalent to (16 downto 0) <= (others => '1')
    );
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;    
        VAL : out std_logic_vector(integer(ceil(log2(real(COUNT_VAL))))-1 downto 0);
        TICK: out std_logic
    );
end component Counter;

component Mux_Nx1 is
    generic(
        WIDTH : integer := 4;
        INPUTS: integer := 4
    );
    Port (
        MUX_IN  : in std_logic_vector(WIDTH*INPUTS-1 downto 0);
        SEL     : in std_logic_vector(integer(ceil(log2(real(INPUTS))))-1 downto 0);
        MUX_OUT : out std_logic_vector(WIDTH-1 downto 0)
    );
end component Mux_Nx1;

component Decoder_7seg is
    Port ( 
        A : in std_logic_vector(3 downto 0);
        X : out std_logic_vector(6 downto 0)
    );
end component Decoder_7seg;

    constant TOTAL_DISPLAYS : integer := 8;
    constant INPUT_WIDTH    : integer := 4;

    signal IN_VECTOR    : std_logic_vector(TOTAL_DISPLAYS*INPUT_WIDTH-1 downto 0);

    signal TICK     : std_logic;
    signal MUX_SEL  : std_logic_vector(integer(ceil(log2(real(TOTAL_DISPLAYS))))-1 downto 0) := (others => '0');
    signal MUX_VAL  : std_logic_vector(INPUT_WIDTH-1 downto 0);

begin

    IN_VECTOR(3 downto 0)   <= IN_0;
    IN_VECTOR(7 downto 4)   <= IN_1;
    IN_VECTOR(11 downto 8)  <= IN_2;
    IN_VECTOR(15 downto 12) <= IN_3;
    IN_VECTOR(19 downto 16) <= IN_4;
    IN_VECTOR(23 downto 20) <= IN_5;
    IN_VECTOR(27 downto 24) <= IN_6;
    IN_VECTOR(31 downto 28) <= IN_7;
    
---- 7-Segment Slow Clock / Mux Selector ----

    CLK_TICK : Counter
    generic map(
        COUNT_VAL => 131071   -- Equivalent to (16 downto 0) <= (others => '1')
    )
    port map( 
        CLK     => IN_CLK,
        RST     => IN_RST,
        TICK    => TICK
    );

    TICK_MUX : Counter
    generic map(
        COUNT_VAL => 7   -- Equivalent to (16 downto 0) <= (others => '1')
    )
    port map( 
        CLK     => TICK,
        RST     => IN_RST,
        VAL     => MUX_SEL
    );
---- End 7-Segment Slow Clock / Mux Muxer ----


---- Display Value Mux ----

    IN_SEL : Mux_Nx1
    generic map(
        WIDTH   => INPUT_WIDTH,
        INPUTS  => TOTAL_DISPLAYS
    )
    port map(
        MUX_IN  => IN_VECTOR,
        SEL     => MUX_SEL,
        MUX_OUT => MUX_VAL
    );
    
    DISP_VAL : Decoder_7seg
    port map ( 
        A   => MUX_VAL,
        X   => OUT_CAG
    );
    
    DISP_ENABLE : process (MUX_SEL, IN_EN) begin
        
        OUT_AN <= (others => '1');
        if( IN_EN(to_integer(unsigned(MUX_SEL))) = '1' ) then
            OUT_AN(to_integer(unsigned(MUX_SEL))) <= '0';        
        end if;
    end process DISP_ENABLE;

    OUT_DP <= IN_DP;

---- End Display Value Mux ----

    

end Behavioral;
