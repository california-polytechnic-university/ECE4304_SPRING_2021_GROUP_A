----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2021 03:01:27 AM
-- Design Name: 
-- Module Name: Top_UpDown_Count - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_UpDown_Count is
    generic(
        DIGITS_TOP : integer:=8;
        COUNT_DELAY: integer:=25000000  -- 10ns * COUNT_DELAY = Desired Period, Default 250ms
    );
    Port ( 
        --  Inputs  --
        CLK_TOP         : in std_logic;
        UD_TOP          : in std_logic;
        COUNT_RST       : in std_logic;
        DISP_RST        : in std_logic;  
        COUNT_SPD_TOP   : in std_logic_vector(2 downto 0);
        -- Outputs  --
        CACG        : out std_logic_vector(6 downto 0);
        DP          : out std_logic;
        AN          : out std_logic_vector(7 downto 0)
    );
end Top_UpDown_Count;

architecture Behavioral of Top_UpDown_Count is

-- Cascaded BCD counter component --
component Stacked_Counter is
    generic(
        DIGITS : integer:=4
    );
    
    Port ( 
        CLK     : in std_logic;
        RST     : in std_logic;
        UD      : in std_logic;
        VAL     : out std_logic_vector(DIGITS*4-1 downto 0)
    );
end component Stacked_Counter;

-- 7-segment decoder component --
component Decoder_7seg is
    Port ( 
        A : in std_logic_vector(3 downto 0);
        X : out std_logic_vector(6 downto 0)
    );
end component;

-- Slow clock component
component Slow_Clock is
    generic(
        COUNT : integer:= 10000000  -- 10ns * COUNT = Desired Period, Default 100ms
    );
    Port ( 
        CLK_IN      : in std_logic;    
        COUNT_SPD   : in std_logic_vector(2 downto 0);    
        CLK_OUT     : out std_logic
    );
end component;

-- BCD output vector from cascaded counter
signal COUNTER_OUT : std_logic_vector(DIGITS_TOP*4-1 downto 0);

-- BCD slow clock for cascaded counter
signal SLOW_COUNT  : std_logic_vector(24 downto 0) := (others => '0');
signal BCD_CLOCK   : std_logic := '0';

-- 7-seg display AN clock
signal REFRESH_COUNT: std_logic_vector(19 downto 0) := (others => '0');
signal REFRESH_SEL  : std_logic_vector(2 downto 0);

-- Muxed output taken from cascaded BCD Counter
signal DISPLAY_IN   : std_logic_vector(3 downto 0);

begin

    -- Cascaded BCD Counter inst
    COUNT_INST: Stacked_Counter
    generic map(
        DIGITS => DIGITS_TOP
    )
    port map(
        CLK => BCD_CLOCK,
        RST => COUNT_RST,
        UD  => UD_TOP,
        VAL => COUNTER_OUT
    );

    -- 7 Seg Decoder inst
    SEG_INST: Decoder_7seg 
    port map(
        A => DISPLAY_IN,
        X => CACG
    );
    
    -- Slow-Clock for BCD Clock inst
    BCD_CLOCK_INST: Slow_Clock
    generic map(
        COUNT => COUNT_DELAY 
    )
    port map(
        CLK_IN      => CLK_TOP,
        COUNT_SPD   => COUNT_SPD_TOP,
        CLK_OUT     => BCD_CLOCK 
    );

    -- 7-seg display AN counter
    DISP_COUNTER: process(CLK_TOP, DISP_RST) begin
        if(DISP_RST = '1') then
            REFRESH_COUNT <= (others => '0');
        elsif(rising_edge(CLK_TOP)) then 
            REFRESH_COUNT <= std_logic_vector(unsigned(REFRESH_COUNT) + 1);
        end if;
    end process DISP_COUNTER;
    
    -- Output to AN enable based on AN counter and if digit exists
    -- Mux to output correct BCD Counter to 7-seg decoder
    DISP_VALUE: process(REFRESH_COUNT) begin
        REFRESH_SEL <= REFRESH_COUNT(19 downto 17);
        AN <= (others => '1');
        
        -- Check if digit exists
        if(unsigned(REFRESH_SEL) < DIGITS_TOP) then
            DISPLAY_IN <= COUNTER_OUT(4*(to_integer(unsigned(REFRESH_SEL))+1)-1 downto 4*(to_integer(unsigned(REFRESH_SEL)))); -- Mux output
            AN(to_integer(unsigned(REFRESH_SEL))) <= '0';   -- Display enable
        else
            DISPLAY_IN <= x"F";
        end if;
    end process DISP_VALUE;
    
    DP <= '1';

end Behavioral;
