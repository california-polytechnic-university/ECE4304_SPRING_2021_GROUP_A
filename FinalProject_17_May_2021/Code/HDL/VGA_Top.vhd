----------------------------------------------------------------------------------
-- Company: California State Polytechnic University Pomona, University of Illinois at Urbana-Champaign 
-- Engineer: Original by Dr. Eng: Mohamed El-Hadedy, now slightly modified
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

-- Top component for VGA system
entity VGA_Top is
    generic (
        strip_hpixels : positive := 800;   -- Value of pixels in a horizontal line = 800
        strip_vlines  : positive := 512;   -- Number of horizontal lines in the display = 521
        strip_hbp     : positive := 10;    -- Horizontal back porch = 144 (128 + 16)
        strip_hfp     : positive := 784;   -- Horizontal front porch = 784 (128+16 + 640)
        strip_vbp     : positive := 31;    -- Vertical back porch = 31 (2 + 29)
        strip_vfp     : positive := 511    -- Vertical front porch = 511 (2+29+ 480)
    );
    Port ( 
        CLK  : in std_logic;
        RST  : in std_logic;
           
        SW   : in std_logic_vector (1 downto 0);
           
        HSYNC: out std_logic;
        VSYNC: out std_logic; 
           
        HASH_224 : in std_logic_vector (223 downto 0);
        HASH_256 : in std_logic_vector (255 downto 0);
        HASH_384 : in std_logic_vector (383 downto 0);
        HASH_512 : in std_logic_vector (511 downto 0);
           
        RED  : out std_logic_vector (3 downto 0); 
        GREEN: out std_logic_vector (3 downto 0);
        BLUE : out std_logic_vector (3 downto 0)   
    );
end VGA_Top;

architecture Behavioral of VGA_Top is

    -- VGA controller component
    component VGA_VHDL 
        -- Note these numbers are different from a resolution to another (This is for 640x480) 
        generic(
            HPIXELS : positive := 800;   -- Value of pixels in a horizontal line = 800
            VLINES  : positive := 512;   -- Number of horizontal lines in the display = 521
            HBP     : positive := 10;   -- Horizontal back porch = 144 (128 + 16)
            HFP     : positive := 784;   -- Horizontal front porch = 784 (128+16 + 640)
            VBP     : positive := 31;    -- Vertical back porch = 31 (2 + 29)
            VFP     : positive := 511    -- Vertical front porch = 511 (2+29+ 480)
        );
        Port ( 
            CLK   : in  std_logic;
            CLK25 : in  std_logic;
            CLR   : in  std_logic;
            HSYNC : out std_logic;
            VSYNC : out std_logic;
            HC    : out std_logic_vector (9 downto 0);
            VC    : out std_logic_vector (9 downto 0);
            VIDON : out std_logic
        );
    end component;

    -- VGA sprite controller component
    component vga_initials 
        generic ( HBP:positive:=10; VBP:positive:=31; W:positive:=640; H:positive:= 16 );
        Port ( 
            CLK      : in  std_logic; 
            CLK25    : in  std_logic;
            RST      : in  std_logic; 
            VIDON    : in  std_logic;
            HC       : in  std_logic_vector (9  downto 0);
            VC       : in  std_logic_vector (9  downto 0);
            M        : in  std_logic_vector (639 downto 0);
            ROM_ADDR4: out std_logic_vector (4  downto 0);
            RED      : out std_logic_vector (3  downto 0); 
            GREEN    : out std_logic_vector (3  downto 0); 
            BLUE     : out std_logic_vector (3  downto 0)
        );
    end component;

    -- SHA3-224 hash sprite component
    component get_sprite_224
        Port ( 
            ADDR    : in  std_logic_vector (4 downto 0);
            HASH_224: in  std_logic_vector (223 downto 0);
            PROM    : out std_logic_vector (639 downto 0)
        );
    end component get_sprite_224;

    -- SHA3-256 hash sprite component
    component get_sprite_256 is
        Port ( 
            ADDR    : in  std_logic_vector (4 downto 0);
            HASH_256: in  std_logic_vector (255 downto 0);
            PROM    : out std_logic_vector (639 downto 0)
        );
    end component get_sprite_256;

    -- SHA3-384 hash sprite component
    component get_sprite_384 is
        Port ( 
            ADDR    : in  std_logic_vector (4 downto 0);
            HASH_384: in  std_logic_vector (383 downto 0);
            PROM    : out std_logic_vector (639 downto 0)
        );
    end component get_sprite_384;

    -- SHA3-512 hash sprite component
    component get_sprite_512 is
        Port ( 
            ADDR    : in  std_logic_vector (4 downto 0);
            HASH_512: in  std_logic_vector (511 downto 0);
            PROM    : out std_logic_vector (639 downto 0)
        );
    end component get_sprite_512;

    signal HC, VC   : std_logic_vector (9 downto 0); 
    signal VIDEO_ON : std_logic; 

    signal IMG, IMG_224, IMG_256, IMG_384, IMG_512 : std_logic_vector (639 downto 0); 
    signal ROM_ADDR4: std_logic_vector (4 downto 0); 

    signal CLK25_COUNT : integer;
    signal CLK25_FLAG  : std_logic;

begin

    -- Clock divider process for 1/4 of system clock (100 MHz / 4 = 25 MHz)
    CLK_25 : process (CLK, RST) begin
        if( RST = '1' ) then
            clk25_count <= 0;
        elsif ( rising_edge(CLK) ) then
            if( clk25_count = 3 ) then
                clk25_count <= 0;
                clk25_flag <= '1';
            else
                clk25_count <= clk25_count + 1;
                clk25_flag <= '0';
            end if;
        end if;
    end process CLK_25;

    -- VGA controller instantiation
    VGA_DRIVER: VGA_VHDL 
    generic map (
        HPIXELS => STRIP_HPIXELS,
        VLINES  => STRIP_VLINES,
        HBP     => STRIP_HBP,
        HFP     => STRIP_HFP,
        VBP     => STRIP_VBP,
        VFP     => STRIP_VFP
    )   
    port map (
        CLK   => CLK,
        CLK25 => CLK25_FLAG,
        CLR   => RST,
        HSYNC => HSYNC,
        VSYNC => VSYNC,
        HC    => HC, 
        VC    => VC, 
        VIDON => VIDEO_ON
    );
               
    -- VGA sprite controller instantiation               
    INIT: vga_initials 
    generic map ( 
        HBP => 10, 
        VBP => 31, 
        W   => 640, 
        H   => 32 
    )
    port map ( 
        CLK       => CLK,
        CLK25     => CLK25_FLAG,
        RST       => RST,
        VIDON     => VIDEO_ON,
        HC        => HC,
        VC        => VC,
        M         => IMG,
        ROM_ADDR4 => ROM_ADDR4,
        RED       => RED,
        GREEN     => GREEN,
        BLUE      => BLUE
    );

    -- SHA3-224 sprite instantiation
    SPRITE_224: get_sprite_224 
    port map (
        ADDR    => rom_addr4,
        HASH_224=> hash_224,
        PROM    => IMG_224
    );
    
    -- SHA3-256 sprite instantiation         
    SPRITE_256: get_sprite_256 
    port map (
        ADDR    => rom_addr4,
        HASH_256=> hash_256,
        PROM    => IMG_256
    );
    
    -- SHA3-384 sprite instantiation
    SPRITE_384: get_sprite_384 
    port map (
        ADDR    => rom_addr4,
        HASH_384=> hash_384,
        PROM    => IMG_384
    );
    
    -- SHA3-512 sprite instantiation
    SPRITE_512: get_sprite_512 
    port map (
        ADDR    => rom_addr4,
        HASH_512=> hash_512,
        PROM    => IMG_512
    );         

    -- SHA3 message output based on input switch mode
    IMG_SWITCH : process (CLK, RST, SW, IMG_224, IMG_256, IMG_384, IMG_512) begin
        if ( RST = '1' ) then
            IMG <= (others => '0');
        elsif ( rising_edge(CLK) ) then
            case SW is
                when "00" => IMG <= IMG_224;
                when "01" => IMG <= IMG_256;
                when "10" => IMG <= IMG_384;
                when "11" => IMG <= IMG_512;
            end case;
        end if;
    end process IMG_SWITCH;

end Behavioral;
