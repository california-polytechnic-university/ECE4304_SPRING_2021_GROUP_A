----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 12:32:07 PM
-- Design Name: 
-- Module Name: ALU_Operations_tb - Behavioral
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

entity ALU_Operations_tb is
    generic(
        WIDTH_TB : integer := 4
    );
end ALU_Operations_tb;

architecture Behavioral of ALU_Operations_tb is

component ALU is
    generic(
        WIDTH_ALU : integer:=4
    );
    Port ( 
        CLK_ALU : in std_logic;
        RST_ALU : in std_logic;
        A_ALU   : in std_logic_vector(WIDTH_ALU-1 downto 0);
        B_ALU   : in std_logic_vector(WIDTH_ALU-1 downto 0);
        SEL_ALU : in std_logic_vector(1 downto 0);
        
        RES_ALU : out std_logic_vector(WIDTH_ALU*2-1 downto 0);
        NEG_ALU : out std_logic;
        ERR_ALU : out std_logic
    );
end component ALU;

signal CLK_TB   : std_logic := '0';
signal RST_TB   : std_logic := '0';
signal IN_A_TB  : std_logic_vector(WIDTH_TB-1 downto 0);
signal IN_B_TB  : std_logic_vector(WIDTH_TB-1 downto 0);
signal SEL_TB   : std_logic_vector(1 downto 0);

signal RES_TB : std_logic_vector(WIDTH_TB*2-1 downto 0);

signal NEG_TB : std_logic;
signal ERR_TB : std_logic;

constant clock_period : time:=10ns;

begin

UUT: ALU 
generic map(
    WIDTH_ALU => WIDTH_TB
)
port map(
    CLK_ALU => CLK_TB,
    RST_ALU => RST_TB,
    A_ALU   => IN_A_TB,
    B_ALU   => IN_B_TB,
    SEL_ALU => SEL_TB,
    
    RES_ALU => RES_TB,
    NEG_ALU => NEG_TB,
    ERR_ALU => ERR_TB
);

CLK_GEN : process begin

    wait for clock_period / 2;
    CLK_TB <= not CLK_TB;

end process CLK_GEN;

UUT_TB : process begin
    RST_TB <= '1';
    wait for clock_period;
    RST_TB <= '0';

    for l in 0 to 3 loop
        SEL_TB <= std_logic_vector(to_unsigned(l, SEL_TB'length));
        for i in 0 to 2**WIDTH_TB-1 loop
            for j in 0 to 2**WIDTH_TB-1 loop
                IN_A_TB <= std_logic_vector(to_unsigned(i, IN_A_TB'length));
                IN_B_TB <= std_logic_vector(to_unsigned(j, IN_B_TB'length));
                wait for clock_period * 10;
            end loop;
        end loop;
    end loop;   
    wait;

end process UUT_TB;

end Behavioral;
