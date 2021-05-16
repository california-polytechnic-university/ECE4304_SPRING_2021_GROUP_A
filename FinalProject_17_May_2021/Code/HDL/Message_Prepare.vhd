library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Message preparation component
entity Message_Prepare is
    Port ( 
        RAW_MSG : in std_logic_vector(1143 downto 0);
        SW      : in std_logic_vector(1 downto 0);        
        MSG_OUT : out std_logic_vector(1599 downto 0)
    );
end Message_Prepare;

architecture Behavioral of Message_Prepare is

    constant ZERO_224 : std_logic_vector(447 downto 0) := (others => '0');
    constant ZERO_256 : std_logic_vector(511 downto 0) := (others => '0');
    constant ZERO_384 : std_logic_vector(767 downto 0) := (others => '0');
    constant ZERO_512 : std_logic_vector(1023 downto 0) := (others => '0');

begin

    -- Mux for controlling the padded message based on SHA-3 mode.
    ASSIGNMENT : process (RAW_MSG, SW) begin
        case SW is
            when "00" => MSG_OUT <= RAW_MSG(1143 downto 0) & X"80" & ZERO_224;
            when "01" => MSG_OUT <= RAW_MSG(1143 downto 64) & X"80" & ZERO_256;
            when "10" => MSG_OUT <= RAW_MSG(1143 downto 320) & X"80" & ZERO_384;
            when "11" => MSG_OUT <= RAW_MSG(1143 downto 576) & X"80" & ZERO_512;
            when others => MSG_OUT <= (others => '0');
       end case;
    end process ASSIGNMENT;


end Behavioral;
