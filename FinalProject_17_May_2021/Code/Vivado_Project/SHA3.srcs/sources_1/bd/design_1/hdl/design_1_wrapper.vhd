--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
--Date        : Sat May 15 16:27:20 2021
--Host        : K-ANI running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    AN_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    BLUE_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    CAG_0 : out STD_LOGIC_VECTOR ( 6 downto 0 );
    DP_0 : out STD_LOGIC;
    GREEN_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    HSYNC_0 : out STD_LOGIC;
    RED_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SW_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    VSYNC_0 : out STD_LOGIC;
    rx_0 : in STD_LOGIC;
    sys_clk : in STD_LOGIC;
    sys_rst : in STD_LOGIC;
    tx_0 : out STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    sys_rst : in STD_LOGIC;
    sys_clk : in STD_LOGIC;
    rx_0 : in STD_LOGIC;
    tx_0 : out STD_LOGIC;
    VSYNC_0 : out STD_LOGIC;
    BLUE_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    GREEN_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    RED_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    HSYNC_0 : out STD_LOGIC;
    AN_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    DP_0 : out STD_LOGIC;
    SW_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    CAG_0 : out STD_LOGIC_VECTOR ( 6 downto 0 )
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      AN_0(7 downto 0) => AN_0(7 downto 0),
      BLUE_0(3 downto 0) => BLUE_0(3 downto 0),
      CAG_0(6 downto 0) => CAG_0(6 downto 0),
      DP_0 => DP_0,
      GREEN_0(3 downto 0) => GREEN_0(3 downto 0),
      HSYNC_0 => HSYNC_0,
      RED_0(3 downto 0) => RED_0(3 downto 0),
      SW_0(1 downto 0) => SW_0(1 downto 0),
      VSYNC_0 => VSYNC_0,
      rx_0 => rx_0,
      sys_clk => sys_clk,
      sys_rst => sys_rst,
      tx_0 => tx_0
    );
end STRUCTURE;
