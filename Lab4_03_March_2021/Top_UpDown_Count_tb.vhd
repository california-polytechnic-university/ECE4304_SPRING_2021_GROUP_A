----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2021 01:54:13 PM
-- Design Name: 
-- Module Name: Top_UpDown_Count_tb - Behavioral
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

entity Top_UpDown_Count_tb is
    generic(
        DIGITS_TB : integer:=4
    );
--  Port ( );
end Top_UpDown_Count_tb;

architecture Behavioral of Top_UpDown_Count_tb is

component Top_UpDown_Count is
    generic(
        DIGITS_TOP : integer:=4
    );
    Port ( 
        CLK_TOP : in std_logic;
        UD_TOP  : in std_logic;
        COUNT_RST       : in std_logic;
        DISP_RST        : in std_logic;  
        COUNT_SPD_TOP   : in std_logic_vector(2 downto 0);
        
        CACG    : out std_logic_vector(6 downto 0);
        DP      : out std_logic;
        AN      : out std_logic_vector(7 downto 0)
    );
end component Top_UpDown_Count;

signal CLK_TB   : std_logic := '0';
signal UD_TB    : std_logic := '0';
signal CACG_TB  : std_logic_vector(6 downto 0);
signal DP_TB    : std_logic;
signal AN_TB    : std_logic_vector(7 downto 0);

signal COUNT_RST_TB : std_logic;
signal DISP_RST_TB : std_logic;
signal COUNT_SPD_TOP_TB : std_logic_vector(2 downto 0);

constant clock_period : time:=10ns;
constant wait_period : time := 400ms;

begin

    UUT: Top_UpDown_Count
    generic map(
        DIGITS_TOP => DIGITS_TB
    )
    port map(
        CLK_TOP => CLK_TB,
        UD_TOP  => UD_TB,
        COUNT_RST   => COUNT_RST_TB,
        DISP_RST    => DISP_RST_TB,
        COUNT_SPD_TOP => COUNT_SPD_TOP_TB,
        CACG    => CACG_TB,
        DP      => DP_TB,
        AN      => AN_TB
    );
    
    CLK_GEN: process begin
        wait for clock_period / 2;
        CLK_TB <= not CLK_TB;
    end process CLK_GEN;
    
    TB_GEN: process begin
        UD_TB <= '1';
        DISP_RST_TB <= '0';
        COUNT_RST_TB <= '0';
        COUNT_SPD_TOP_TB <= "111";
        wait for wait_period;
        UD_TB <= '0';
        wait;
    end process TB_GEN;

end Behavioral;
