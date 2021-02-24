----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2021 06:23:49 PM
-- Design Name: 
-- Module Name: Display_3x8 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
            when others  => X <= b"111_1111";   -- Other then disabled 
        end case;
    
    end process SEL;


end Behavioral;
