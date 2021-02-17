----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/15/2021 10:08:02 AM
-- Design Name: 
-- Module Name: top - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
  generic(
            top_IN_SIZE: integer := 5;
            top_WIDTH: integer := 16
            );
  Port (
            top_port_A : in std_logic_vector(top_IN_SIZE-1 downto 0);
            top_port_SEL: in std_logic_vector(integer(ceil(log2(real(2**(top_IN_SIZE-4)))))-1 downto 0);
            top_port_X : out std_logic_vector(2**(top_IN_SIZE-1)-1 downto 0)
         );
end top;

architecture Behavioral of top is

component Decoder_Nx2N
    generic(
        IN_SIZE : integer:= 5
    );
    Port ( 
        A   : in std_logic_vector(IN_SIZE-1 downto 0);
        X   : out std_logic_vector(2**IN_SIZE-1 downto 0)
    );
end component;

component Mux_Nx1
    generic(
        IN_SIZE : integer:= 5;
        WIDTH   : integer := 16
    );
    Port (
        N_A     : in std_logic_vector(2**IN_SIZE-1 downto 0);
        N_SEL   : in std_logic_vector(integer(ceil(log2(real(2**(IN_SIZE-4)))))-1 downto 0);
        N_X     : out std_logic_vector(WIDTH-1 downto 0)
    );
end component;
signal decoder_x: std_logic_vector(2**(top_IN_SIZE)-1 downto 0);

begin

DECODER_COMP: Decoder_Nx2N generic map (IN_SIZE => top_IN_SIZE)
                           port map (
                                        A => top_port_A,
                                        X(2**(top_IN_SIZE)-1 downto 0) => decoder_x  
                                        );
MUX_COMP: Mux_Nx1 generic map (IN_SIZE => 2**(top_IN_SIZE)-1, WIDTH => top_WIDTH)
                  port map (
                                N_A => decoder_x,
                                N_SEL => top_port_SEL,
                                N_X => top_port_X
                                );


end Behavioral;
