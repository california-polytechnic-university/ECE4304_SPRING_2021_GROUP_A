library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder_7seg is
    Port ( 
        A : in std_logic_vector(3 downto 0);
        X : out std_logic_vector(6 downto 0)
    );
end Decoder_7seg;

architecture Behavioral of Decoder_7seg is

begin

    -- Decoder for BCD to 7-seg outputs
    SEL: process (A) begin
    
        case A is
            when "0000"  => X <= b"000_0001";   -- 0
            when "0001"  => X <= b"100_1111";   -- 1
            when "0010"  => X <= b"001_0010";   -- 2
            when "0011"  => X <= b"000_0110";   -- 3
            when "0100"  => X <= b"100_1100";   -- 4
            when "0101"  => X <= b"010_0100";   -- 5
            when "0110"  => X <= b"010_0000";   -- 6
            when "0111"  => X <= b"000_1111";   -- 7
            when "1000"  => X <= b"000_0000";   -- 8
            when "1001"  => X <= b"000_1100";   -- 9
            when "1010"  => X <= b"000_1000";   -- A
            when "1011"  => X <= b"110_0000";   -- B
            when "1100"  => X <= b"011_0001";   -- C
            when "1101"  => X <= b"100_0010";   -- D
            when "1110"  => X <= b"011_0000";   -- E
            when "1111"  => X <= b"011_1000";   -- F
        end case;
    
    end process SEL;


end Behavioral;
