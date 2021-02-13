----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2021 08:31:45 PM
-- Design Name: 
-- Module Name: Decoder_Nx2N_tb - Behavioral
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

entity Decoder_Nx2N_tb is
    generic(
        IN_SIZE_TB : integer:=7
    );
end Decoder_Nx2N_tb;

architecture Behavioral of Decoder_Nx2N_tb is

component Decoder_Nx2N
    generic(
        IN_SIZE : integer:= 5
    );
    Port ( 
        A   : in std_logic_vector(IN_SIZE-1 downto 0);
        X   : out std_logic_vector(2**IN_SIZE-1 downto 0)
    );
end component;

signal A_TB : std_logic_vector(IN_SIZE_TB-1 downto 0) := (others => '0');
signal X_TB : std_logic_vector(2**IN_SIZE_TB-1 downto 0) := (others => '0');

constant clock_period:time:= 10ns;

begin

    DECODER_TB: Decoder_Nx2N
    generic map(
        IN_SIZE => IN_SIZE_TB
    )
    port map(
        A => A_TB,
        X => X_TB
    );
    
    TB_CASE: process begin
        
        for i in 1 to 2**IN_SIZE_TB-1 loop
            wait for clock_period;
            A_TB <= std_logic_vector(unsigned(A_TB) + 1);
        end loop;
        wait;
    end process;

end Behavioral;
