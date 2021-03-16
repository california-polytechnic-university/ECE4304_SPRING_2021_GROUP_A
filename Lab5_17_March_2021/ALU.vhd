----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2021 05:03:57 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    generic(
        WIDTH : integer:=4
    );
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;
        A   : in std_logic_vector(WIDTH-1 downto 0);
        B   : in std_logic_vector(WIDTH-1 downto 0);
        SEL : in std_logic_vector(1 downto 0);
        
        RES     : out std_logic_vector(WIDTH*2-1 downto 0);
        NEG     : out std_logic;
        RES_RDY : out std_logic  
    );
end ALU;

architecture Behavioral of ALU is

component MULT is
    generic(
        WIDTH: integer:= 4
    );
    Port ( 
        A : in std_logic_vector(WIDTH-1 downto 0);
        B : in std_logic_vector(WIDTH-1 downto 0);
        Z : out std_logic_vector(WIDTH*2-1 downto 0)
    );
end component MULT;

constant PAD_0 : std_logic_vector(WIDTH-1 downto 0) := (others => '0');

signal ADD_RESULT       : std_logic_vector(WIDTH*2-1 downto 0);

signal SUB_NEG          : std_logic;
signal SUB_RESULT       : std_logic_vector(WIDTH*2-1 downto 0); 
signal SUB_RESULT_UNPAD : std_logic_vector(WIDTH downto 0);

signal MUL_RESULT   : std_logic_vector(WIDTH*2-1 downto 0);

signal DIV_RESULT   : std_logic_vector(WIDTH*2-1 downto 0);
signal DIV_RDY      : std_logic;

begin

-- Mux output
MUX_OUTPUT: process (CLK, SEL) begin

    if(rising_edge(CLK)) then
        NEG <= '0';
        case(SEL) is
            when "00" =>    -- SEL = 0, ADD    
                RES     <= ADD_RESULT;  
                RES_RDY <= '1'; --Add is in one clock cycle
            when "01" =>    -- SEL = 1, SUB
                RES     <= SUB_RESULT;
                RES_RDY <= '1'; -- Subtract result is in one clock cycle
                NEG     <= SUB_NEG;
            when "10" =>    -- SEL = 2, MULTIPLY
                RES     <= MUL_RESULT;
                RES_RDY  <= '1';
            when "11" =>    -- SEL = 3, DIVIDE
                RES     <= DIV_RESULT;
                RES_RDY <= DIV_RDY;
            when others =>  -- ELSE CATCH, X
                RES     <= "X";
                RES_RDY <= 'X';
        end case;
    end if;

end process MUX_OUTPUT;


-- Addition segment
-- Pad A and B inputs
ADD_RESULT <= std_logic_vector(unsigned(PAD_0 & A) + unsigned(PAD_0 & B));    

-- Subtraction segment   
-- Subtraction logic
SUB_OUTPUT : process (A, B, SEL) 
    variable SIGNED_TMP : std_logic_vector(WIDTH downto 0);
begin

    SIGNED_TMP := std_logic_vector(signed('0' & A) - signed('0' & B));
    if( SIGNED_TMP(WIDTH) = '1' ) then
        SUB_RESULT_UNPAD <= std_logic_vector(unsigned(not SIGNED_TMP) + 1);  -- Two's compliment if negative
        SUB_NEG <= '1';
    else
        SUB_RESULT_UNPAD <= SIGNED_TMP;
        SUB_NEG <= '0';
    end if;
    
    SUB_RESULT      <= PAD_0 & SUB_RESULT_UNPAD(WIDTH-1 downto 0);   
end process SUB_OUTPUT;

-- Multiplication segment
MULT_INST : MULT port map(
    A => A,
    B => B,
    Z => MUL_RESULT
);

-- Division segment


end Behavioral;
