----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2021 02:46:59 PM
-- Design Name: 
-- Module Name: SS_DECODER - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SS_DECODER is
    Port ( 
        DECODER_IN: in std_logic_vector(3 downto 0);
        DECODER_OUT: out std_logic_vector(6 downto 0)   
    );
end SS_DECODER;

architecture Behavioral of SS_DECODER is

signal SS_CAG_SIGNAL: std_logic_vector(6 downto 0) := (others => '0');

begin
process(DECODER_IN)
begin
    case DECODER_IN is
    when"0000" => SS_CAG_SIGNAL <= "0000001"; -- 0
    when"0001" => SS_CAG_SIGNAL <= "1001111"; -- 1
    when"0010" => SS_CAG_SIGNAL <= "0010010"; -- 2
    when"0011" => SS_CAG_SIGNAL <= "0000110"; -- 3
    when"0100" => SS_CAG_SIGNAL <= "1001100"; -- 4
    when"0101" => SS_CAG_SIGNAL <= "0100100"; -- 5
    when"0110" => SS_CAG_SIGNAL <= "0100000"; -- 6
    when"0111" => SS_CAG_SIGNAL <= "0001111"; -- 7
    when"1000" => SS_CAG_SIGNAL <= "0000000"; -- 8
    when"1001" => SS_CAG_SIGNAL <= "0000100"; -- 9
    when"1010" => SS_CAG_SIGNAL <= "0001000"; -- A
    when"1011" => SS_CAG_SIGNAL <= "1100000"; -- b (lowercase bc it looks like 8)
    when"1100" => SS_CAG_SIGNAL <= "0110001"; -- C
    when"1101" => SS_CAG_SIGNAL <= "1000010"; -- d (lowercase bc it looks like 0)
    when"1110" => SS_CAG_SIGNAL <= "0110000"; -- E
    when"1111" => SS_CAG_SIGNAL <= "0111000"; -- F
    when others => SS_CAG_SIGNAL <= "0000001"; -- Default
    end case;
end process;
DECODER_OUT <= SS_CAG_SIGNAL;
end Behavioral;

