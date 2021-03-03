----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2021 09:06:08 PM
-- Design Name: 
-- Module Name: Slow_Clock - Behavioral
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
use IEEE.math_real."log2"; 
use IEEE.math_real."ceil";

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Slow_Clock is
    generic(
        COUNT : integer:= 10000000  -- 10ns * COUNT = Desired Period, Default 100ms
    );
    Port ( 
        CLK_IN      : in std_logic;
        COUNT_SPD   : in std_logic_vector(2 downto 0);        
        CLK_OUT     : out std_logic
    );
end Slow_Clock;

architecture Behavioral of Slow_Clock is

signal SLOW_COUNT : std_logic_vector(integer(ceil(log2(real(COUNT))))-1 downto 0) := (others => '0');
signal CLK_TEMP : std_logic := '0';

begin

    CLOCK_GEN: process(CLK_IN) begin
        if(rising_edge(CLK_IN)) then
            if(unsigned(SLOW_COUNT) >= (COUNT / 2) - 1) then  -- Create duty cycle of 50%, toggle at half the period
                SLOW_COUNT <= (others => '0');
                CLK_TEMP <= not CLK_TEMP;
            else
                SLOW_COUNT <= std_logic_vector(unsigned(SLOW_COUNT) + 1 + unsigned(COUNT_SPD)); -- Make faster depending on value of COUNT_SPD
                CLK_TEMP <= CLK_TEMP;
            end if;
        end if;
        
        -- Output Clock
        CLK_OUT <= CLK_TEMP;
    end process CLOCK_GEN;

end Behavioral;
