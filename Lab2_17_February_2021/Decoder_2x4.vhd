----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2021 06:34:59 PM
-- Design Name: 
-- Module Name: Decoder_2x4 - Behavioral
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

entity Decoder_2x4 is
    Port ( 
        A   : in std_logic_vector(1 downto 0);
        E   : in std_logic;
        X   : out std_logic_vector(3 downto 0)    
    );
end Decoder_2x4;


architecture Behavioral of Decoder_2x4 is

begin

    my_case : process(A, E)
    begin
        if( E = '1' ) then
            X <= "0000";
            case A is
                when "00" => X(0) <= '1';
                when "01" => X(1) <= '1';
                when "10" => X(2) <= '1';
                when "11" => X(3) <= '1';
                when others => X <= "ZZZZ";
            end case;
        else
            X <= (others => '0');
        end if;
    end process my_case;

end Behavioral;
