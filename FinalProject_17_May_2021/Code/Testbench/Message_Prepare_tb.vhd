library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Message_Prepare_tb is
--  Port ( );
end Message_Prepare_tb;

architecture Behavioral of Message_Prepare_tb is

component Message_Prepare is
    Port ( 
        RAW_MSG : in std_logic_vector(1143 downto 0);
        SW      : in std_logic_vector(1 downto 0);        
        MSG_OUT : out std_logic_vector(1599 downto 0)
    );
end component Message_Prepare;

    signal RAW_MSG_TB  : std_logic_vector(1143 downto 0);
    signal SW_TB      : std_logic_vector(1 downto 0);
    signal MSG_OUT_TB  : std_logic_vector(1599 downto 0);

    constant clock_period : time := 10ns;
    file file_results: text;

begin

    UUT: Message_Prepare 
    port map(
        RAW_MSG => RAW_MSG_TB,
        SW      => SW_TB,
        MSG_OUT => MSG_OUT_TB
    );

    --Non-TEXTIO testbench
--    UUT_TB : process 
--    begin
--        SW_TB <= "00";
--        RAW_MSG_TB <= X"6162630600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
--           wait;
--    end process;
    
    TEXTIO_GEN: process
    variable v_ILINE: line;
    variable v_OLINE: line;
        
    begin
    file_open(file_results,"C:\Users\kylet\GoogleDrive\Sync\ECE_4304\SHA3\output_message_tb.txt" , write_mode);
    
        RAW_MSG_TB <= X"535A6861676E616F6967686E535A6861676E616F6967686E535A535A6861676E616F61646161616106000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

        SW_TB <= "00";   
        wait for 1 ns;    
        hwrite(v_OLINE, MSG_OUT_TB);
        writeline(file_results, v_OLINE);
        
        
        SW_TB <= "01"; 
        wait for 1 ns;
        hwrite(v_OLINE, MSG_OUT_TB);
        writeline(file_results, v_OLINE);
        
        SW_TB <= "10"; 
        wait for 1 ns;
        hwrite(v_OLINE, MSG_OUT_TB);
        writeline(file_results, v_OLINE);
        
        SW_TB <= "11";
        wait for 1 ns; 
        hwrite(v_OLINE, MSG_OUT_TB);
        writeline(file_results, v_OLINE);

        wait for 1 ns; 

        file_close(file_results);
        wait;
        end process;


end Behavioral;


