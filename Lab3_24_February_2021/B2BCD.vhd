----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2021 05:44:11 PM
-- Design Name: 
-- Module Name: B2BCD - Behavioral
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

entity B2BCD is
    Port ( 
        A: in std_logic_vector(3 downto 0);
        X: out std_logic_vector(3 downto 0)
    );
end B2BCD;

architecture Behavioral of B2BCD is

begin

    -- Binary to BCD Decoder
    OUTPUT: process (A) begin
    
        if(A <= b"1001") then   -- If input is valid BCD, let pass
            X <= A; 
        else                    -- Else, set to 0
            X <= (others => '0');
        end if;        
    
    end process OUTPUT;


end Behavioral;
