----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2021 04:50:29 PM
-- Design Name: 
-- Module Name: Mux_Nx1_tb - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux_Nx1_tb is
    generic(
        IN_SIZE :integer := 16;
        SEL_SIZE:integer := 4
    );
end Mux_Nx1_tb;

architecture Behavioral of Mux_Nx1_tb is

component Mux_Nx1
    generic(
        IN_SIZE :integer := 16;
        SEL_SIZE:integer := 4
    );

    Port ( 
        N_A:    in std_logic_vector(IN_SIZE-1 downto 0);
        N_SEL:  in std_logic_vector(SEL_SIZE-1 downto 0);
        
        N_X:    out std_logic
    );
end component;

signal A_tb     : std_logic_vector(IN_SIZE-1 downto 0);
signal SEL_tb   : std_logic_vector(SEL_SIZE-1 downto 0) := (others => '0');
signal X_tb     : std_logic;

constant clock_period:time:= 10ns;

begin
    
    MUX_TB: Mux_Nx1 
    port map(
        N_A   => A_tb,
        N_SEL => SEL_tb,
        N_X   => X_tb
    );         

    TSB_CASE: process
    begin
        A_tb(IN_SIZE-1 downto 0) <= b"1001000011000110";
        for i in 0 to IN_SIZE-1 loop
            wait for clock_period;
            SEL_tb <= SEL_tb + 1;
        end loop;
        
        wait;
    end process;
    
end Behavioral;