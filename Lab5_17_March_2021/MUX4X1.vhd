----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2021 01:55:53 PM
-- Design Name: 
-- Module Name: MUX4X1 - Behavioral
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

entity MUX4X1 is
    Port (         
        MUX_A: in std_logic_vector(3 downto 0);
        MUX_B: in std_logic_vector(3 downto 0);
        MUX_CH: in std_logic_vector(3 downto 0);
        MUX_CL: in std_logic_vector(3 downto 0);
        MUX_S: in std_logic_vector(1 downto 0);
        MUX_OUT: out std_logic_vector(3 downto 0)       
    );
end MUX4X1;

architecture Behavioral of MUX4X1 is
signal MUX_OUT_SIGNAL: std_logic_vector(3 downto 0) := (others => '0');
begin
process(MUX_S, MUX_B, MUX_A, MUX_CL, MUX_CH)
begin
    case MUX_S is
        when "00" => MUX_OUT_SIGNAL <= MUX_B;
        when "01" => MUX_OUT_SIGNAL <= MUX_A;
        when "10" => MUX_OUT_SIGNAL <= MUX_CL;
        when "11" => MUX_OUT_SIGNAL <= MUX_CH; 
        when others => MUX_OUT_SIGNAL <= "1111";
    end case;
end process;
MUX_OUT <= MUX_OUT_SIGNAL;
end Behavioral;

