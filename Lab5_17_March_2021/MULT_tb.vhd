library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MULT_tb is
    generic(
        WIDTH_TB : integer:= 4
    );
-- Port ( );
end MULT_tb;

architecture Behavioral of MULT_tb is

component MULT is
    generic(
        WIDTH_MULT : integer:= 4
    );
    Port ( 
        A_MULT : in std_logic_vector(WIDTH_MULT-1 downto 0);
        B_MULT : in std_logic_vector(WIDTH_MULT-1 downto 0);
        Z_MULT : out std_logic_vector(WIDTH_MULT*2-1 downto 0)
    );
end component MULT;

signal A_TB     : std_logic_vector(WIDTH_TB-1 downto 0);
signal B_TB     : std_logic_vector(WIDTH_TB-1 downto 0);
signal Z_TB     : std_logic_vector(WIDTH_TB*2-1 downto 0);

constant clock_period : time:=10ns;

begin

    UUT: MULT
    generic map(
        WIDTH_MULT  => WIDTH_TB
    )
    port map(
        A_MULT  => A_TB,
        B_MULT  => B_TB,
        Z_MULT  => Z_TB
    );
    
    TB_CASE: process begin
        for i in 0 to 2**WIDTH_TB-1 loop
            for j in 0 to 2**WIDTH_TB-1 loop
                A_TB <= std_logic_vector(to_unsigned(i, A_TB'length));
                B_TB <= std_logic_vector(to_unsigned(j, B_TB'length));
                wait for clock_period * 10;
            end loop;
        end loop;   
        wait;
    end process TB_CASE;

end Behavioral;
