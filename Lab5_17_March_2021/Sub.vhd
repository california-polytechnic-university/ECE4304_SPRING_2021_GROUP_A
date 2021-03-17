library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SUB is
    generic(
        WIDTH_SUB : integer:= 4
    );
    Port ( 
        A_SUB   : in std_logic_vector(WIDTH_SUB-1 downto 0);
        B_SUB   : in std_logic_vector(WIDTH_SUB-1 downto 0);
        
        Z_SUB   : out std_logic_vector(WIDTH_SUB-1 downto 0);
        NEG_SUB : out std_logic
    );
end SUB;

architecture Behavioral of SUB is

begin

-- Subtraction Logic --    

    -- Subtraction process
    SUB_OUTPUT : process (A_SUB, B_SUB) 
        variable SIGNED_TMP : std_logic_vector(WIDTH_SUB downto 0);         -- Holds signed output from subtraction
        variable SUB_RESULT_UNPAD : std_logic_vector(WIDTH_SUB downto 0);   -- Holds converted result
    begin
    
        SIGNED_TMP := std_logic_vector(signed('0' & A_SUB) - signed('0' & B_SUB)); -- Perform signed subtraction
        if( SIGNED_TMP(WIDTH_SUB) = '1' ) then
            SUB_RESULT_UNPAD := std_logic_vector(unsigned(not SIGNED_TMP) + 1); -- Two's compliment if negative
            NEG_SUB <= '1';
        else
            SUB_RESULT_UNPAD := SIGNED_TMP;                                     -- Do nothing if positive
            NEG_SUB <= '0';
        end if;
        
        Z_SUB <= SUB_RESULT_UNPAD(WIDTH_SUB-1 downto 0);    -- Ignore sign bit when outputting   
    end process SUB_OUTPUT;
    
-- End Subtraction Logic --   

end Behavioral;
