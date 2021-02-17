----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2021 01:58:32 PM
-- Design Name: 
-- Module Name: Mux_2x1 - Behavioral
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

entity Mux_Nbit_2x1 is
    generic(
        WIDTH : integer:= 16
    );
    Port (
        A   :   in std_logic_vector(WIDTH-1 downto 0);
        B   :   in std_logic_vector(WIDTH-1 downto 0);
        SEL :   in std_logic;
        X   :   out std_logic_vector(WIDTH-1 downto 0)
    );
end Mux_Nbit_2x1;

architecture Behavioral of Mux_Nbit_2x1 is

begin

    my_case: process(SEL, A, B)
        begin
        case SEL is 
            when '0' => X <= A;
            when '1' => X <= B;
            when others => X <= (others => 'Z');
        end case;
   end process my_case;

end Behavioral;