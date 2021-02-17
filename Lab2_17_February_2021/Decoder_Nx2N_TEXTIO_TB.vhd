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
use STD.textio.all; 
use IEEE.std_logic_textio.all; 
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder_Nx2N_tb is
    generic(
        IN_SIZE_TB : integer:=5
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

file file_vectors: text;
file file_results: text;

begin

    DECODER_TB: Decoder_Nx2N
    generic map(
        IN_SIZE => IN_SIZE_TB
    )
    port map(
        A => A_TB,
        X => X_TB
    );
    
    TEXTIO_GEN: process
        variable v_ILINE: line;
        variable v_OLINE: line;
        
        variable v_A: std_logic_vector(IN_SIZE_TB-1 downto 0);
        
    begin
    v_A := (others => '0');
    file_open(file_vectors,"C:\Users\Yuta\Desktop\ECE4304Projects\Lab_2\inputs.txt" , read_mode);     
    file_open(file_results,"C:\Users\Yuta\Desktop\ECE4304Projects\Lab_2\outputs.txt" , write_mode);

    while not endfile(file_vectors) loop
        readline(file_vectors, v_ILINE);
        read(v_ILINE, v_A);
        
        A_TB <= v_A;
        
        wait for 4*clock_period;
        
        write(v_OLINE, X_TB);
        writeline(file_results, v_OLINE);
        
        end loop;
                file_close(file_vectors);
                file_close(file_results);
            wait;
        end process;
end Behavioral;