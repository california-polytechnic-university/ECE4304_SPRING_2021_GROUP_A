-- File Name: SHA3.vhd
-- Purpose  : State machine controller to run a padded message input through 24 rounds of permutations from Keccak_Permutation.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- SHA-3 component
entity SHA3 is
    Port ( 
        CLK : in std_logic;
        RST : in std_logic;
        GO  : in std_logic;
        RDY : in std_logic;
        DATA_IN : in std_logic_vector(1599 downto 0); 
        DATA_OUT : out std_logic_vector(1599 downto 0);
        FINISH : out std_logic
    );
end SHA3;

architecture Behavioral of SHA3 is

component Keccak_Permutation is
    Port ( 
        IOTA_CONST : in std_logic_vector(63 downto 0);
        DATA_IN     : in std_logic_vector(1599 downto 0);
        DATA_OUT    : out std_logic_vector(1599 downto 0)
    );
end component Keccak_Permutation;

    -- Declare IOTA constants as 2-d array that differs depending on permutation round
    type ARR is array(0 to 24, 63 downto 0) of std_logic;
    constant IOTA_CONSTANTS : ARR := (
                       X"0000000000000001", X"0000000000008082", X"800000000000808a",
                       X"8000000080008000", X"000000000000808b", X"0000000080000001",
                       X"8000000080008081", X"8000000000008009", X"000000000000008a",
                       X"0000000000000088", X"0000000080008009", X"000000008000000a",
                       X"000000008000808b", X"800000000000008b", X"8000000000008089",
                       X"8000000000008003", X"8000000000008002", X"8000000000000080",
                       X"000000000000800a", X"800000008000000a", X"8000000080008081",
                       X"8000000000008080", X"0000000080000001",X"8000000080008008",
                       X"0000000000000000");
                       
                       
    type state_type is (waiting, looping, done);            -- States of the FSM 
	signal STATE_REG, STATE_NEXT : state_type := waiting;	-- Default state

    signal loop_reg, loop_next : integer := 0; 
    signal CURRENT_VAL, OUT_VAL, NEXT_VAL, OUTPUT_VAL, FINAL_VAL : std_logic_vector(1599 downto 0);  
    signal IOTA_CONST_VECTOR : std_logic_vector(63 downto 0);

begin 

    -- Assign Iota constants to a vector for component input
    IOTA_GEN : for i in 0 to 63 generate
        IOTA_CONST_VECTOR(i) <= IOTA_CONSTANTS(loop_reg, i);
    end generate IOTA_GEN;

    -- KECCAK permutation component call
    KECCAK_F : Keccak_Permutation 
        port map ( 
            IOTA_CONST => IOTA_CONST_VECTOR,
            DATA_IN => CURRENT_VAL,
            DATA_OUT => OUT_VAL
    );

   -- State process
    STATE : process ( CLK, RST, STATE_NEXT ) begin
        if( rising_edge(CLK) )then
            if( RST = '1' ) then
                CURRENT_VAL <= DATA_IN; 
                loop_reg <= 0;  
                STATE_REG <= waiting;
                OUTPUT_VAL <= (others => '0'); 
            else
                CURRENT_VAL <= NEXT_VAL; 
                loop_reg <= loop_next;
                STATE_REG <= STATE_NEXT;
                OUTPUT_VAL <= FINAL_VAL;
            end if;
        end if; 
    end process STATE;
    
    -- Next-state logic and output logic
    COMB : process ( CLK, RST, STATE_REG, GO, RDY, CURRENT_VAL, LOOP_REG, OUT_VAL, DATA_IN, OUTPUT_VAL ) begin
        STATE_NEXT <= STATE_REG;
        NEXT_VAL <= CURRENT_VAL;
        LOOP_NEXT <= LOOP_REG;
        FINAL_VAL <= OUTPUT_VAL;
        
        case STATE_REG is
            when waiting => 
                if( GO = '1' ) then
                    LOOP_NEXT <= 0; 
                    NEXT_VAL <= DATA_IN;
                    STATE_NEXT <= looping;
                else
                    STATE_NEXT <= waiting;
                end if;
            when looping =>
                if(loop_reg = 24) then  -- Keep looping until 24 permutations are done, finish. 
                    LOOP_NEXT <= 0;
                    STATE_NEXT <= done;
                    FINAL_VAL <= CURRENT_VAL;
                else
                    LOOP_NEXT <= loop_reg + 1; 
                    NEXT_VAL <= OUT_VAL; 
                    STATE_NEXT <= looping;
                end if;
            when done =>
                if( RDY = '1' ) then
                    STATE_NEXT <= waiting;
                else
                    STATE_NEXT <= done;
                end if;
        end case;
    end process COMB;
    
    FINISH <= '1' when (STATE_REG = done) else '0';
    DATA_OUT <= OUTPUT_VAL;
    
end Behavioral;
