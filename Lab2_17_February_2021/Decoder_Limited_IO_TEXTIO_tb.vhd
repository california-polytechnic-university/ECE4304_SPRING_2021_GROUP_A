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
use IEEE.math_real."ceil";
use IEEE.math_real."log2";


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder_Limited_IO_tb is
    generic(
        TOP_IN_SIZE_TB : integer:=6;
        TOP_WIDTH_TB: integer  := 16
    );
end Decoder_Limited_IO_tb;

architecture Behavioral of Decoder_Limited_IO_tb is

component Decoder_Limited_IO
  generic(
          TOP_IN_SIZE: integer:= 6;
          TOP_WIDTH: integer  := 16
          );
Port (
          TOP_A  : in std_logic_vector (TOP_IN_SIZE-1 downto 0);
          TOP_SEL: in std_logic_vector (integer(ceil(log2(real(2**TOP_IN_SIZE / TOP_WIDTH))))-1 downto 0);
          TOP_X  : out std_logic_vector(TOP_WIDTH-1 downto 0)
       );
end component;


signal A_TB : std_logic_vector(TOP_IN_SIZE_TB-1 downto 0) := (others => '0');
signal SEL_TB: std_logic_vector(integer(ceil(log2(real(2**TOP_IN_SIZE_TB / TOP_WIDTH_TB))))-1 downto 0);
signal X_TB : std_logic_vector(TOP_WIDTH_TB-1 downto 0) := (others => '0');

constant clock_period:time:= 10ns;

file file_vectors: text;
file file_results: text;

begin

    top_TB: Decoder_Limited_IO
    generic map(
        TOP_IN_SIZE => TOP_IN_SIZE_TB,
        TOP_WIDTH   => TOP_WIDTH_TB
    )
    port map(
        TOP_A => A_TB,
        TOP_SEL => SEL_TB,
        TOP_X => X_TB
    );
    
    TEXTIO_GEN: process
        variable v_ILINE: line;
        variable v_OLINE: line;
        
        variable v_A: std_logic_vector(TOP_IN_SIZE_TB-1 downto 0);
        variable v_SEL: std_logic_vector(integer(ceil(log2(real(2**TOP_IN_SIZE_TB / TOP_WIDTH_TB))))-1 downto 0);
        variable v_space: character;
        
    begin
      v_A := (others => '0');
      v_SEL := b"01";
      v_space := '0';
    file_open(file_vectors,"C:\Users\Yuta\Documents\ECE4304 Vivado Projects\Generic_Decoder\inputs.txt" , read_mode);     
    file_open(file_results,"C:\Users\Yuta\Documents\ECE4304 Vivado Projects\Generic_Decoder\outputs.txt" , write_mode);

    while not endfile(file_vectors) loop
        readline(file_vectors, v_ILINE);
        read(v_ILINE, v_A);
        read(v_ILINE, v_space);
        read(v_ILINE, v_SEL);
        
        A_TB <= v_A;
        SEL_tb <= v_SEL;
        
        wait for 4*clock_period;
        
        write(v_OLINE, X_TB);
        writeline(file_results, v_OLINE);
        
        end loop;
                file_close(file_vectors);
                file_close(file_results);
            wait;
        end process;
end Behavioral;