----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2021 05:50:04 PM
-- Design Name: 
-- Module Name: B2BCD_tb - Behavioral
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

entity B2BCD_tb is
--  Port ( );
end B2BCD_tb;

architecture Behavioral of B2BCD_tb is

component B2BCD
    Port ( 
        A: in std_logic_vector(3 downto 0);
        X: out std_logic_vector(3 downto 0)
    );
end component B2BCD;

signal A_TB : std_logic_vector(3 downto 0);
signal X_TB : std_logic_vector(3 downto 0);

constant clock_period: time:= 10ns;

begin

    B2BCD_INST: B2BCD
    port map(
        A => A_TB,
        X => X_TB
    );

    TEST_TB: process begin
    
        for i in 0 to 31 loop
            A_TB <= std_logic_vector(to_unsigned(i, A_TB'length));
            wait for clock_period;
        end loop;
        
        wait;
    
    end process TEST_TB;
    

end Behavioral;
