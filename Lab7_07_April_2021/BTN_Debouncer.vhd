library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity BTN_Debouncer is
    Port ( 
        CLK     : in std_logic;
        RST     : in std_logic;
        BTN_IN  : in std_logic;
        BTN_OUT : out std_logic
    );
end BTN_Debouncer;

architecture Behavioral of BTN_Debouncer is

component Counter is
    generic(
        COUNT_VAL : integer := 131071   -- Equivalent to (16 downto 0) <= (others => '1')
    );
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;
        
        VAL : out std_logic_vector(integer(ceil(log2(real(COUNT_VAL))))-1 downto 0);
        TICK: out std_logic
    );
end component Counter;

    type state_type is (zero, wait1_1, wait1_2, wait1_3, one, wait0_1, wait0_2, wait0_3);   -- States of the FSM 
	signal STATE_REG, STATE_NEXT : state_type := zero;									    -- Default state
    
    signal TICK_10MS : std_logic; 

begin

    COUNT_10MS : Counter
    generic map(
        COUNT_VAL   => 1000000   -- 10ms
    )
    port map( 
        CLK     => CLK,
        RST     => RST,
        VAL     => open,
        TICK    => TICK_10MS
    );

    -- State process
    STATE : process ( CLK, RST, STATE_NEXT ) begin
        if( rising_edge(CLK) )then
            if( RST = '1' ) then
                STATE_REG <= zero;
            else
                STATE_REG <= STATE_NEXT;
            end if;
        end if; 
    end process STATE;
    
    -- Next-state logic and output logic
    COMB : process ( CLK, RST, STATE_REG, BTN_IN, TICK_10MS ) begin
        STATE_NEXT <= STATE_REG;
        BTN_OUT <= '0';
        
        case STATE_REG is
            when zero   =>   
                if ( BTN_IN = '1' ) then
                    STATE_NEXT <= wait1_1;
                end if;
            when wait1_1 =>
                if( BTN_IN = '0' ) then
                    STATE_NEXT <= zero;
                else
                    if( TICK_10MS = '1' ) then
                        STATE_NEXT <= wait1_2;
                    end if;
                end if;
            when wait1_2 =>
                if( BTN_IN = '0' ) then
                    STATE_NEXT <= zero;
                else
                    if( TICK_10MS = '1' ) then
                        STATE_NEXT <= wait1_3;
                    end if;
                end if;            
            when wait1_3 =>
                 if( BTN_IN = '0' ) then
                    STATE_NEXT <= zero;
                else
                    if( TICK_10MS = '1' ) then
                        STATE_NEXT <= one;
                    end if;
                end if;           
            when one =>
                BTN_OUT <= '1';
                if( BTN_IN = '0' ) then
                    STATE_NEXT <= wait0_1;
                end if;
            when wait0_1 =>
                BTN_OUT <= '1';
                if( BTN_IN = '1') then
                    STATE_NEXT <= one;
                else
                    if( TICK_10MS = '1' )  then
                        STATE_NEXT <= wait0_2; 
                    end if;
                end if;
            when wait0_2 =>
                BTN_OUT <= '1';
                if( BTN_IN = '1') then
                    STATE_NEXT <= one;
                else
                    if( TICK_10MS = '1' )  then
                        STATE_NEXT <= wait0_3; 
                    end if;
                end if;
            when wait0_3 =>
                BTN_OUT <= '1';
                if( BTN_IN = '1') then
                    STATE_NEXT <= one;
                else
                    if( TICK_10MS = '1' )  then
                        STATE_NEXT <= zero; 
                    end if;
                end if;
        end case;
    end process COMB;
    
end Behavioral;
