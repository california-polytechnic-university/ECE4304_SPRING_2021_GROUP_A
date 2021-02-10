----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2021 02:06:28 PM
-- Design Name: 
-- Module Name: Mux_2x1_tb - Behavioral
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

entity Mux_2x1_tb is
--  Port ( );
end Mux_2x1_tb;

architecture Behavioral of Mux_2x1_tb is

component Mux_2x1
    Port(
        A   :   in std_logic;
        B   :   in std_logic;
        SEL :   in std_logic;
        X   :   out std_logic   
    );
end component;

signal A_tb     : std_logic;
signal B_tb     : std_logic;
signal SEL_tb   : std_logic;
signal X_tb     : std_logic;

constant clock_period:time:= 10ns;

begin
    
    MUX_TB: Mux_2x1 port map(
        A   => A_tb,
        B   => B_tb,
        SEL => SEL_tb,
        X   => X_tb
    );         

    TSB_CASE: process
    begin
        A_tb    <= '0';
        B_tb    <= '0';
        SEL_tb  <= '0';
        wait for clock_period;
        A_tb    <= '1';
        wait for clock_period;
        A_tb    <= '0';
        B_tb    <= '0';
        SEL_tb  <= '1';
        wait for clock_period;
        B_tb    <= '1';
        SEL_tb  <= '1';
        wait;
    end process;
end Behavioral;
