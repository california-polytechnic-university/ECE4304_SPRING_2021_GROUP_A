----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2021 01:56:20 PM
-- Design Name: 
-- Module Name: TOP - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- TODO AN CYCLE TO 8 BITS INSTEAD OF 4 FIX CONSTRAINTS
entity TOP is
    Port ( 
        FPGA_CLK: in std_logic;
        RST_TOP: in std_logic;
        IN_A: in std_logic_vector(3 downto 0);
        IN_B: in std_logic_vector(3 downto 0);
        SEL_A: in std_logic;
        SEL_B: in std_logic;
        SEL_ALU: in std_logic_vector(1 downto 0);
    
        AN_CYCLE_TOP: out std_logic_vector(7 downto 0);
        CURRENT_CAG: out std_logic_vector(6 downto 0);
        RESULT_NEG: out std_logic
    );
end TOP;

architecture Behavioral of TOP is
-- SIGNALS ---------------------------------------------------------                               

signal SLOW_CLK_SIGNAL: std_logic;
signal REG_A, REG_B: std_logic_vector(7 downto 0) := (others => '0');     -- two diigt BCD (8 bits) version of the HEX input 

signal DISP_A, DISP_B, DISP_CH, DISP_CL: std_logic_vector(3 downto 0) := (others => '0');    -- BCD or lower half of two digit BCD that will be converted to CAG form

signal SEL_4X1: std_logic_vector(1 downto 0) := (others =>'0'); -- Select for 4x1 mux which comes from the CLK divider
signal OUT_4X1: std_logic_vector(3 downto 0) := (others =>'0'); -- Output from 4x1 mux which is converted to CAG and read by 7segs
signal OUT_ALU: std_logic_vector(7 downto 0);

-- COMPONENTS-------------------------------------------------------
component CLK_DIVIDER
    Port ( 
        SYS_CLK: in std_logic;
        RST_SS: in std_logic;
        SLOW_CLK: out std_logic;
        AN_CYCLE: out std_logic_vector(7 downto 0);
        MUX_CYCLE: out std_logic_vector(1 downto 0)
    );
end component;

component MUX2X1
    Port ( 
        MUX_HEX: in std_logic_vector(3 downto 0);
        MUX_BCD: in std_logic_vector(3 downto 0);
        MUX_S: in std_logic;
        MUX_OUT: out std_logic_vector(3 downto 0)
    );
end component;

component MUX4X1
    Port (         
        MUX_A: in std_logic_vector(3 downto 0);
        MUX_B: in std_logic_vector(3 downto 0);
        MUX_CH: in std_logic_vector(3 downto 0);
        MUX_CL: in std_logic_vector(3 downto 0);
        MUX_S: in std_logic_vector(1 downto 0);
        MUX_OUT: out std_logic_vector(3 downto 0)
    );
end component;
component SS_DECODER
    Port ( 
        DECODER_IN: in std_logic_vector(3 downto 0);
        DECODER_OUT: out std_logic_vector(6 downto 0)   
    );
end component;

component ALU is
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
end component ALU;

begin
-- Process --------------------------------------------------------

process(IN_A, IN_B)
begin
    REG_A <= (others => '0');
    REG_B <= (others => '0');
    if to_integer(unsigned(IN_A)) > 9 then      -- If HEX input A greater than 9
        REG_A <= IN_A + "00000110";            
    else
        REG_A(3 downto 0) <= IN_A;
    end if;   
    if to_integer(unsigned(IN_B)) > 9 then      -- If HEX input B greater than 9
        REG_B <= IN_B + "00000110";
    else
        REG_B(3 downto 0) <= IN_B;
    end if;                   
end process;

-- PORT MAPS-------------------------------------------------------
CLK_MAP: CLK_DIVIDER
    port map(
        SYS_CLK => FPGA_CLK,
        RST_SS => RST_TOP,
        SLOW_CLK => SLOW_CLK_SIGNAL,
        AN_CYCLE => AN_CYCLE_TOP,
        MUX_CYCLE => SEL_4X1
    );
 

MUX_A: MUX2X1
    port map(
        MUX_HEX => IN_A,
        MUX_BCD => REG_A(3 downto 0),
        MUX_S => SEL_A,
        MUX_OUT => DISP_A
    );

MUX_B: MUX2X1
    port map(
        MUX_HEX => IN_B,
        MUX_BCD => REG_B(3 downto 0),
        MUX_S => SEL_B,
        MUX_OUT => DISP_B
    );

DISPLAY_MUX: MUX4X1
    port map(
        MUX_A => DISP_A,
        MUX_B => DISP_B,
        MUX_CH => DISP_CH,
        MUX_CL => DISP_CL,
        MUX_S => SEL_4X1,
        MUX_OUT => OUT_4X1   
    );

GET_CAG: SS_DECODER
    port map(
        DECODER_IN => OUT_4X1,
        DECODER_OUT => CURRENT_CAG
    );    

ALU_INST : ALU
    generic map(
        WIDTH => 4
    )
    port map ( 
        CLK => FPGA_CLK,
        RST => RST_TOP,
        A   => REG_A(3 downto 0),
        B   => REG_B(3 downto 0),
        SEL => SEL_ALU,
        
        RES => OUT_ALU,
        NEG => RESULT_NEG
    );

DISP_CH <= OUT_ALU(7 downto 4);
DISP_CL <= OUT_ALU(3 downto 0);
end Behavioral;
