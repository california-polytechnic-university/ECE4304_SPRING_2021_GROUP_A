----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2021 08:22:59 PM
-- Design Name: 
-- Module Name: Top_B2BCD_Display - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.all;
--use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_B2BCD_Display is 
    Port ( 
        -- Input Ports --
        CLK : in std_logic; 
        IN1 : in std_logic_vector( 3 downto 0 );
        IN2 : in std_logic_vector( 3 downto 0 );
        
        -- Output Ports --
        CACG: out std_logic_vector( 6 downto 0 );
        DP  : out std_logic;
        AN  : out std_logic_vector( 7 downto 0 )
    );
end Top_B2BCD_Display;

architecture Behavioral of Top_B2BCD_Display is

component B2BCD
    Port ( 
        A: in std_logic_vector(3 downto 0);
        X: out std_logic_vector(3 downto 0)
    );
end component B2BCD;

component Decoder_7seg
    Port ( 
        A : in std_logic_vector(3 downto 0);
        X : out std_logic_vector(6 downto 0)
    );
end component Decoder_7seg;

-- Counter signal
signal count    : std_logic_vector(19 downto 0) := (others => '0');
-- B2BCD Inst Outputs
signal B2BCD_X1 : std_logic_vector(3 downto 0);
signal B2BCD_X2 : std_logic_vector(3 downto 0);
-- B2BCD value that goes through 7-seg decoder
signal DISPLAY_IN : std_logic_vector(3 downto 0);

begin

    -- B2BCD Instantiations --
    B2BCD_INST1: B2BCD
    port map (
        A => IN1,
        X => B2BCD_X1
    );
    
    B2BCD_INST2: B2BCD
    port map (
        A => IN2,
        X => B2BCD_X2
    );
    
    DISPLAY_INST: Decoder_7seg
    port map(
        A => DISPLAY_IN,
        X => CACG
    );

    -- Counter 
    DISP_COUNTER: process (clk) 
    begin 
        if(rising_edge(clk)) then
            count <= std_logic_vector(unsigned(count) + 1);
        end if; 
    end process DISP_COUNTER;
    
    -- Multiplexer and Decoder for sorting values to 0 and 4th Display
    DISP_VALUE: process (count)
    begin
        case( count(19 downto 17) ) is
            when "000" => 
                DISPLAY_IN <= B2BCD_X1;
                AN  <= "11111110";
            when "100" => 
                DISPLAY_IN <= B2BCD_X2;
                AN  <= "11101111";
            when others => 
                DISPLAY_IN <= "0000";
                AN  <= "11111111";
        end case;    
    end process DISP_VALUE;

    -- Keep decimal turned off
    DP <= '1';

end Behavioral;
