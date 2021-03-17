LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY B2BCD IS
	GENERIC(
		N		:	INTEGER := 8;		--size of the binary input numbers in bits
		digits	:	INTEGER := 2);		--number of BCD digits to convert to
	PORT(
	    clk, reset: in std_logic;
		binary_in:	in std_logic_vector(N-1 downto 0);			
		bcd		 :	out std_logic_vector(digits*4-1 downto 0));	
END B2BCD;

ARCHITECTURE Behavioral OF B2BCD IS
    type states is (start, shift, done);
	signal state, state_next: states;
 
    signal binary, binary_next: std_logic_vector(N-1 downto 0);
    signal bcds, bcds_reg, bcds_next: std_logic_vector(digits*4-1 downto 0);
    signal bcds_out_reg, bcds_out_reg_next: std_logic_vector(digits*4-1 downto 0);
    signal shift_counter, shift_counter_next: natural range 0 to N;
begin
 
    process(clk, reset)
    begin
        if reset = '1' then
            binary <= (others => '0');
            bcds <= (others => '0');
            state <= start;
            bcds_out_reg <= (others => '0');
            shift_counter <= 0;
        elsif falling_edge(clk) then
            binary <= binary_next;
            bcds <= bcds_next;
            state <= state_next;
            bcds_out_reg <= bcds_out_reg_next;
            shift_counter <= shift_counter_next;
        end if;
    end process;
 
    convert:
    process(state, binary, binary_in, bcds, bcds_reg, shift_counter)
    begin
        state_next <= state;
        bcds_next <= bcds;
        binary_next <= binary;
        shift_counter_next <= shift_counter;
 
        case state is
            when start =>
                state_next <= shift;
                binary_next <= binary_in;
                bcds_next <= (others => '0');
                shift_counter_next <= 0;
            when shift =>
                if shift_counter = N then
                    state_next <= done;
                else
                    binary_next <= binary(N-2 downto 0) & 'L';
                    bcds_next <= bcds_reg(N-2 downto 0) & binary(N-1);
                    shift_counter_next <= shift_counter + 1;
                end if;
            when done =>
                state_next <= start;
        end case;
    end process;
    process(bcds) 
    begin
    if (bcds(7 downto 4) > 4) then
        bcds_reg(7 downto 4) <= bcds(7 downto 4) + 3  ;
    else
        bcds_reg(7 downto 4) <= bcds(7 downto 4);
    end if;
    if(bcds(3 downto 0) > 4) then 
        bcds_reg(3 downto 0) <= bcds(3 downto 0) + 3 ;
    else
        bcds_reg(3 downto 0) <= bcds(3 downto 0);
    end if;
    end process;
    bcds_out_reg_next <= bcds when state = done else
                         bcds_out_reg;
 
    bcd <= bcds_out_reg;

END Behavioral;

