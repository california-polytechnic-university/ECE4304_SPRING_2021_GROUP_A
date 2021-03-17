library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DIV_tb is
    generic(
        WIDTH_TB : integer:=4
    );
end DIV_tb;

architecture Behavioral of DIV_tb is

component DIV is
    generic(
        WIDTH_DIV : integer := 4    -- Input width
    );
    Port ( 
        -- Inputs --
        CLK_DIV : in std_logic;
        RST_DIV : in std_logic;
        A_DIV   : in std_logic_vector(WIDTH_DIV-1 downto 0);
        B_DIV   : in std_logic_vector(WIDTH_DIV-1 downto 0);
        -- Outputs --
        Z_DIV   : out std_logic_vector(WIDTH_DIV-1 downto 0);
        RDY_DIV : out std_logic;    -- Flag when division is finished
        ERR_DIV : out std_logic    -- Flag when divide by 0 occurs
    );
end component DIV;

signal CLK_TB : std_logic := '0';
signal RST_TB : std_logic := '0';
signal IN_A_TB : std_logic_vector(WIDTH_TB-1 downto 0);
signal IN_B_TB : std_logic_vector(WIDTH_TB-1 downto 0);
signal Z_TB : std_logic_vector(WIDTH_TB-1 downto 0);
signal RDY_TB : std_logic;
signal ERR_TB : std_logic;

constant clock_period : time:=10ns;

begin

UUT: DIV 
generic map(
    WIDTH_DIV => WIDTH_TB
)
port map(
    CLK_DIV => CLK_TB,
    RST_DIV => RST_TB,
    A_DIV   => IN_A_TB,
    B_DIV   => IN_B_TB,
    Z_DIV   => Z_TB,
    RDY_DIV => RDY_TB,
    ERR_DIV => ERR_TB
);

CLK_GEN : process begin

    wait for clock_period / 2;
    CLK_TB <= not CLK_TB;

end process CLK_GEN;

UUT_TB : process begin
    RST_TB <= '1';
    wait for clock_period;
    RST_TB <= '0';

    for i in 0 to 2**WIDTH_TB-1 loop
        for j in 0 to 2**WIDTH_TB-1 loop
            IN_A_TB <= std_logic_vector(to_unsigned(i, IN_A_TB'length));
            IN_B_TB <= std_logic_vector(to_unsigned(j, IN_B_TB'length));
            wait for clock_period * 10;
        end loop;
    end loop;   
    wait;

end process UUT_TB;

end Behavioral;
