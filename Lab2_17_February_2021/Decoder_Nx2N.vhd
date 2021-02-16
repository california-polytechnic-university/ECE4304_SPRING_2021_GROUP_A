----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2021 07:03:48 PM
-- Design Name: 
-- Module Name: Decoder_Nx2N - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder_Nx2N is
    generic(
        IN_SIZE : integer:= 5
    );
    Port ( 
        A   : in std_logic_vector(IN_SIZE-1 downto 0);
        X   : out std_logic_vector(2**IN_SIZE-1 downto 0)
    );
end Decoder_Nx2N;

architecture Behavioral of Decoder_Nx2N is

component Decoder_2x4
    Port ( 
        A   : in std_logic_vector(1 downto 0);
        E   : in std_logic;
        X   : out std_logic_vector(3 downto 0)    
    );
end component;

-- Calculation for amount of stage numbers, rounds down for odd values of IN_SIZE
constant STAGE_NUMBER: integer := (IN_SIZE)/2; 

-- Array declaration, INTERNAL_CARRY holds the enables for the decoders in each stage
type LOGIC_ARRAY is array (0 to STAGE_NUMBER) of std_logic_vector( 2**IN_SIZE-1 downto 0);
signal INTERNAL_CARRY : LOGIC_ARRAY := (others => (others => '0'));

-- SEL_CARRY holds the SELECT values for each stage
signal SEL_CARRY : std_logic_vector(IN_SIZE-1 downto 0) := (others => '0');

begin    
    
    -- CASE_EVEN generates when IN_SIZE is even
    CASE_EVEN: if( IN_SIZE mod 2 = 0 )  generate
    
        SEL_CARRY(IN_SIZE-1 downto 0) <= A; -- Input A is used in every stage
        INTERNAL_CARRY(0)(0) <= '1';        -- First stage decoder is enabled
    
        -- DECODER generation for each stage
        -- Enabled is used from current row in INTERNAL_CARRY, output is used for next row
        -- Calculation for amount of decoders differs from CASE_ODD
        STAGE_EVEN: for i in 0 to STAGE_NUMBER-1 generate
        
            DECODERS_EVEN: for j in 0 to 2**(i * 2)-1 generate
            
                DECODER_INST: Decoder_2x4 port map(
                    A => SEL_CARRY(IN_SIZE-(2*i)-1 downto IN_SIZE-(2*i)-2),
                    E => INTERNAL_CARRY(i)(j),
                    X => INTERNAL_CARRY(i+1)(4*j + 3 downto 4*j) 
                );
            
            end generate DECODERS_EVEN;
        
        end generate STAGE_EVEN;
    
    end generate CASE_EVEN;

    -- CASE_ODD generates when IN_SIZE is odd
    CASE_ODD: if( IN_SIZE mod 2 = 1 ) generate
    
        SEL_CARRY(IN_SIZE-1 downto 0) <= A(IN_SIZE-2 downto 0) & '0';       -- Input A is not used as a SEL, remove and pad with '0'
        INTERNAL_CARRY(0)(1 downto 0) <= A(IN_SIZE-1) & not A(IN_SIZE-1);   -- First stage decoders enable depend on Input A
        
        -- DECODER generation for each stage
        -- Enabled is used from current row in INTERNAL_CARRY, output is used for next row
        -- Calculation for amount of decoders in a stage differs from CASE_EVEN
        STAGE_ODD: for i in 0 to STAGE_NUMBER-1 generate
        
           DECODERS_ODD: for j in 0 to (2**(i * 2 + 1))-1 generate
                
                DECODER_INST: Decoder_2x4 port map(
                    A => SEL_CARRY(IN_SIZE-(2*i)-1 downto IN_SIZE-(2*i)-2),
                    E => INTERNAL_CARRY(i)(j),
                    X => INTERNAL_CARRY(i+1)(4*j + 3 downto 4*j) 
                );
                
            end generate DECODERS_ODD;
        
        end generate STAGE_ODD;
        
    end generate CASE_ODD;

    -- Assign output X from last row of INTERNAL_CARRY
    X <= INTERNAL_CARRY(STAGE_NUMBER)(2**IN_SIZE-1 downto 0);     

end Behavioral;
