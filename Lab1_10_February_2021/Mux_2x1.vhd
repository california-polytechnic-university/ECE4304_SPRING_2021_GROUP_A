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

entity Mux_2x1 is
    Port (
        A   :   in std_logic;
        B   :   in std_logic;
        SEL :   in std_logic;
        X   :   out std_logic
    );
end Mux_2x1;

architecture Behavioral of Mux_2x1 is

begin

    X <= (A and (not SEL)) or (B and SEL); 

end Behavioral;
