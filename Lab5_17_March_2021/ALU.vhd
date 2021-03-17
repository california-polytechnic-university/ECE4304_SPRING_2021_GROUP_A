library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    generic(
        WIDTH_ALU : integer:=4
    );
    Port ( 
        CLK_ALU : in std_logic;
        RST_ALU : in std_logic;
        A_ALU   : in std_logic_vector(WIDTH_ALU-1 downto 0);
        B_ALU   : in std_logic_vector(WIDTH_ALU-1 downto 0);
        SEL_ALU : in std_logic_vector(1 downto 0);
        
        RES_ALU : out std_logic_vector(WIDTH_ALU*2-1 downto 0);
        NEG_ALU : out std_logic;
        ERR_ALU : out std_logic
    );
end ALU;

architecture Behavioral of ALU is

-- Component Declaration --
    -- Subtraction component
    component SUB is
        generic(
            WIDTH_SUB : integer:= 4
        );
        Port ( 
            A_SUB   : in std_logic_vector(WIDTH_SUB-1 downto 0);
            B_SUB   : in std_logic_vector(WIDTH_SUB-1 downto 0);
            
            Z_SUB   : out std_logic_vector(WIDTH_SUB-1 downto 0);
            NEG_SUB : out std_logic
        );
    end component SUB;
    
    -- Multiplication component
    component MULT is
        generic(
            WIDTH_MULT : integer:= 4
        );
        Port ( 
            A_MULT  : in std_logic_vector(WIDTH_MULT-1 downto 0);
            B_MULT  : in std_logic_vector(WIDTH_MULT-1 downto 0);
            Z_MULT  : out std_logic_vector(WIDTH_MULT*2-1 downto 0)
        );
    end component MULT;
    
    -- Division component
    component DIV is
        generic(
            WIDTH_DIV : integer := 4
        );
        Port ( 
            CLK_DIV : in std_logic;
            RST_DIV : in std_logic;
            A_DIV   : in std_logic_vector(WIDTH_DIV-1 downto 0);
            B_DIV   : in std_logic_vector(WIDTH_DIV-1 downto 0);
            Z_DIV   : out std_logic_vector(WIDTH_DIV-1 downto 0);
            RDY_DIV : out std_logic;
            ERR_DIV : out std_logic
        );
    end component DIV;

-- End Component Declaration --
 

-- Signal Declaration --
    -- Constant for padding outputs from components from WIDTH_ALU to WIDTH_ALU*2
    constant PAD_0 : std_logic_vector(WIDTH_ALU-1 downto 0) := (others => '0');

    -- Addition signals
    signal ADD_RESULT       : std_logic_vector(WIDTH_ALU*2-1 downto 0);
    
    -- Subtraction signals
    signal SUB_NEG          : std_logic;
    signal SUB_RESULT       : std_logic_vector(WIDTH_ALU*2-1 downto 0); 
    signal SUB_RESULT_UNPAD : std_logic_vector(WIDTH_ALU-1 downto 0);
    
    -- Multiplication signals
    signal MUL_RESULT   : std_logic_vector(WIDTH_ALU*2-1 downto 0);
    
    -- Division signals
    signal DIV_RESULT       : std_logic_vector(WIDTH_ALU*2-1 downto 0);
    signal DIV_RESULT_UNPAD : std_logic_vector(WIDTH_ALU-1 downto 0);
    signal DIV_ERR          : std_logic;
-- End Signal Declaration

begin

-- Mux Output --
    MUX_OUTPUT: process (SEL_ALU, ADD_RESULT, SUB_RESULT, SUB_NEG, MUL_RESULT, DIV_RESULT, DIV_ERR) begin
        NEG_ALU <= '0';
        ERR_ALU <= '0';
        case(SEL_ALU) is
            when "00" =>    -- SEL = 0, ADD    
                RES_ALU     <= ADD_RESULT;  
            when "01" =>    -- SEL = 1, SUB
                RES_ALU     <= SUB_RESULT;
                NEG_ALU     <= SUB_NEG;
            when "10" =>    -- SEL = 2, MULTIPLY
                RES_ALU     <= MUL_RESULT;
            when "11" =>    -- SEL = 3, DIVIDE
                RES_ALU     <= DIV_RESULT;
                ERR_ALU     <= DIV_ERR;
            when others =>  -- ELSE CATCH, X
                RES_ALU     <= (others => '0');
        end case;
    end process MUX_OUTPUT;
-- End Mux Output --

-- Addition Segment --
    ADD_RESULT <= std_logic_vector(unsigned(PAD_0 & A_ALU) + unsigned(PAD_0 & B_ALU));    
-- End Addition Segment --

-- Subtraction Segment --   
    SUB_INST : SUB 
    generic map(
        WIDTH_SUB   => WIDTH_ALU
    )
    port map(
        A_SUB   => A_ALU,
        B_SUB   => B_ALU,
        Z_SUB   => SUB_RESULT_UNPAD,
        NEG_SUB => SUB_NEG
    ); 
    
    SUB_RESULT <= PAD_0 & SUB_RESULT_UNPAD;
-- End Subtraction Segment --   


-- Multiplication Segment -- 
    MULT_INST : MULT 
    generic map(
        WIDTH_MULT  => WIDTH_ALU
    )
    port map(
        A_MULT  => A_ALU,
        B_MULT  => B_ALU,
        Z_MULT  => MUL_RESULT
    );
-- End Multiplication Segment -- 


-- Division Segment -- 
    DIV_INST : DIV 
    generic map(
        WIDTH_DIV   => WIDTH_ALU
    )
    port map(
        CLK_DIV => CLK_ALU,
        RST_DIV => RST_ALU,
        A_DIV   => A_ALU,
        B_DIV   => B_ALU,
        Z_DIV   => DIV_RESULT_UNPAD,
        ERR_DIV => DIV_ERR
    );
    
    DIV_RESULT <= PAD_0 & DIV_RESULT_UNPAD;
-- End Division Segment -- 

end Behavioral;
