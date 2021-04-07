library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

entity UART_RX is
    port(
        CLK         : in  std_logic;
        RST         : in  std_logic; 
        RX_IN       : in  std_logic;
        DATAOUT     : out std_logic_vector(7 downto 0);
        DATAVALID   : out std_logic
    );
end UART_RX;
 
 
architecture rtl of UART_RX is

type state_type is (idle, start, demiStart, b0, b1, b2, b3, b4, b5, b6, b7);	     -- States of the FSM 
signal state : state_type := idle;													 -- Default state

signal RST_UART_counter : STD_LOGIC;										         -- Reset of the counter
signal UART_counter_internal : integer range 0 to 5210;					             -- Number of clk rising edges to increment counter
signal UART_counter : integer range 0 to 19;                                         -- Counter value

signal RxD_temp : STD_LOGIC;                                                         -- Temporary RxD between the two FF
signal RxD_sync : STD_LOGIC;                                                         -- RxD properly synchronized with 100 MHz clk
	
	
signal data_out   : STD_LOGIC_VECTOR (7 downto 0);
signal data_valid : STD_LOGIC;

signal clk_bounce:std_logic; 
signal count_time:std_logic_vector(31 downto 0); 

begin

    GEN: process(CLK, RST) begin 
        if (RST = '1') then 
            count_time <= (others =>'0');
            clk_bounce <= '0';
        elsif(rising_edge(clk)) then 
            if (count_time = 5000) then 
                clk_bounce <= not clk_bounce;
                count_time <= (others =>'0');
            else 
                count_time <= count_time + 1;
            end if; 
        end if; 
     end process; 

    D_flip_flop_1: process( CLK ) begin -- Clock crossing, first flip flop 
        if CLK = '1' and CLK'event then
            RxD_temp <= RX_IN;
        end if;
    end process;

    D_flip_flop_2: process( CLK ) begin -- Clock crossing, second flip flop
        if CLK = '1' and CLK'event then
            RxD_sync <= RxD_temp;
        end if;
    end process;

    doubleTickUART: process( CLK ) begin -- Counter
        if CLK = '1' and CLK'event then
           if ( (RST='1') or (RST_UART_counter = '1')) then
                UART_counter <= 0;
                UART_counter_internal <= 0;
           elsif (UART_counter_internal >= 5208) then 
                UART_counter <= (UART_counter + 1);
                UART_counter_internal <= 0;
           else
                UART_counter_internal <= UART_counter_internal + 1;
           end if;
        end if;
    end process;

    fsm:process( CLK, RST ) begin -- Finite state machine
    
        if CLK = '1' and CLK'event then
            if (RST = '1') then
                state <= idle;
                data_out <= "00000000";
                RST_UART_counter <= '1';
                data_valid <= '0';
            else
              case state is
                when idle => if RxD_sync = '0' then	     -- If in idle and low level detected on RxD_sync
                                state <= start;
                             end if;
                             data_valid <= '0';
    
                             RST_UART_counter <= '1';    -- Prevent from counting while in idle
                when start =>if (UART_counter = 1) then  -- If RxD_sync is low and half a period elapsed
                                state <= demiStart;
                            end if;
                            RST_UART_counter <= '0'; -- Begin counting
                            data_out <= "00000000";         -- Reset former output data      
                        --	data_valid <= '0';              -- Data is not valid 
                when demiStart => if (UART_counter = 3) then
                                    state <= b0;
                                    data_out(0) <= RxD_sync;	-- Acquisition bit 1 of 8
                                  end if;
                when b0 =>	if (UART_counter = 5) then
                                state <= b1;
                                data_out(1) <= RxD_sync;	-- Acquisition bit 2 of 8
                            end if;
                when b1 =>	if (UART_counter = 7) then
                                state <= b2;
                                data_out(2) <= RxD_sync;	-- Acquisition bit 3 of 8
                            end if;
                when b2 =>	if (UART_counter = 9) then
                                state <= b3;
                                data_out(3) <= RxD_sync;	-- Acquisition bit 4 of 8
                            end if;
                when b3 =>	if (UART_counter = 11) then
                                state <= b4;
                                data_out(4) <= RxD_sync;	-- Acquisition bit 5 of 8
                            end if;
                when b4 =>	if (UART_counter = 13) then
                                state <= b5;
                                data_out(5) <= RxD_sync;	-- Acquisition bit 6 of 8
                            end if;
                when b5 =>	if (UART_counter = 15) then
                                state <= b6;
                                data_out(6) <= RxD_sync;	-- Acquisition bit 7 of 8
                            end if;
                when b6 =>	if (UART_counter = 17) then
                                state <= b7;	
                                data_out(7) <= RxD_sync;	-- Acquisition bit 8 of 8
                            end if;
                when b7 =>	if (UART_counter = 19) then
                                state <= idle;              -- state <= idle
                        --     if (UART_counter_internal = 0) then 
                                data_valid <= '1';          -- Data becomes valid
                         --    else 
                        --        data_valid <= '0';
                        --     end if; 
                            end if;
                when others =>
                 state <= idle;
            end case;
           end if;
        end if;
    end process;
   
   DATAOUT  <= data_out;
   DATAVALID <= data_valid;
   
end rtl;
