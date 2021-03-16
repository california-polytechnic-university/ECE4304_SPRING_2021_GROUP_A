----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2021 04:09:34 PM
-- Design Name: 
-- Module Name: Q5 - Behavioral
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

entity MULT is
    generic(
        WIDTH: integer:= 4
    );
    Port ( 
        A : in std_logic_vector(WIDTH-1 downto 0);
        B : in std_logic_vector(WIDTH-1 downto 0);
        Z : out std_logic_vector(WIDTH*2-1 downto 0)
    );
end MULT;

architecture Behavioral of MULT is

component N_FA is
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
end component N_FA;

signal CARRY_ARRAY : std_logic_vector( (WIDTH+1)*WIDTH-1 downto 0);
signal B_INPUT : std_logic_vector(WIDTH*(WIDTH-1)-1 downto 0);

begin
    -- Initial FA A(3) is 0
    CARRY_ARRAY(WIDTH) <= '0';
    
    -- Initial value for A needs to be instantiated on input
    CARRY_ARRAY_INIT : for i in 0 to WIDTH-1 generate       
        CARRY_ARRAY(i) <= B(0) and A(i);    
    end generate CARRY_ARRAY_INIT;
    
    -- Initialize B values needs to be instantiated on input
    B_INP_FA : for i in 0 to WIDTH-2 generate
        B_INP_Y : for j in 0 to WIDTH-1 generate      
            B_INPUT(i*WIDTH + j) <= B(i+1) and A(j); 
        end generate B_INP_Y;
    end generate B_INP_FA;

    -- Main cascading FA loop
    FA_LOOP : for i in 0 to WIDTH-2 generate
    
        FA_INST: N_FA
        generic map(
            WIDTH => WIDTH
        )
        port map(
            A => CARRY_ARRAY(i*(WIDTH+1) + WIDTH downto i*(WIDTH+1) + 1),
            B => B_INPUT(i*WIDTH+WIDTH-1 downto i*WIDTH),
            CIN => '0',
            Z => CARRY_ARRAY((i+1)*(WIDTH+1) + WIDTH - 1 downto (i+1)*(WIDTH+1)),
            COUT => CARRY_ARRAY((i+1)*(WIDTH+1) + WIDTH)
        );
        -- Output LSB from FA sum straight to final answer
        Z(i) <= CARRY_ARRAY(i * (WIDTH+1));
    end generate;
    
    -- Fill in rest of final answer with the result of the final FA loop
    Z(2*WIDTH-1 downto WIDTH-1) <= CARRY_ARRAY((WIDTH+1)*WIDTH-1 downto (WIDTH+1)*WIDTH-WIDTH-1);

end Behavioral;
