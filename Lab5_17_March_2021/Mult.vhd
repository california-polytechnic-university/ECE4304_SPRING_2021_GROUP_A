library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MULT is
    generic(
        WIDTH_MULT : integer:= 4
    );
    Port ( 
        A_MULT : in std_logic_vector(WIDTH_MULT-1 downto 0);
        B_MULT : in std_logic_vector(WIDTH_MULT-1 downto 0);
        Z_MULT : out std_logic_vector(WIDTH_MULT*2-1 downto 0)
    );
end MULT;

architecture Behavioral of MULT is

-- Component Declaration --
    component N_FA is
        generic(
            WIDTH : integer:= 4
        );
        Port ( 
            A : in std_logic_vector(WIDTH-1 downto 0);
            B : in std_logic_vector(WIDTH-1 downto 0);
            CIN : in std_logic;
            
            Z : out std_logic_vector(WIDTH-1 downto 0);
            COUT : out std_logic
        );
    end component N_FA;
-- End Component Declaration --

-- Signal Declaration --
signal CARRY_ARRAY : std_logic_vector( (WIDTH_MULT+1)*WIDTH_MULT-1 downto 0); -- Holds carry from FA
signal B_INPUT : std_logic_vector(WIDTH_MULT*(WIDTH_MULT-1)-1 downto 0);      -- Holds B input for FA
-- End Signal Declaration

begin

-- Multiplication Logic --

    -- Initial FA A(3) is 0
    CARRY_ARRAY(WIDTH_MULT) <= '0';
    
    -- Initial value for A needs to be instantiated on input
    CARRY_ARRAY_INIT : for i in 0 to WIDTH_MULT-1 generate       
        CARRY_ARRAY(i) <= B_MULT(0) and A_MULT(i);    
    end generate CARRY_ARRAY_INIT;
    
    -- Initialize B values needs to be instantiated on input
    B_INP_FA : for i in 0 to WIDTH_MULT-2 generate
        B_INP_Y : for j in 0 to WIDTH_MULT-1 generate      
            B_INPUT(i*WIDTH_MULT + j) <= B_MULT(i+1) and A_MULT(j); 
        end generate B_INP_Y;
    end generate B_INP_FA;

    -- Main cascading FA loop
    FA_LOOP : for i in 0 to WIDTH_MULT-2 generate
    
        FA_INST: N_FA
        generic map(
            WIDTH => WIDTH_MULT
        )
        port map(
            A => CARRY_ARRAY(i*(WIDTH_MULT+1) + WIDTH_MULT downto i*(WIDTH_MULT+1) + 1),
            B => B_INPUT(i*WIDTH_MULT+WIDTH_MULT-1 downto i*WIDTH_MULT),
            CIN => '0',
            Z => CARRY_ARRAY((i+1)*(WIDTH_MULT+1) + WIDTH_MULT - 1 downto (i+1)*(WIDTH_MULT+1)),
            COUT => CARRY_ARRAY((i+1)*(WIDTH_MULT+1) + WIDTH_MULT)
        );
        -- Output LSB from FA sum straight to final answer
        Z_MULT(i) <= CARRY_ARRAY(i * (WIDTH_MULT+1));
    end generate;
    
    -- Fill in rest of final answer with the result of the final FA loop
    Z_MULT(2*WIDTH_MULT-1 downto WIDTH_MULT-1) <= CARRY_ARRAY((WIDTH_MULT+1)*WIDTH_MULT-1 downto (WIDTH_MULT+1)*WIDTH_MULT-WIDTH_MULT-1);
    
-- End Multiplication Logic --

end Behavioral;
