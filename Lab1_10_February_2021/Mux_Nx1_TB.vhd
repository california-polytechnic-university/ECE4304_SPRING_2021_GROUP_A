----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2021 10:38:24 PM
-- Design Name: 
-- Module Name: Mux_Nx1_TB - Behavioral
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
use IEEE. numeric_std.all;
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

entity Mux_Nx1_TB is
                generic( IN_SIZE_TB : integer:= 64);
--  Port ( );
end Mux_Nx1_TB;

architecture Behavioral of Mux_Nx1_TB is
constant SEL_SIZE_TB: integer := integer(ceil(log2(real(IN_SIZE))));
component Mux_Nx1
                generic( IN_SIZE : integer:= 64);                                            
                Port(       N_A: in std_logic_vector(IN_SIZE-1 downto 0);
                            N_SEL: in std_logic_vector(ceil(log2(real(IN_SIZE))))-1 downto 0);
                            N_X: out std_logic);
                                
                                
end component;


signal A_TB : std_logic_vector(IN_SIZE_TB-1 downto 0);
signal SEL_TB : std_logic_vector(SEL_SIZE_TB-1 downto 0) := (others => '0');
signal X_TB: std_logic;

constant clock_period:time:=10 ns; 

file file_inputs: text;
file file_results: text;
begin

MUX_GEN: Mux_Nx1
                generic map(
                            IN_SIZE => IN_SIZE_TB
                )
                port map(
                            N_A  => A_TB,
                            N_SEL => SEL_SIZE,
                            N_X => X_TB);

TXTIO_GEN: process
                variable v_ILINE: line;
                variable v_OLINE: line;
                
                variable v_A: std_logic_vector(IN_SIZE_TB-1 downto 0);
                variable v_SEL: std_logic_vector(SEL_SIZE_TB-1 downto 0);
                variable v_SPACE: character;
                
                
                begin 
                
                file_open(file_inputs,"C:\Users\Yuta\Desktop\ECE4304Projects\Lab_1\inputs.txt" , read_mode);     
                file_open(file_results,"C:\Users\Yuta\Desktop\ECE4304Projects\Lab_1\outputs.txt" , write_mode);
                
                while not endfile(file_inputs) loop
                    readline(file_inputs, v_ILINE);
                    read(v_ILINE, v_A);
                    read(v_ILINE, v_SPACE);
                    read(v_ILINe, v_SEL);
                    
                    A_TB  <=  v_A;
                    SEL_TB <= v_SEL;
                    
                    wait for 4*clock_period;
                    
                    write(v_OLINE, X_TB);
                    writeline(file_results, v_OLINE);               
                                  
                end loop;
                    file_close(file_inputs);
                    file_close(file_results);
                wait;
                end process;

end Behavioral;
