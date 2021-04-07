----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2021 04:18:57 PM
-- Design Name: 
-- Module Name: Adder - Behavioral
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

entity Adder is
    Port ( 
        A : in std_logic;
        B : in std_logic;
        CIN : in std_logic;
        
        Z : out std_logic;
        COUT : out std_logic
    );
end Adder;

architecture Behavioral of Adder is

signal Z0, Z1, Z2, Z3: std_logic;
signal C0, C1, C2 : std_logic;

begin

    -- X gates
    Z0 <= not A and not B and CIN;
    Z1 <= not A and B and not CIN;
    Z2 <= A and B and CIN;
    Z3 <= A and not B and not CIN;
    
    -- COUT gates
    C0 <= B and CIN;
    C1 <= A and B;
    C2 <= A and CIN;
    
    -- Outputs
    Z <= Z0 or Z1 or Z2 or Z3;
    COUT <= C0 or C1 or C2;

end Behavioral;
