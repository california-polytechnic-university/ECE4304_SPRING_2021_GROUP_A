----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2021 04:51:09 PM
-- Design Name: 
-- Module Name: Division_TB - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity Division_TB is
    generic(
        WIDTH_TB : integer:=4
    );
end Division_TB;

architecture Behavioral of Division_TB is

component DIV is
    generic(
        WIDTH : integer := 4
    );
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;
        IN_A : in std_logic_vector(WIDTH-1 downto 0);
        IN_B : in std_logic_vector(WIDTH-1 downto 0);
        Z : out std_logic_vector(WIDTH-1 downto 0);
        RDY: out std_logic
    );
end component DIV;

signal CLK_TB : std_logic := '0';
signal RST_TB : std_logic := '0';
signal IN_A_TB : std_logic_vector(WIDTH_TB-1 downto 0);
signal IN_B_TB : std_logic_vector(WIDTH_TB-1 downto 0);
signal Z_TB : std_logic_vector(WIDTH_TB-1 downto 0);
signal RDY_TB : std_logic;

constant clock_period : time:=10ns;

begin

UUT: Division 
generic map(
    WIDTH => WIDTH_TB
)
port map(
    CLK => CLK_TB,
    RST => RST_TB,
    IN_A => IN_A_TB,
    IN_B => IN_B_TB,
    Z => Z_TB,
    RDY => RDY_TB
);

CLK_GEN : process begin

    wait for clock_period / 2;
    CLK_TB <= not CLK_TB;

end process CLK_GEN;

UUT_TB : process begin
    RST_TB <= '1';
    wait for clock_period;
    RST_TB <= '0';

    for i in 0 to 2**WIDTH_TB-1 loop
        for j in 0 to 2**WIDTH_TB-1 loop
            IN_A_TB <= std_logic_vector(to_unsigned(i, IN_A_TB'length));
            IN_B_TB <= std_logic_vector(to_unsigned(j, IN_B_TB'length));
            wait for clock_period * 10;
        end loop;
    end loop;   
    wait;

end process UUT_TB;

end Behavioral;
