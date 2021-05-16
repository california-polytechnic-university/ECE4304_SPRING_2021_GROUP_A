-- File Name: Keccak_Permutation_tb.vhd
-- Purpose  : Testbench the SHA3-256 algorithm for one round. (Input custom IOTA to denote which round) Outputs to TEXTIO file in HEX for easier reading.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Keccak_Permutation_tb is
--  Port ( );
end Keccak_Permutation_tb;

architecture Behavioral of Keccak_Permutation_tb is

component Keccak_Permutation is
    Port ( 
        IOTA_CONST : in std_logic_vector(63 downto 0);
        DATA_IN     : in std_logic_vector(1599 downto 0);
        DATA_OUT    : out std_logic_vector(1599 downto 0)
    );
end component Keccak_Permutation;

signal TB_IOTA : std_logic_vector(63 downto 0);
signal TB_DATA_IN : std_logic_vector(1599 downto 0);
signal TB_DATA_OUT : std_logic_vector(1599 downto 0);

constant clock_period : time := 10ns;
file file_results: text;

begin
    UUT: Keccak_Permutation 
    port map(
        IOTA_CONST => TB_IOTA,
        DATA_IN => TB_DATA_IN,
        DATA_OUT => TB_DATA_OUT
    );

    -- Non-TEXTIO testbench
--    UUT_TB : process 
--    begin
--        -- IOTA value for 1st round rotation:
--        TB_IOTA <= X"0000000000008082";
--        -- "abc" input padded for SHA3-256:
--        TB_DATA_IN <= X"61626306000400006600000000102636008030B1310700006062430600000000068030B1311326360800000000000000C400204C6CFC4C6C0800000000000010CC00000000304C6C0000204C6CCC0010C2C4C60C0000000020C2C4C60C0000000000000000000000C20606CA0C00000020000400000000000084899D2F36660000400000100000000084898D19000000004000102636660000000000100000000600000000616243000000000002000082898D1900616263000000000002002084898D1900000000";   
--           wait;
--    end process;
   
    TEXTIO_GEN: process
        variable v_ILINE: line;
        variable v_OLINE: line;
        
    begin
    file_open(file_results,"C:\Users\kylet\Google Drive\Sync\ECE_4304\SHA3\output_lane_tb.txt" , write_mode);
    
        -- IOTA value for 2nd round rotation:
        TB_IOTA <= X"0000000000008082";
        -- "abc" input after 1st round of permutation:
        TB_DATA_IN <= X"61626306000400006600000000102636008030B1310700006062430600000000068030B1311326360800000000000000C400204C6CFC4C6C0800000000000010CC00000000304C6C0000204C6CCC0010C2C4C60C0000000020C2C4C60C0000000000000000000000C20606CA0C00000020000400000000000084899D2F36660000400000100000000084898D19000000004000102636660000000000100000000600000000616243000000000002000082898D1900616263000000000002002084898D1900000000";
        
        -- Output is going to be value after 2nd round of permutation:
        wait for 1 ns;
           
        hwrite(v_OLINE, TB_DATA_OUT);
        writeline(file_results, v_OLINE);
        
        file_close(file_results);
        wait;
        end process;

end Behavioral;