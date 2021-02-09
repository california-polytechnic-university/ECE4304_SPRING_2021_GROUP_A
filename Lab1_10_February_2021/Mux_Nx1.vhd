----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2021 02:17:58 PM
-- Design Name: 
-- Module Name: Mux_Nx1 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux_Nx1 is
    generic(
        IN_SIZE :integer := 16;
        SEL_SIZE:integer := 4
    );

    Port ( 
        N_A     : in std_logic_vector(IN_SIZE-1 downto 0);
        N_SEL   : in std_logic_vector(SEL_SIZE-1 downto 0);
        N_X     : out std_logic
    );
end Mux_Nx1;

architecture Behavioral of Mux_Nx1 is

-- Declare 2x1 mux component
component Mux_2x1
    Port (
        A   :   in std_logic;
        B   :   in std_logic;
        SEL :   in std_logic;
        X   :   out std_logic
    );
end component;

-- Declare 2D std_logic array and instantiate it to 0
type LOGIC_ARRAY is array (0 to SEL_SIZE-1, 0 to IN_SIZE-1) of std_logic;
signal INTERMEDIATE_CARRY : LOGIC_ARRAY := (others => (others => '0'));

begin

    -- Outter for-generate loop. Runs loop for amount of stages (SEL_SIZE)
    STAGES: for i in 0 to SEL_SIZE-1 generate
        
        -- Inner for-generate loop. Runs loop for amount of muxes per stage (Calculated by 2^(SEL_SIZE-1-STAGE))
        MUXES: for j in 0 to (2**(SEL_SIZE-1-i))-1 generate
            
            -- Special generate for the muxes in the first stage, take input N_A.
            STAGE_FIRST: if( i = 0 ) generate
                MUX_FIRST: Mux_2x1 port map(
                    A   =>  N_A(2 * j),
                    B   =>  N_A(2 * j + 1),
                    SEL =>  N_SEL(i),
                    X   =>  INTERMEDIATE_CARRY(i, j)
                );
            end generate STAGE_FIRST;
            
            -- Generate for the muxes in all other stages, take input from 2D array and output to it.
            STAGE_INTERMEDIATE: if (i > 0) and (i <= SEL_SIZE-1) generate
                MUX_INTERMEDIATE: Mux_2x1 port map(
                    A   =>  INTERMEDIATE_CARRY(i - 1, 2 * j),
                    B   =>  INTERMEDIATE_CARRY(i - 1, 2 * j + 1),
                    SEL =>  N_SEL(i),
                    X   =>  INTERMEDIATE_CARRY(i, j)
                );           
            end generate STAGE_INTERMEDIATE;       
        
        end generate MUXES;
        
    end generate STAGES;

    -- Assign output to last row in memory
    N_X <= INTERMEDIATE_CARRY(SEL_SIZE-1, 0);

end Behavioral;
