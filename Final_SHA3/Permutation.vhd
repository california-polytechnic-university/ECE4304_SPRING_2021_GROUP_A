library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Permutation is
    Port ( 
        CLK : in std_logic;
        DATA_IN     : in std_logic_vector(1599 downto 0);
        DATA_OUT    : out std_logic_vector(24 downto 0)
    );
end Permutation;

architecture Behavioral of Permutation is

type RC_MEMORY is array (0 to 63) of std_logic_vector(24 downto 0);
type RC_SLICE is array (0 to 63) of std_logic_vector(4 downto 0);
signal MEM : RC_MEMORY;

constant ROUND_CONSTANT : std_logic_vector(63 downto 0) := X"0000000000000001";

-- Theta signals
signal C_INTERM : RC_SLICE;
signal D_INTERM : RC_SLICE;
signal THETA_OUTMEM : RC_MEMORY; 

-- Rho signals
signal RHO_INMEM  : RC_MEMORY;
signal RHO_OUTMEM : RC_MEMORY;

-- Pi signals
signal PI_INMEM : RC_MEMORY;
signal PI_OUTMEM : RC_MEMORY;

-- Chi signals
signal CHI_INMEM : RC_MEMORY;
signal CHI_OUTMEM: RC_MEMORY;

-- Iota signals
signal IOTA_INMEM : RC_MEMORY;
signal IOTA_OUTMEM: RC_MEMORY;

--TB pointer
signal TB_POINT : std_logic_vector(10 downto 0) := (others => '0');

begin

    --TB Clock
    CLK_TB : process (CLK) begin
        if(rising_edge(CLK)) then
            DATA_OUT <= IOTA_OUTMEM(to_integer(unsigned(TB_POINT)));
            if( unsigned(TB_POINT) = 63 ) then
                TB_POINT <= (others => '0');
            else
                TB_POINT <= std_logic_vector(unsigned(TB_POINT) + 1);
            end if;
        end if;
    end process CLK_TB;

    -- Load data chunk (1600 bits)
    RC_INITIALIZE : for i in 0 to 63 generate
       MEM(i) <= DATA_IN(25*(i+1)-1 downto 25*i);
    end generate RC_INITIALIZE;
    
    ----------------------------------------THETA------------------------------------------------
    -- Generate C intermediate array
    C_INITIALIZE : for i in 0 to 63 generate
        C_INNER : for j in 0 to 4 generate
            C_INTERM(i)(j) <= MEM(i)(4+(j*5)) XOR MEM(i)(3+(j*5)) XOR MEM(i)(2+(j*5)) XOR MEM(i)(1+(j*5)) xor MEM(i)(0+(j*5));    
        end generate C_INNER;
    end generate C_INITIALIZE;
    
    D_INITIALIZE : for i in 0 to 63 generate
        D_ROW : for j in 0 to 4 generate
            D_INTERM(i)(j) <= C_INTERM(i)((j-1)mod 4) XOR C_INTERM((i-1)mod 63)((j+1)mod 4);
        end generate D_ROW;
    end generate D_INITIALIZE; 
    
    THETA_OUTPUT : for i in 0 to 63 generate
        THETA_ROW : for j in 0 to 4 generate
            THETA_COL : for k in 0 to 4 generate
                THETA_OUTMEM(i)(k+(j*5)) <= MEM(i)(k+(j*5)) XOR D_INTERM(i)(j);
            end generate THETA_COL;
        end generate THETA_ROW;
    end generate THETA_OUTPUT;

    ------------------------------------------RHO---------------------------------------------------
    -- Using the rotation constants given by the Keccak team : https://keccak.team/keccak_specs_summary.html
    --
    --          +-----------------------------------------------------------------------+
    --          |           |   x = 3   |   x = 4   |   x = 0   |   x = 1   |   x = 2   |
    --          +-----------------------------------------------------------------------+    
    --          |   y = 2   |   25      |   39      |   3       |   10      |   43      |
    --          +-----------------------------------------------------------------------+    
    --          |   y = 1   |   55      |  20       |   36      |   44      |   6       |
    --          +-----------------------------------------------------------------------+    
    --          |   y = 0   |   28      |   27      |   0       |   1       |   62      |
    --          +-----------------------------------------------------------------------+    
    --          |   y = 4   |   56      |   14      |   18      |   2       |   61      |
    --          +-----------------------------------------------------------------------+    
    --          |   y = 3   |   21      |   8       |   41      |   45      |   15      |
    --          +-----------------------------------------------------------------------+    
    
    RHO_INMEM <= THETA_OUTMEM;
    
    RHO_ASSIGN : for i in 0 to 63 generate
        -- First row in slice (equivalent would be (x, 0, z)
        RHO_OUTMEM(i)(0) <= RHO_INMEM(i)(0);
        RHO_OUTMEM(i)(1) <= RHO_INMEM((i-1) mod 64)(1);
        RHO_OUTMEM(i)(2) <= RHO_INMEM((i-62) mod 64)(2);
        RHO_OUTMEM(i)(3) <= RHO_INMEM((i-28) mod 64)(3);
        RHO_OUTMEM(i)(4) <= RHO_INMEM((i-27) mod 64)(4);
        -- Second row in slice (equivalent would be (x, 1, z)
        RHO_OUTMEM(i)(5) <= RHO_INMEM((i-36) mod 64)(5);
        RHO_OUTMEM(i)(6) <= RHO_INMEM((i-44) mod 64)(6);
        RHO_OUTMEM(i)(7) <= RHO_INMEM((i-6) mod 64)(7);
        RHO_OUTMEM(i)(8) <= RHO_INMEM((i-55) mod 64)(8);
        RHO_OUTMEM(i)(9) <= RHO_INMEM((i-20) mod 64)(9);
        -- Third row in slice (equivalent would be (x, 2, z)
        RHO_OUTMEM(i)(10) <= RHO_INMEM((i-3) mod 64)(10);
        RHO_OUTMEM(i)(11) <= RHO_INMEM((i-10) mod 64)(11);
        RHO_OUTMEM(i)(12) <= RHO_INMEM((i-43) mod 64)(12);
        RHO_OUTMEM(i)(13) <= RHO_INMEM((i-25) mod 64)(13);
        RHO_OUTMEM(i)(14) <= RHO_INMEM((i-39) mod 64)(14);
        -- Fourth row in slice (equivalent would be (x, 3, z)
        RHO_OUTMEM(i)(15) <= RHO_INMEM((i-41) mod 64)(15);
        RHO_OUTMEM(i)(16) <= RHO_INMEM((i-45) mod 64)(16);
        RHO_OUTMEM(i)(17) <= RHO_INMEM((i-15) mod 64)(17);
        RHO_OUTMEM(i)(18) <= RHO_INMEM((i-21) mod 64)(18);
        RHO_OUTMEM(i)(19) <= RHO_INMEM((i-8) mod 64)(19);
        -- Fifth row in slice (equivalent would be (x, 4, z)
        RHO_OUTMEM(i)(20) <= RHO_INMEM((i-18) mod 64)(20);
        RHO_OUTMEM(i)(21) <= RHO_INMEM((i-2) mod 64)(21);
        RHO_OUTMEM(i)(22) <= RHO_INMEM((i-61) mod 64)(22);
        RHO_OUTMEM(i)(23) <= RHO_INMEM((i-56) mod 64)(23);
        RHO_OUTMEM(i)(24) <= RHO_INMEM((i-14) mod 64)(24);
    end generate RHO_ASSIGN;
    
    ------------------------------------------PI---------------------------------------------------
    
    PI_INMEM <= RHO_OUTMEM;
    
    PI_ASSIGN : for i in 0 to 63 generate
        PI_ROW : for j in 0 to 4 generate
            PI_COL : for k in 0 to 4 generate
                PI_OUTMEM(i)( ((2*k+3*j) mod 5) + (j * 5) ) <= PI_INMEM(i)(k+(j*5));
            end generate PI_COL;
        end generate PI_ROW;
    end generate PI_ASSIGN;
    
    ------------------------------------------CHI---------------------------------------------------
    
    CHI_INMEM <= PI_OUTMEM;
    
    CHI_ASSIGN : for i in 0 to 63 generate
        CHI_ROW : for j in 0 to 4 generate
            CHI_COL : for k in 0 to 4 generate
                CHI_OUTMEM(i)(k+(j*5)) <= (CHI_INMEM(i)(k+(j*5)) XOR NOT CHI_INMEM(i)( ((k+1)mod 5) + (j*5) )) AND CHI_INMEM(i)( ((k+2)mod 5) + (j*5) );
            end generate CHI_COL;
        end generate CHI_ROW;
    end generate CHI_ASSIGN;
    
    ------------------------------------------IOTA---------------------------------------------------
       
    IOTA_INMEM <= CHI_OUTMEM;
    
    IOTA_ASSIGN : for i in 0 to 63 generate
        IOTA_ROW : for j in 0 to 4 generate
            IOTA_COL : for k in 0 to 4 generate
                
                IOTA_ZERO : if (j = 0) AND (k = 0) generate
                    IOTA_OUTMEM(i)(0) <= IOTA_INMEM(i)(0) XOR ROUND_CONSTANT(i);
                end generate IOTA_ZERO;
                
                IOTA_ELSE : if (j /= 0) AND (k /= 0) generate
                    IOTA_OUTMEM(i)(k+(j*5)) <= IOTA_INMEM(i)(k+(j*5));
                end generate IOTA_ELSE;
                
            end generate IOTA_COL;
        end generate IOTA_ROW;   
    end generate IOTA_ASSIGN;   
    
    
    
end Behavioral;
