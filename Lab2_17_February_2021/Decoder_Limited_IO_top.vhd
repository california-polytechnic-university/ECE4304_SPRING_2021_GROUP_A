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

entity Decoder_Limited_IO is
  generic(
            TOP_IN_SIZE: integer:= 5;
            TOP_WIDTH: integer  := 16
            );
  Port (
            TOP_A  : in std_logic_vector (TOP_IN_SIZE-1 downto 0);
            TOP_SEL: in std_logic_vector (integer(ceil(log2(real(2**TOP_IN_SIZE / TOP_WIDTH))))-1 downto 0);
            TOP_X  : out std_logic_vector(TOP_WIDTH-1 downto 0)
         );
end Decoder_Limited_IO;

architecture Behavioral of Decoder_Limited_IO is

-- Call Nx2^N Decoder
component Decoder_Nx2N
    generic(
        IN_SIZE : integer:= 5
    );
    Port ( 
        A   : in std_logic_vector(IN_SIZE-1 downto 0);
        X   : out std_logic_vector(2**IN_SIZE-1 downto 0)
    );
end component Decoder_Nx2N;

-- Call Nbit_Nx1 Mux
component Mux_Nbit_Nx1
    generic(
        IN_SIZE : integer:= 5;
        WIDTH   : integer := 16
    );
    Port (
        N_A     : in std_logic_vector(2**IN_SIZE-1 downto 0);
        N_SEL   : in std_logic_vector(integer(ceil(log2(real(2**(IN_SIZE-4)))))-1 downto 0);
        N_X     : out std_logic_vector(WIDTH-1 downto 0)
    );
end component Mux_Nbit_Nx1;

-- Output of DECODER_COMP
signal DECODER_X: std_logic_vector(2**(top_IN_SIZE)-1 downto 0);

begin

    DECODER_COMP: Decoder_Nx2N 
    generic map (
        IN_SIZE => top_IN_SIZE
    )
    port map (
        A   => TOP_A,
        X   => DECODER_X 
    );
    
    MUX_COMP: Mux_Nbit_Nx1 
    generic map (
        IN_SIZE => top_IN_SIZE, 
        WIDTH => top_WIDTH
    )
    port map (
        N_A     => DECODER_X,
        N_SEL   => TOP_SEL,
        N_X     => TOP_X
    );

end Behavioral;
