----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2021 07:37:38 PM
-- Design Name: 
-- Module Name: BTN_Debouncer_tb - Behavioral
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

entity BTN_Debouncer_tb is
--  Port ( );
end BTN_Debouncer_tb;

architecture Behavioral of BTN_Debouncer_tb is

component BTN_Debouncer is
    Port ( 
        CLK     : in std_logic;
        RST     : in std_logic;
        BTN_IN  : in std_logic;
        BTN_OUT : out std_logic
    );
end component BTN_Debouncer;

signal TB_CLK, TB_RST, TB_BTN_IN, TB_BTN_OUT : std_logic := '0';

signal PULL_B : std_logic := '0';

constant clock_period : time := 10ns;

begin

    UUT : BTN_Debouncer
    port map( 
        CLK     => TB_CLK,
        RST     => TB_RST,
        BTN_IN  => TB_BTN_IN,
        BTN_OUT => TB_BTN_OUT
    );

    BTN_RISE_B : process ( TB_CLK, TB_RST, TB_BTN_OUT ) 
        variable isOn : boolean;
    begin
        if( TB_RST = '1' ) then
            isOn := false; 
        elsif( rising_edge(TB_CLK) ) then
            PULL_B <= '0';
            if( not isOn ) then
                if( TB_BTN_OUT = '1' ) then
                    PULL_B <= '1';
                    isOn := true;
                end if;
            else
                if( TB_BTN_OUT = '0' ) then
                    isOn := false;
                end if;
            end if;
        end if;
    end process BTN_RISE_B;

    CLK_GEN : process begin
        wait for clock_period;
        TB_CLK <= not TB_CLK;
    end process;
    
    UUT_TB : process begin
        TB_RST <= '1';
        wait for clock_period * 3;
        TB_RST <= '0';
        TB_BTN_IN <= '1';
        wait for clock_period * 30000000; --Button press for 300ms
        TB_BTN_IN <= '0';
        wait;
    end process UUT_TB;

end Behavioral;
