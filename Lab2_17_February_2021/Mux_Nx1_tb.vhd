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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux_Nx1_tb is
    generic(
        IN_SIZE :integer := 6;
        WIDTH   :integer := 16
    );
end Mux_Nx1_tb;

architecture Behavioral of Mux_Nx1_tb is

component Mux_Nx1
    generic(
        IN_SIZE :integer := 6;
        WIDTH   :integer := 16
    );

    Port ( 
        N_A     : in std_logic_vector(2**IN_SIZE-1 downto 0);
        N_SEL   : in std_logic_vector(integer(ceil(log2(real(2**(IN_SIZE-4)))))-1 downto 0);
        N_X     : out std_logic_vector(WIDTH-1 downto 0)
    );
end component;

signal A_tb     : std_logic_vector(2**IN_SIZE-1 downto 0);
signal SEL_tb   : std_logic_vector(integer(ceil(log2(real(2**(IN_SIZE-4)))))-1 downto 0) := (others => '0');
signal X_tb     : std_logic_vector(WIDTH-1 downto 0);

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
        A_tb<= b"10101011110011010001001000110100";
        --A_tb <= b"1010101111001101000100100011010011101111010101101100101001111000";
        for i in 0 to 2**IN_SIZE-1 loop
            SEL_tb <= SEL_tb + 1;
            wait for 100*clock_period;
        end loop;
        
        wait;
    end process;
    
end Behavioral;