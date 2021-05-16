library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity Counter is
    generic(
        COUNT_VAL : integer := 131071   -- Equivalent to (16 downto 0) <= (others => '1')
    );
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;
        
        VAL : out std_logic_vector(integer(ceil(log2(real(COUNT_VAL))))-1 downto 0);
        TICK: out std_logic
    );
end Counter;

architecture Behavioral of Counter is

    signal COUNT_TMP : std_logic_vector(integer(ceil(log2(real(COUNT_VAL))))-1 downto 0) := (others => '0');

begin

    COUNT : process (CLK, RST, COUNT_TMP) begin
    
        if(rising_edge(CLK)) then
            if(RST = '1') then
                COUNT_TMP <= (others => '0');
                TICK <= '0';
            else
                if( unsigned(COUNT_TMP) = COUNT_VAL ) then
                    COUNT_TMP <= (others => '0');
                    TICK <= '1';
                else
                    COUNT_TMP <= std_logic_vector(unsigned(COUNT_TMP) + 1);
                    TICK <= '0';
                end if;
            end if;
        end if;
        VAL <= COUNT_TMP;
    end process COUNT;

end Behavioral;
