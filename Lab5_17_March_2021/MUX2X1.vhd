----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2021 02:00:30 PM
-- Design Name: 
-- Module Name: MUX2X1 - Behavioral
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

entity MUX2X1 is
    Port ( 
        MUX_HEX: in std_logic_vector(3 downto 0);
        MUX_BCD: in std_logic_vector(3 downto 0);
        MUX_S: in std_logic;
        MUX_OUT: out std_logic_vector(3 downto 0)
    );
end MUX2X1;

architecture Behavioral of MUX2X1 is
signal OUT_SIGNAL: std_logic_vector(3 downto 0) := (others => '0');

begin
process(MUX_S, MUX_HEX, MUX_BCD)
begin
    if MUX_S = '0' then
        OUT_SIGNAL <= MUX_HEX;
    elsif MUX_S = '1' then
        OUT_SIGNAL <= MUX_BCD;
    end if;
end process;

MUX_OUT <= OUT_SIGNAL;

end Behavioral;