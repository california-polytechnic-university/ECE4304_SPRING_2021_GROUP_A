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
          strip_hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
          strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          strip_vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
         );
    Port ( clk  : in STD_LOGIC;
           rst  : in STD_LOGIC;
           redC: in STD_LOGIC_VECTOR(3 downto 0);
           blueC: in STD_LOGIC_VECTOR(3 downto 0);
           greenC: in STD_LOGIC_VECTOR(3 downto 0);
           hsync: out STD_LOGIC;
           vsync: out STD_LOGIC; 
           rx   : in std_logic;
           red  : out STD_LOGIC_VECTOR (3 downto 0); 
           green: out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0)
         );
end vga_initials_top;

architecture Behavioral of vga_initials_top is



component VGA_VHDL 
    -- Note these numbers are different from a resolution to another (This is for 640x480) 
    generic(hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
            vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
            hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
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
           clk_in1: in  std_logic;
           sys_clk: out std_logic
          );
end component; 

component PROM_IMG
    generic(DEPTH    :positive:= 16; 
            DATA_SIZE:positive:= 32
           );
    Port   ( addr    : in  STD_LOGIC_VECTOR (integer(ceil(log2(real(DEPTH))))-1 downto 0);
             PROM_OP : out STD_LOGIC_VECTOR (DATA_SIZE-1 downto 0)
           );
end component;


component vga_initials 
    generic (hbp:positive:=144; vbp:positive:=31; W:positive:=32; H:positive:= 16 );
    Port ( 
           clk      : in  STD_LOGIC; 
           rst      : in  STD_LOGIC; 
           vidon    : in  STD_LOGIC;
           hc       : in  STD_LOGIC_VECTOR (9  downto 0);
           vc       : in  STD_LOGIC_VECTOR (9  downto 0);
           M        : in  STD_LOGIC_VECTOR (31 downto 0);
           UART       : in  STD_LOGIC_VECTOR (7  downto 0);
           redC: in STD_LOGIC_VECTOR(3 downto 0);
           blueC: in STD_LOGIC_VECTOR(3 downto 0);
           greenC: in STD_LOGIC_VECTOR(3 downto 0);
           rom_addr4: out STD_LOGIC_VECTOR (3  downto 0);
           red      : out STD_LOGIC_VECTOR (3  downto 0); 
           green    : out STD_LOGIC_VECTOR (3  downto 0); 
           blue     : out STD_LOGIC_VECTOR (3  downto 0);
           testled  : out STD_LOGIC_VECTOR(2 downto 0)
         );
end component;

component UART_RX is
    port(
        CLK         : in  std_logic;
        RST         : in  std_logic; 
        RX_IN       : in  std_logic;
        DATAOUT     : out std_logic_vector(7 downto 0);
        DATAVALID   : out std_logic
    );
end component UART_RX;

signal clk25MHz       :std_logic; 
signal sys_clk          : std_logic;
signal locked_pll     :std_logic; 
signal steady_clk25MHz:std_logic;
signal steady_clk100MHz:std_logic;

signal hc, vc:std_logic_vector(9 downto 0); 
signal video_on :std_logic; 

signal IMG:std_logic_vector(31 downto 0); 
signal rom_addr4:std_logic_vector(3 downto 0); 

signal rx_data, pos_data : std_logic_vector(7 downto 0) := (others => '0');
signal rx_valid : std_logic;

begin

UART_INST : UART_RX port map(
        CLK         => steady_clk100MHz,
        RST         => rst,
        RX_IN       => rx,
        DATAOUT     => rx_data,
        DATAVALID   => rx_valid
);

UART_VALID : process (steady_clk100MHz, rst) begin

    if(rst = '1') then
        pos_data <= (others => '0');
    elsif( rising_edge(steady_clk100MHz) ) then
        if(rx_valid = '1') then
            pos_data <= rx_data;
        end if;
    end if;

end process UART_VALID;

CLK_GEN_PLL: clk_wiz_0 port map ( 
                                   clk25   => clk25MHz, 
                                   reset   => rst,
                                   locked  => locked_pll,
                                   clk_in1 => clk,
                                   sys_clk => sys_clk
                                );
steady_clk25MHz <= locked_pll and clk25MHz;
steady_clk100MHz <= locked_pll and sys_clk;



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
    generic map ( hbp =>144, 
                  vbp =>31, 
                  W   =>32, 
                  H   =>16 
                )
    Port map ( 
                   clk       => steady_clk25MHz,
                   rst       => rst,
                   vidon     => video_on,
                   hc        => hc,
                   vc        => vc,
                   M         => IMG,
                   UART     => pos_data,
                   redC     => redC,
                   greenC     => greenC,
                   blueC     => blueC,
                   rom_addr4 => rom_addr4,
                   red       =>  red,
                   green     =>  green,
                   blue      =>  blue,
                   testled => testled
         );
         
PROM: PROM_IMG generic map (
                            DEPTH     => 16 ,
                            DATA_SIZE => 32
                            )
               port map (
                          addr    => rom_addr4,
                          PROM_OP => IMG
                        );         
         

end Behavioral;
