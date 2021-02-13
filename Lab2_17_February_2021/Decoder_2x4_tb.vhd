----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2021 08:42:21 PM
-- Design Name: 
-- Module Name: Decoder_2x4_tb - Behavioral
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

entity Decoder_2x4_tb is
end Decoder_2x4_tb;

architecture Behavioral of Decoder_2x4_tb is

component Decoder_2x4
    Port ( 
        A   : in std_logic_vector(1 downto 0);
        E   : in std_logic;
        X   : out std_logic_vector(3 downto 0)    
    );
end component;

signal A_TB : std_logic_vector(1 downto 0);
signal E_TB : std_logic;
signal X_TB : std_logic_vector(3 downto 0);

constant clock_period:time := 10ns;

begin

    DECODER_TB: Decoder_2x4
    port map(
        A => A_TB,
        E => E_TB,
        X => X_TB
    );
    
    TB_CASE: process begin
        A_TB <= "10";
        E_TB <= '1';
        wait;
    end process;

end Behavioral;
