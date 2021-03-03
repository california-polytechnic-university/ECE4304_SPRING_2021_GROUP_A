----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2021 01:47:43 AM
-- Design Name: 
-- Module Name: Stacked_Counter - Behavioral
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

entity Stacked_Counter is
    generic(
        DIGITS : integer:=4
    );
    
    Port ( 
        CLK     : in std_logic;
        RST     : in std_logic;
        UD      : in std_logic;
        VAL     : out std_logic_vector(DIGITS*4-1 downto 0)
    );
end Stacked_Counter;

architecture Behavioral of Stacked_Counter is

component BCD_Counter is
    Port ( 
        CLK     : in std_logic;
        RST     : in std_logic;
        EN      : in std_logic;
        UD      : in std_logic;
        BCD_VAL : out std_logic_vector (3 downto 0);    
        TICK    : out std_logic
    );
end component BCD_Counter;

signal ENABLE_CARRY : std_logic_vector (DIGITS downto 0) := (others => '0');

begin

    ENABLE_CARRY(0) <= '1';

    GEN_LOOP: for i in 0 to DIGITS-1 generate
    
        INST: BCD_Counter port map(
            CLK => CLK,
            RST => RST,
            EN => ENABLE_CARRY(i),
            UD => UD,
            BCD_VAL => VAL(4*i + 3 downto (4*i)),
            TICK => ENABLE_CARRY(i+1)
        );
    
    end generate GEN_LOOP;


end Behavioral;
