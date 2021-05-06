----------------------------------------------------------------------------------
-- Company: California State Polytechnic University Pomona, University of Illinois at Urbana-Champaign 
-- Engineer: Dr. Eng: Mohamed El-Hadedy
-- 
-- Create Date: 11/06/2019 04:54:07 PM
-- Design Name: 
-- Module Name: vga_initials_top - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.math_real.all; 
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_initials_top is
 generic (strip_hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
          strip_vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
          strip_hbp     :positive:= 10;   -- Horizontal back porch = 144 (128 + 16)
          strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          strip_vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
         );
    Port ( clk  : in STD_LOGIC;
           rst  : in STD_LOGIC;
           sw   : in STD_LOGIC_VECTOR (7 downto 0);
           hsync: out STD_LOGIC;
           vsync: out STD_LOGIC; 
           red  : out STD_LOGIC_VECTOR (2 downto 0); 
           green: out STD_LOGIC_VECTOR (2 downto 0);
           blue : out STD_LOGIC_VECTOR (2 downto 0)   
         );
end vga_initials_top;

architecture Behavioral of vga_initials_top is



component VGA_VHDL 
    -- Note these numbers are different from a resolution to another (This is for 640x480) 
    generic(hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
            vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
            hbp     :positive:= 10;   -- Horizontal back porch = 144 (128 + 16)
            hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
            vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
            vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
           );
    Port ( clk   : in  STD_LOGIC;
           clr   : in  STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           hc    : out STD_LOGIC_VECTOR (9 downto 0);
           vc    : out STD_LOGIC_VECTOR (9 downto 0);
           vidon : out STD_LOGIC
        );
end component;

component clk_wiz_0 
     port (
           clk25  : out std_logic; 
           reset  : in  std_logic; 
           locked : out std_logic;
           clk_in1: in  std_logic
          );
end component; 



component vga_initials 
    generic (hbp:positive:=10; vbp:positive:=31; W:positive:=640; H:positive:= 16 );
    Port ( 
           clk      : in  STD_LOGIC; 
           rst      : in  STD_LOGIC; 
           vidon    : in  STD_LOGIC;
           hc       : in  STD_LOGIC_VECTOR (9  downto 0);
           vc       : in  STD_LOGIC_VECTOR (9  downto 0);
           M        : in  STD_LOGIC_VECTOR (639 downto 0);
           SW       : in  STD_LOGIC_VECTOR (7  downto 0);
           rom_addr4: out STD_LOGIC_VECTOR (3  downto 0);
           red      : out STD_LOGIC_VECTOR (2  downto 0); 
           green    : out STD_LOGIC_VECTOR (2  downto 0); 
           blue     : out STD_LOGIC_VECTOR (2  downto 0)
         );
end component;


component get_sprite
    Port ( 
        ADDR: in std_logic_vector(3 downto 0);
        HASH_256: in std_logic_vector(255 downto 0);
        PROM: out std_logic_vector(639 downto 0)
    );
end component;


signal clk25MHz       :std_logic; 
signal locked_pll     :std_logic; 
signal steady_clk25MHz:std_logic;

signal hc, vc:std_logic_vector(9 downto 0); 
signal video_on :std_logic; 

signal IMG:std_logic_vector(639 downto 0); 
signal rom_addr4:std_logic_vector(3 downto 0); 

signal hash: std_logic_vector(255 downto 0):= "0011101010011000010111011010011101001111111000100010010110110010000001000101110000010111001011010110101111010011100100001011110110000101010111110000100001101110001111101001110101010010010110110100011010111111111000100100010100010001010000110001010100110010";

begin
CLK_GEN_PLL: clk_wiz_0 port map ( 
                                   clk25   => clk25MHz, 
                                   reset   => rst,
                                   locked  => locked_pll,
                                   clk_in1 => clk
                                );
steady_clk25MHz <= locked_pll and clk25MHz;




VGA_DRIVER: VGA_VHDL 
                     generic map (
                                  hpixels => strip_hpixels,
                                  vlines  => strip_vlines,
                                  hbp     => strip_hbp,
                                  hfp     => strip_hfp,
                                  vbp     => strip_vbp,
                                  vfp     => strip_vfp
                        
                                  )   
                     port map (
                               clk   => steady_clk25MHz,
                               clr   => rst,
                               hsync => hsync,
                               vsync => vsync,
                               hc    => hc, 
                               vc    => vc, 
                               vidon => video_on
                              );
                              
INIT: vga_initials 
    generic map ( hbp =>10, 
                  vbp =>31, 
                  W   =>640, 
                  H   =>16 
                )
    Port map ( 
                   clk       => steady_clk25MHz,
                   rst       => rst,
                   vidon     => video_on,
                   hc        => hc,
                   vc        => vc,
                   M         => IMG,
                   SW        => sw,
                   rom_addr4 => rom_addr4,
                   red       =>  red,
                   green     =>  green,
                   blue      =>  blue
         );
         
SPRITE: get_sprite port map(
        ADDR => rom_addr4,
        HASH_256 => hash,
        PROM => IMG
);
         

end Behavioral;
