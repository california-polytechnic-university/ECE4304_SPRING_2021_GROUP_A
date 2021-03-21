library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity Mux_Nx1 is
    generic(
        WIDTH : integer := 4;
        INPUTS: integer := 4
    );
    Port (
        MUX_IN  : in std_logic_vector(WIDTH*INPUTS-1 downto 0);
        SEL     : in std_logic_vector(integer(ceil(log2(real(INPUTS))))-1 downto 0);
        
        MUX_OUT : out std_logic_vector(WIDTH-1 downto 0)
    );
end Mux_Nx1;

architecture Behavioral of Mux_Nx1 is

    signal MUX_TMP : std_logic_vector(WIDTH*INPUTS-1 downto 0) := (others => '0');

begin

    MUX : process (MUX_IN, SEL) begin
        MUX_TMP <= MUX_IN;
        
        MUX_OUT <= MUX_IN(WIDTH*(to_integer(unsigned(SEL))+1)-1 downto WIDTH*(to_integer(unsigned(SEL))));
    end process MUX;
    

end Behavioral;
