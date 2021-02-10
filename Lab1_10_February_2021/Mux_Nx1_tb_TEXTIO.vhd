----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2021 10:14:07 PM
-- Design Name: 
-- Module Name: Mux_Nx1_tb_TEXTIO - Behavioral
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
use IEEE.math_real."ceil";
use IEEE.math_real."log2";
use STD.textio.all; 
use IEEE.std_logic_textio.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux_Nx1_tb_TEXTIO is
    generic(
        IN_SIZE_TB :integer := 13 
    );
end Mux_Nx1_tb_TEXTIO;

architecture Behavioral of Mux_Nx1_tb_TEXTIO is
constant SEL_SIZE_TB: integer := integer(ceil(log2(real(IN_SIZE))));
component Mux_Nx1
    generic(
        IN_SIZE :integer := 13
    );

    Port ( 
        N_A:    in std_logic_vector(IN_SIZE-1 downto 0);
        N_SEL:  in std_logic_vector(ceil(log2(real(IN_SIZE))))-1 downto 0);
        
        N_X:    out std_logic
    );
end component;
signal A_tb     : std_logic_vector(IN_SIZE_TB-1 downto 0);
signal SEL_tb   : std_logic_vector(SEL_SIZE_TB-1 downto 0) := (others => '0');
signal X_tb     : std_logic;

constant clock_period:time:= 10ns;

file file_vectors: text;
file file_results: text;

begin
    MUX_TB: Mux_Nx1 
    generic map(
        IN_SIZE => IN_SIZE_TB
    )
    port map(
        N_A   => A_tb,
        N_SEL => SEL_tb,
        N_X   => X_tb
    );
    TEXTIO_GEN: process
        variable v_ILINE: line;
        variable v_OLINE: line;
        
        variable v_A: std_logic_vector(IN_SIZE-1 downto 0);
        variable v_SEL: std_logic_vector(SEL_SIZE-1 downto 0);
        variable v_space: character;
        
    begin
    v_A := (others => '0');
    v_SEL := (others => '0');
    v_space := '0';
    file_open(file_vectors,"C:\Users\magno\OneDrive\Documents\College_CPP\VHDL\lab1_edge_input.txt" , read_mode);     
    file_open(file_results,"C:\Users\magno\OneDrive\Documents\College_CPP\VHDL\lab1_edge_output.txt" , write_mode);
    
    while not endfile(file_vectors) loop
        readline(file_vectors, v_ILINE);
        read(v_ILINE, v_A);
        read(v_ILINE, v_space);
        read(v_ILINE, v_SEL);
        
        A_tb <= v_A;
        SEL_tb <= v_SEL;
              
        wait for 4*clock_period;
        
        write(v_OLINE, X_tb);
        writeline(file_results, v_OLINE);
        
        end loop;
            file_close(file_vectors);
            file_close(file_results);
        
        wait;
    end process;

end Behavioral;
