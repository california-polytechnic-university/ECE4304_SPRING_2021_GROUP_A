----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2021 01:57:56 PM
-- Design Name: 
-- Module Name: CLK_DIVIDER - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLK_DIVIDER is
    Port ( 
            SYS_CLK: in std_logic;
            RST_SS: in std_logic;
            SLOW_CLK: out std_logic;
            AN_CYCLE: out std_logic_vector(7 downto 0);
            MUX_CYCLE: out std_logic_vector(1 downto 0)
    );
end CLK_DIVIDER;

architecture Behavioral of CLK_DIVIDER is
signal CLK_COUNT: unsigned(16 downto 0) := (others => '0');               -- counts up to 131071 
signal MUX_OUT_SIGNAL: std_logic_vector(1 downto 0):= (others => '0');            -- counts up to 4 (for each 7 segment display used)
signal AN_CYCLE_SIGNAL: std_logic_vector(7 downto 0) := "11111110";
signal SLOW_CLK_SIGNAL: std_logic := '0';
begin
process(SYS_CLK)
    begin
        if(rising_edge(SYS_CLK)) then
            -- if counter seven seg reset, then reset the AN cycle (AN_OUT_SIGNAL)
            if RST_SS = '1' then
                MUX_OUT_SIGNAL <= (others => '0');
                AN_CYCLE_SIGNAL <= "11111110";
            else
                if CLK_COUNT = 131071 then
                    CLK_COUNT <= (others => '0');    
                    SLOW_CLK_SIGNAL <= not SLOW_CLK_SIGNAL;
                    -- Increment the AN cycle
                    if AN_CYCLE_SIGNAL = "11111110" then
                        AN_CYCLE_SIGNAL <= "11101111";
                    elsif AN_CYCLE_SIGNAL = "11101111" then
                        AN_CYCLE_SIGNAL <= "10111111"; 
                    elsif AN_CYCLE_SIGNAL = "10111111" then
                        AN_CYCLE_SIGNAL <= "01111111";
                    elsif AN_CYCLE_SIGNAL <= "01111111" then
                        AN_CYCLE_SIGNAL <= "11111110";              
                    end if;                  
                    
                    MUX_OUT_SIGNAL <= MUX_OUT_SIGNAL + "1";
                else
                    -- If not 131071, increment clock_count 
                    CLK_COUNT <= CLK_COUNT + "1";
                end if;
            end if;
        end if;
        
    end process;
    MUX_CYCLE <= MUX_OUT_SIGNAL;
    AN_CYCLE <= AN_CYCLE_SIGNAL;
    SLOW_CLK <= SLOW_CLK_SIGNAL;
end Behavioral;