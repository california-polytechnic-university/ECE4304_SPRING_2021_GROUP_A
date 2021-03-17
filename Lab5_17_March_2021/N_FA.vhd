----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2021 04:14:49 PM
-- Design Name: 
-- Module Name: N_FA - Behavioral
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

entity N_FA is
    generic(
        WIDTH : integer:= 4
    );
    Port ( 
        A : in std_logic_vector(WIDTH-1 downto 0);
        B : in std_logic_vector(WIDTH-1 downto 0);
        CIN : in std_logic;
        
        Z : out std_logic_vector(WIDTH-1 downto 0);
        COUT : out std_logic
    );
end N_FA;

architecture Behavioral of N_FA is

component Adder is
    Port ( 
        A : in std_logic;
        B : in std_logic;
        CIN : in std_logic;
        
        Z : out std_logic;
        COUT : out std_logic
    );
end component Adder;

signal CARRY_HOLD : std_logic_vector(WIDTH downto 0);

begin

    CARRY_HOLD(0) <= CIN;
    CARRY_LOOP: for i in 0 to WIDTH-1 generate
        INST: Adder
        port map(
            A => A(i),
            B => B(i),
            CIN => CARRY_HOLD(i),
            Z => Z(i),
            COUT => CARRY_HOLD(i + 1)
        );
    end generate CARRY_LOOP;
    
    COUT <= CARRY_HOLD(WIDTH);

end Behavioral;
