library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity DIV is
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
end DIV;

architecture Behavioral of DIV is

-- State Declaration --
    type states is ( load, restore, n_check, finish );
-- End State Declaration --

-- Signal Declaration --
    -- FSM signals
    signal ps_state : states := load;
    signal ns_state : states;
    
    -- Internal signals
    signal N, N_NXT : std_logic_vector(integer(ceil(log2(real(WIDTH_DIV)))) downto 0);
    signal A, A_NXT : std_logic_vector(WIDTH_DIV-1 downto 0);
    signal M, M_NXT : std_logic_vector(WIDTH_DIV-1 downto 0);
    signal Q, Q_NXT : std_logic_vector(WIDTH_DIV-1 downto 0);
    
    -- Signals for restoration segment
    signal Q_RESTORE : std_logic_vector(WIDTH_DIV-1 downto 0);
    signal A_RESTORE : std_logic_vector(WIDTH_DIV-1 downto 0);
    
    -- Internal output signals
    signal RDY_FLAG, RDY_FLAG_NXT : std_logic;
    signal OUTPUT, OUTPUT_OLD : std_logic_vector(WIDTH_DIV-1 downto 0) := (others => '0');
-- End Signal Declaration

begin

-- FSM Logic --

    -- FSM Register/Update state process --
    FSM_CLK : process (CLK_DIV, RST_DIV) begin
        if(rising_edge(CLK_DIV)) then
            if(RST_DIV = '1') then
                ps_state <= load;
                N <= (others => '0');
                A <= (others => '0');
                M <= (others => '0');
                Q <= (others => '0');
                OUTPUT_OLD <= (others => '0');
            else 
                ps_state <= ns_state;
                N <= N_NXT;
                A <= A_NXT;
                M <= M_NXT;
                Q <= Q_NXT;
                OUTPUT_OLD <= OUTPUT;
            end if;
        end if;
    end process FSM_CLK;
    
    -- Connect output to internal OUTPUT register
    Z_DIV <= OUTPUT_OLD;

    -- FSM next state process --
    COMB_LOGIC : process (ps_state, N, A, M, Q, OUTPUT_OLD, A_DIV, B_DIV, Q_RESTORE, A_RESTORE) begin
        ns_state <= load;
        N_NXT <= N;
        A_NXT <= A;
        M_NXT <= M;
        Q_NXT <= Q;
        RDY_DIV <= '0';
        OUTPUT <= OUTPUT_OLD;
        
        case ps_state is
            when load =>        -- Load state : Load and initialize inputs
                if( unsigned(B_DIV) = 0 ) then  -- Special check if dividing by 0. Send to finish state.
                    ns_state <= finish;
                    Q_NXT <= (others => '0');
                else    
                    ns_state <= restore;
                    N_NXT <= std_logic_vector(to_unsigned(WIDTH_DIV, N_NXT'length));
                    A_NXT <= (others => '0');
                    M_NXT <= B_DIV;
                    Q_NXT <= A_DIV;
                end if;
            when restore =>     -- Restore state : Assign value based on restorative division process. See RESTORATIVE process.                    
                ns_state <= n_check;
                A_NXT <= A_RESTORE;
                Q_NXT <= Q_RESTORE;        
            when n_check =>     -- N_check state : Check if N iterations have been done. Yes = Finish, No = Loop back.
                if( unsigned(N) = 1 ) then
                    ns_state <= finish;
                else
                    ns_state <= restore;
                    N_NXT <= std_logic_vector(unsigned(N) - 1);
                end if;
            when finish =>      -- Finish state : Set RDY_DIV flag high, assign answer to OUTPUT reg. Loop back to load.
                ns_state <= load;
                RDY_DIV <= '1';
                OUTPUT <= Q;
        end case;
        
        if( unsigned(B_DIV) = 0 ) then  -- Error flag when B_DIV is set to divide by 0.
            ERR_DIV <= '1';
        else
            ERR_DIV <= '0';
        end if;       
    end process COMB_LOGIC;
 
    -- Restorative process for handling restorative division logic -- 
    RESTORATIVE : process (ps_state, A, M, Q)
        variable A_SH, Q_SH : std_logic_vector(WIDTH_DIV-1 downto 0);
        variable TMP_SUB : std_logic_vector(WIDTH_DIV downto 0);
    begin
        A_SH := A(A'length-2 downto 0) & Q(WIDTH_DIV-1);    -- AQ shift
        Q_SH := Q(Q'length-2 downto 0) & '0';
        TMP_SUB := std_logic_vector(signed('0' & A_SH) - signed('0' & M));  -- A = A - M
        
        if( TMP_SUB(WIDTH_DIV) = '0' ) then -- If subtraction result is positive, LSB of Q will be 1 and A set to result
            Q_RESTORE <= Q_SH(Q_SH'length-1 downto 1) & '1';
            A_RESTORE <= TMP_SUB(WIDTH_DIV-1 downto 0);
        else                                -- If subtraction result is negative, LSB of Q will be 0 and A is restored to result of shift
            Q_RESTORE <= Q_SH(Q_SH'length-1 downto 1) & '0';
            A_RESTORE <= A_SH;
        end if;   
    end process RESTORATIVE; 

-- End FSM Logic --

end Behavioral;
