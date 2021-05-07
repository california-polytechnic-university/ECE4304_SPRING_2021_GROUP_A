----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2021 04:24:59 PM
-- Design Name: 
-- Module Name: SHA3_System_Top - Behavioral
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

entity SHA3_System_Top is
    Port ( 
        TOP_CLK : in std_logic;
        TOP_RST : in std_logic;
        
        -- VGA component ports
        TOP_HSYNC: out STD_LOGIC;
        TOP_VSYNC: out STD_LOGIC; 
        TOP_RED  : out STD_LOGIC_VECTOR (2 downto 0); 
        TOP_GREEN: out STD_LOGIC_VECTOR (2 downto 0);
        TOP_BLUE : out STD_LOGIC_VECTOR (2 downto 0);   
        
        -- SHA-3 component ports
        TOP_GO  : in std_logic;
        TOP_RDY : in std_logic;
        TOP_DATA_IN : in std_logic_vector(1599 downto 0); 
        TOP_DATA_OUT : out std_logic_vector(1599 downto 0);
        TOP_FINISH : out std_logic
    );
end SHA3_System_Top;

architecture Behavioral of SHA3_System_Top is

--component clk_wiz_0 
--     Port (
--           CLK25  : out std_logic; 
--           CLK100 : out std_logic;
--           RESET  : in  std_logic; 
--           LOCKED : out std_logic;
--           CLK_IN1: in  std_logic
--    );
--end component; 

component vga_initials_top is
 generic (strip_hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
          strip_vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
          strip_hbp     :positive:= 10;   -- Horizontal back porch = 144 (128 + 16)
          strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          strip_vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
         );
    Port ( 
           clk  : in STD_LOGIC;
           rst  : in STD_LOGIC;
           --sw   : in STD_LOGIC_VECTOR (7 downto 0);
           HASH : in std_logic_vector(255 downto 0);
           hsync: out STD_LOGIC;
           vsync: out STD_LOGIC; 
           red  : out STD_LOGIC_VECTOR (2 downto 0); 
           green: out STD_LOGIC_VECTOR (2 downto 0);
           blue : out STD_LOGIC_VECTOR (2 downto 0)   
         );
end component vga_initials_top;

component Permutation_Loop is
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;
        GO  : in std_logic;
        RDY : in std_logic;
        DATA_IN : in std_logic_vector(1599 downto 0); 
        DATA_OUT : out std_logic_vector(1599 downto 0);
        FINISH : out std_logic
    );
end component Permutation_Loop;

    signal SHA3_Output : std_logic_vector(1599 downto 0);
    
    signal CLK_25, CLK_100  : std_logic;
    signal LOCK_PLL         : std_logic; 
    signal STEADY_CLK25, STEADY_CLK100 : std_logic;

begin

    VGA : vga_initials_top
    port map(
        CLK     => TOP_CLK,
        RST     => TOP_RST,
        HASH    => SHA3_Output(1599 downto 1344),
        HSYNC   => TOP_HSYNC,
        VSYNC   => TOP_VSYNC,
        RED     => TOP_RED,
        GREEN   => TOP_GREEN,
        BLUE    => TOP_BLUE
    );
    
    SHA_3 : Permutation_Loop
    port map(
        CLK     => TOP_CLK,
        RST     => TOP_RST,
        GO      => TOP_GO,
        RDY     => TOP_RDY,
        DATA_IN => TOP_DATA_IN,
        DATA_OUT=> SHA3_Output,
        FINISH  => TOP_FINISH
    );
    
    TOP_DATA_OUT <= SHA3_Output;

end Behavioral;
