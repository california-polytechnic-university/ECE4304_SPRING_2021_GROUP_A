----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2021 12:52:11 AM
-- Design Name: 
-- Module Name: BCD_Counter_tb - Behavioral
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

entity BCD_Counter_tb is
--  Port ( );
end BCD_Counter_tb;

architecture Behavioral of BCD_Counter_tb is

component BCD_Counter
    Port ( 
        CLK     : in std_logic;
        EN      : in std_logic;
        RST     : in std_logic;
        UD      : in std_logic;
        BCD_VAL : out std_logic_vector (3 downto 0);    
        TICK    : out std_logic
    );
end component BCD_Counter;

signal CLK_TB       : std_logic := '0';
signal EN_TB        : std_logic := '0';
signal RST_TB       : std_logic := '0';
signal UD_TB        : std_logic := '0';
signal BCD_VAL_TB   : std_logic_vector (3 downto 0);
signal TICK_TB      : std_logic;

constant clock_period : time:= 10ns;

begin

    UUT: BCD_Counter port map
    (
        CLK     => CLK_TB,
        EN      => EN_TB,
        RST     => RST_TB,
        UD      => UD_TB,
        BCD_VAL => BCD_VAL_TB,
        TICK    => TICK_TB
    );
    
    CLK_GEN: process begin
        wait for clock_period;
        CLK_TB <= not CLK_TB;
    end process CLK_GEN;
    
    TB_GEN: process begin
        EN_TB <= '1';
        RST_TB <= '0';
        UD_TB <= '1';
        for i in 0 to 30 loop
            wait for clock_period;
        end loop;
        UD_TB <= '0';
        for i in 0 to 30 loop
            wait for clock_period;
        end loop;
        wait;
    end process TB_GEN;
    
end Behavioral;
