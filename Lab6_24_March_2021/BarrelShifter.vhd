
-------------------------------------------------------
--  Barrel Shifter
--      Only rotates left (SHIFT_IN) amount of times
--      Only shifts 0-(WIDTH-1) amount of times
-------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity BarrelShifter is
    generic(
        WIDTH : integer := 8
    );
    Port ( 
        VAL_IN  : in std_logic_vector(WIDTH-1 downto 0);
        SHIFT_IN: in std_logic_vector(integer(ceil(log2(real(WIDTH))))-1 downto 0);
        
        VAL_OUT : out std_logic_vector(WIDTH-1 downto 0)
    );
end BarrelShifter;

architecture Behavioral of BarrelShifter is

-- Amount of stages is how large the shift width is
constant STAGES : integer := integer(ceil(log2(real(WIDTH))));

-- 2D array of logic vectors input WIDTH wide
type ARR is array(0 to STAGES) of std_logic_vector(WIDTH-1 downto 0);
signal VAL_TMP : ARR := (others => (others => '0'));

begin
    -- Initialize first row of 2D array with the input 
    VAL_TMP(0) <= VAL_IN;
    
    SHIFT : for i in 0 to STAGES-1 generate
        CHECK : process (SHIFT_IN, VAL_TMP, VAL_IN) begin
            if(SHIFT_IN(i) = '1') then      -- If select bit is on for this stage, rotate left.
                VAL_TMP(i + 1) <= VAL_TMP(i)(WIDTH - 2**i - 1 downto 0) & VAL_TMP(i)(WIDTH - 1 downto WIDTH - 2**i);
            else
                VAL_TMP(i + 1) <= VAL_TMP(i);
            end if;
        end process CHECK;
    end generate SHIFT;
    
    VAL_OUT <= VAL_TMP(STAGES);

end Behavioral;
