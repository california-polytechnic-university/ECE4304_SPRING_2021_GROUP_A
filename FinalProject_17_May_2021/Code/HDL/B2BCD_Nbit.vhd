library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity B2BCD_Nbit is
    generic(
        WIDTH  : integer := 8;  -- WIDTH of input binary
        DIGITS : integer := 3   -- Amount of output BCD digits
    );
    Port ( 
        BCD_IN  : in std_logic_vector(WIDTH-1 downto 0);
        BCD_OUT : out std_logic_vector(4*DIGITS-1 downto 0)
    );
end B2BCD_Nbit;

architecture Behavioral of B2BCD_Nbit is

begin

    -- BCD converting circuit
    process ( BCD_IN )
        variable input_src  : std_logic_vector (WIDTH-1 downto 0) ;
        variable bcd        : std_logic_vector (4*DIGITS-1 downto 0) ;
    begin
        bcd         := (others => '0') ;
        input_src   := BCD_IN;
    
        for i in 0 to WIDTH-1 loop
            for j in 0 to DIGITS-1 loop
                if(bcd(4*(j+1)-1 downto 4*j)) > "0100" then
                    bcd(4*(j+1)-1 downto 4*j) := std_logic_vector(unsigned(bcd(4*(j+1)-1 downto 4*j)) + 3) ;
                end if;
            end loop;
            
            bcd := bcd(4*DIGITS-2 downto 0) & input_src(WIDTH-1);   -- Left shift {BCD, INPUT_SRC}, pad with 0
            input_src := input_src(WIDTH-2 downto 0) & '0';         
            
        end loop; 

        BCD_OUT <= bcd;
    end process ;

end Behavioral;
