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
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux_Nbit_Nx1 is
    generic(
        IN_SIZE :integer := 6;
        WIDTH   :integer := 16
    );

    Port ( 
        N_A     : in std_logic_vector(2**IN_SIZE-1 downto 0);
        N_SEL   : in std_logic_vector(integer(ceil(log2(real(2**IN_SIZE / WIDTH))))-1 downto 0);
        N_X     : out std_logic_vector(WIDTH-1 downto 0)
    );
end Mux_Nbit_Nx1;

architecture Behavioral of Mux_Nbit_Nx1 is

constant SEL_SIZE: integer := integer(ceil(log2(real(2**IN_SIZE / WIDTH))));
signal tmp_muxnx1: std_logic_vector(WIDTH-1 downto 0);
-- Declare 2x1 mux component
component Mux_Nbit_2x1
    generic(
        WIDTH   :integer := 16
    );
    Port (
        A   :   in std_logic_vector(WIDTH-1 downto 0);
        B   :   in std_logic_vector(WIDTH-1 downto 0);
        SEL :   in std_logic;
        X   :   out std_logic_vector(WIDTH-1 downto 0)
    );
end component Mux_Nbit_2x1;

-- Declare 2D std_logic array, instantiate to 'X' to catch out of bound values
type LOGIC_ARRAY is array (0 to SEL_SIZE, 0 to 2**SEL_SIZE-1) of std_logic_vector(WIDTH-1 downto 0);
signal INTERNAL_CARRY : LOGIC_ARRAY;

begin

    -- Initialize first row with input values
    INITIALIZE: for a in 0 to 2**SEL_SIZE-1 generate
        INTERNAL_CARRY(0, a) <= N_A((WIDTH*(a+1)-1) downto WIDTH*a);    
    end generate INITIALIZE;


    -- Outter for-generate loop. Runs loop for amount of stages (SEL_SIZE)
    STAGES: for i in 0 to SEL_SIZE-1 generate
    
        -- Inner for-generate loop. Runs loop for amount of muxes per stage (Calculated by 2^(SEL_SIZE-1-STAGE))
        MUXES: for j in 0 to (2**(SEL_SIZE-1-i))-1 generate
            -- Generate mux, take input from 2D array and output to it.
            MUX_INTERMEDIATE: Mux_Nbit_2x1 
            generic map(
                WIDTH => WIDTH
            )
            port map(
                A   =>  INTERNAL_CARRY(i, (2 * j)),
                B   =>  INTERNAL_CARRY(i, (2 * j + 1)),
                SEL =>  N_SEL(i),
                X   =>  INTERNAL_CARRY(i + 1, j)
            );           
        end generate MUXES; 
        
    end generate STAGES;

    -- Assign output to last row in memory
    N_X <= INTERNAL_CARRY(SEL_SIZE, 0);
end Behavioral;