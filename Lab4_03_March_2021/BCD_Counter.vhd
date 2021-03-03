----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2021 11:18:14 PM
-- Design Name: 
-- Module Name: BCD_Counter - Behavioral
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

entity BCD_Counter is
    Port ( 
        CLK     : in std_logic;
        RST     : in std_logic;
        EN      : in std_logic;
        UD      : in std_logic;
        BCD_VAL : out std_logic_vector (3 downto 0);    
        TICK    : out std_logic
    );
end BCD_Counter;

architecture Behavioral of BCD_Counter is

signal INTERNAL_COUNTER : std_logic_vector (3 downto 0) := (others => '0');
signal INTERNAL_TICK : std_logic := '0';

begin

    COUNTER: process (CLK, RST) begin
        if( RST = '1') then
                INTERNAL_COUNTER <= "0000";
        elsif( rising_edge(CLK) ) then
            if( EN = '1' ) then
                if( UD = '1' ) then
                    if( INTERNAL_COUNTER = "1001" ) then
                        INTERNAL_COUNTER <= "0000";
                    else
                        INTERNAL_COUNTER <= std_logic_vector(unsigned(INTERNAL_COUNTER) + 1);
                    end if;
                else
                    if( INTERNAL_COUNTER = "0000" ) then
                        INTERNAL_COUNTER <= "1001";
                    else
                        INTERNAL_COUNTER <= std_logic_vector(unsigned(INTERNAL_COUNTER) - 1);
                    end if;
                end if;
            end if;
        end if;
    end process COUNTER;
    
    process (INTERNAL_COUNTER, EN, UD) begin
        if( INTERNAL_COUNTER = "1001" and EN = '1' and UD = '1' ) then
            TICK <= '1';
        elsif( INTERNAL_COUNTER = "0000" and EN = '1' and UD = '0' ) then
            TICK <= '1';
        else
            TICK <= '0';
        end if;
    end process;
   
    BCD_VAL <= INTERNAL_COUNTER;


end Behavioral;
