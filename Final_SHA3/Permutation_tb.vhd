library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Permutation_tb is
--  Port ( );
end Permutation_tb;

architecture Behavioral of Permutation_tb is

component Permutation is
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;
        DATA_IN     : in std_logic_vector(1599 downto 0);
        DATA_IN_DONE: in std_logic;
        DATA_OUT    : out std_logic_vector(24 downto 0)
    );
end component Permutation;

signal TB_CLK, TB_RST : std_logic := '0';
signal TB_DATA_IN : std_logic_vector(1599 downto 0);
signal TB_DATA_IN_DONE : std_logic;
signal TB_DATA_OUT : std_logic_vector(24 downto 0);

constant clock_period : time := 10ns;

begin

    UUT: Permutation 
    port map(
        CLK => TB_CLK,
        RST => TB_RST,
        DATA_IN => TB_DATA_IN,
        DATA_IN_DONE => TB_DATA_IN_DONE,
        DATA_OUT => TB_DATA_OUT
    );

    CLK_GEN : process begin
        wait for clock_period;
        TB_CLK <= not TB_CLK;
    end process CLK_GEN;

    UUT_TB : process 
        variable TEST_COMBO : std_logic_vector(99 downto 0) := "1100010101010101011100110110001010101010101110011011000101010101010111001101100010101010101011100110";
        variable TEST_COMBO2 : std_logic_vector(99 downto 0) := "1100110001010100010011111110110011001001000001011100100110010000010100000001000010000101011101011110";
    begin
        TB_DATA_IN <= TEST_COMBO & TEST_COMBO2 & TEST_COMBO2 & TEST_COMBO & TEST_COMBO & TEST_COMBO2 & TEST_COMBO & TEST_COMBO2 & TEST_COMBO & TEST_COMBO2 & TEST_COMBO2 & TEST_COMBO2 & TEST_COMBO & TEST_COMBO & TEST_COMBO2 & TEST_COMBO2;
        wait;
    end process;
    

end Behavioral;
