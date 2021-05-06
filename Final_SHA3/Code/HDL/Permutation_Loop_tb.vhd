-- File Name: Permutation_Loop_tb.vhd
-- Purpose  : Testbench the SHA3-256 algorithm for all 24 rounds. Outputs hash from all 24 rounds to TEXTIO file in HEX for easier reading.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Permutation_Loop_tb is
--  Port ( );
end Permutation_Loop_tb;

architecture Behavioral of Permutation_Loop_tb is

component Permutation_Loop is
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;
        GO  : in std_logic;
        DATA_IN : in std_logic_vector(1599 downto 0); 
        DATA_OUT : out std_logic_vector(1599 downto 0)
    );
end component Permutation_Loop;

signal TB_CLK, TB_RST, TB_GO : std_logic := '0';
signal TB_DATA_IN : std_logic_vector(1599 downto 0);
signal TB_DATA_OUT : std_logic_vector(1599 downto 0);

constant clock_period : time := 10ns;

file file_results: text;

begin

    UUT: Permutation_Loop 
    port map(
        CLK => TB_CLK,
        RST => TB_RST,
        GO => TB_GO,
        DATA_IN => TB_DATA_IN,
        DATA_OUT => TB_DATA_OUT
    );

    CLK_GEN : process begin
        wait for clock_period / 2;
        TB_CLK <= not TB_CLK;
    end process CLK_GEN;

    -- Non-TEXTIO testbench
--    UUT_TB : process 
--    begin
--        TB_RST <= '1';
--        --TB_DATA_IN <= (others => '0');
--        TB_DATA_IN <= X"6162630600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
--        wait for 20 ns;
--        TB_RST <= '0';
--        wait for 10 ns;
--        TB_GO <= '1';
--        wait for 20 ns;
--        TB_GO <= '0';
--        wait;
--    end process;

    TEXTIO_GEN: process
        variable v_ILINE: line;
        variable v_OLINE: line;
        
    begin
    file_open(file_results,"C:\Users\kylet\Google Drive\Sync\ECE_4304\SHA3\output_permutation_tb.txt" , write_mode);
    
        TB_RST <= '1';
        -- "abc" input padded for SHA3-256:
        TB_DATA_IN <= X"6162630600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        wait for 20 ns;
        TB_RST <= '0';
        wait for 10 ns;
        TB_GO <= '1';
        wait for 20 ns;
        TB_GO <= '0';
        
        wait for 6 ns;
        
        -- Rounds start after 50ns on testbench, start writing to file then:
        for i in 0 to 23 loop
            hwrite(v_OLINE, TB_DATA_OUT);
            writeline(file_results, v_OLINE);
            wait for clock_period;
        end loop;
        
        file_close(file_results);
        wait;
    end process;

end Behavioral;
