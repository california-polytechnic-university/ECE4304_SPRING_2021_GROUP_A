----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2021 08:49:45 PM
-- Design Name: 
-- Module Name: Top_B2BCD_Display_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use std.env.finish;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_B2BCD_Display_tb is
--  Port ( );
end Top_B2BCD_Display_tb;

architecture Behavioral of Top_B2BCD_Display_tb is

component Top_B2BCD_Display 
    Port ( 
        -- Input Ports --
        CLK : in std_logic;
        RST : in std_logic; 
        IN1 : in std_logic_vector( 3 downto 0 );
        IN2 : in std_logic_vector( 3 downto 0 );
        
        -- Output Ports --
        CACG: out std_logic_vector( 6 downto 0 );
        DP  : out std_logic;
        AN  : out std_logic_vector( 7 downto 0 )
    );
end component Top_B2BCD_Display;

signal CLK_TB   : std_logic := '0';
signal RST_TB   : std_logic := '1';
signal IN1_TB   : std_logic_vector( 3 downto 0 ) := (others => '0');
signal IN2_TB   : std_logic_vector( 3 downto 0 ) := (others => '0');

signal CACG_TB  : std_logic_vector( 6 downto 0 );
signal DP_TB    : std_logic; 
signal AN_TB    : std_logic_vector( 7 downto 0 );

constant clock_period: time:= 10ns;

begin

    UUT: Top_B2BCD_Display 
    port map ( 
        -- Input Ports --
        CLK => CLK_TB,
        RST => RST_TB,
        IN1 => IN1_TB,
        IN2 => IN2_TB,
        
        -- Output Ports --
        CACG    => CACG_TB,
        DP      => DP_TB,  
        AN      => AN_TB
    );

    CLK_GEN: process
    begin
        CLK_TB <= '0';
        wait for clock_period / 2;
        CLK_TB <= '1';
        wait for clock_period / 2;    
    end process CLK_GEN;
    
    TEST_TB: process
    begin
    
        RST_TB <= '1'; 
        wait for clock_period;
        RST_TB <= '0';
        
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                IN1_TB <= std_logic_vector(to_unsigned(i, IN1_TB'length));
                IN2_TB <= std_logic_vector(to_unsigned(j, IN1_TB'length));
                wait for 30 * clock_period;
            end loop;
        end loop;
        
        finish;     
    
    end process TEST_TB;


end Behavioral;
