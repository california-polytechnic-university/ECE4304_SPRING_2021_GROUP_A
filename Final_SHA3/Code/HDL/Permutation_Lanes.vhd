-- File Name: Permutation_Lanes.vhd
-- Purpose  : Run padded SHA3-256 input through one round of permutation using IOTA input.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Permutation_Lanes is
    Port ( 
        IOTA_CONST : in std_logic_vector(63 downto 0);
        DATA_IN     : in std_logic_vector(1599 downto 0);
        DATA_OUT    : out std_logic_vector(1599 downto 0)
    );
end Permutation_Lanes;

architecture Behavioral of Permutation_Lanes is

-- Overall memory for Keccak permutation for SHA-3 is a 5x5x64

-- Declare memory
-- RC_Memory represents the overall memory as 25 lanes. The 5x5 is represented as the 25 different lanes, 64 bit length as the depth.
type RC_MEMORY is array (0 to 24) of std_logic_vector(63 downto 0);
-- An RC_ROW represents one row of lanes in the 3D memory. 
type RC_ROW is array (0 to 4) of std_logic_vector(63 downto 0);

-- Input Memory
signal MEM : RC_MEMORY;

-- Theta Memory
signal C_INTERM : RC_ROW;
signal D_INTERM : RC_ROW;
signal THETA_OUTMEM : RC_MEMORY; 

-- Rho Memory
signal RHO_INMEM  : RC_MEMORY;
signal RHO_OUTMEM : RC_MEMORY;

-- Rho rotation constant
type INT_ARRAY is array (0 to 24) of integer;
constant RHO_ROT_CONST : INT_ARRAY := 
                                   (0, 1, 62, 28, 27,
                                    36, 44, 6, 55, 20,
                                    3, 10, 43, 25, 39,
                                    41, 45, 15, 21, 8,
                                    18, 2, 61, 56, 14);

-- Pi Memory
signal PI_INMEM : RC_MEMORY;
signal PI_OUTMEM : RC_MEMORY;

-- Pi rotation constant
constant PI_ROT_CONST : INT_ARRAY := 
                                   (0, 10, 20,  5, 15,
                                    16,  1, 11, 21,  6,
                                     7, 17,  2, 12, 22,
                                    23,  8, 18,  3, 13,
                                    14, 24,  9, 19,  4);

-- Chi Memory
signal CHI_INMEM : RC_MEMORY;
signal CHI_OUTMEM: RC_MEMORY;

-- Iota Memory
signal IOTA_INMEM : RC_MEMORY;
signal IOTA_OUTMEM: RC_MEMORY;

begin   
    
    ------------------------------------------Input-----------------------------------------------------
    -- Load input data chunk (1600 bits)
    RC_LANES : for x in 0 to 24 generate
        RC_BYTES : for y in 0 to 7 generate
                MEM(x)((y+1)*8 - 1 downto y * 8) <= DATA_IN((1600-(x*64)-(y*8)-1) downto (1600-(x*64)-((y+1)*8))); 
        end generate RC_BYTES;
    end generate RC_LANES;
    
    ----------------------------------------THETA------------------------------------------------
    -- Generate C intermediate array
    C_INITIALIZE : for i in 0 to 4 generate
        C_BITS : for j in 0 to 63 generate
            C_INTERM(i)(j) <= MEM(i)(j) XOR MEM(i + 5)(j) XOR MEM(i+10)(j) XOR MEM(i+15)(j) XOR MEM(i+20)(j);
        end generate C_BITS;
    end generate C_INITIALIZE;

    -- Generate D intermediate array
    D_INITIALIZE : for i in 0 to 4 generate
        D_BITS : for j in 0 to 63 generate
            D_INTERM(i)(j) <= C_INTERM((i + 4) mod 5)(j) XOR C_INTERM((i+1) mod 5)((j-1) mod 64);
        end generate D_BITS;
    end generate D_INITIALIZE;

    -- Generate Theta output using D intermediate array
    THETA_OUTPUT : for i in 0 to 4 generate
        THETA_ROW : for j in 0 to 4 generate
            THETA_BITS : for k in 0 to 63 generate
                THETA_OUTMEM(i + (j*5))(k) <= MEM(i + (j*5))(k) XOR D_INTERM(i)(k);
            end generate THETA_BITS;
        end generate THETA_ROW; 
    end generate THETA_OUTPUT;

    ------------------------------------------RHO---------------------------------------------------

    RHO_INMEM <= THETA_OUTMEM;

    -- Use Rho rotational constants to rotate lanes
    RHO_OUTPUT : for i in 0 to 24 generate
        RHO_BITS : for j in 0 to 63 generate
            RHO_OUTMEM(i)(j) <= RHO_INMEM(i)((j-RHO_ROT_CONST(i)) mod 64);
        end generate RHO_BITS;
    end generate RHO_OUTPUT;

    ------------------------------------------PI-----------------------------------------------------
    PI_INMEM <= RHO_OUTMEM;
    
    -- Use Pi rotational constant to rotate lanes
    PI_OUTPUT : for i in 0 to 24 generate
        PI_BITS : for j in 0 to 63 generate
            PI_OUTMEM(PI_ROT_CONST(i))(j) <= PI_INMEM(i)(j);
        end generate PI_BITS; 
    end generate PI_OUTPUT;
    
    ------------------------------------------CHI-----------------------------------------------------
    CHI_INMEM <= PI_OUTMEM;

    -- Chi output
    CHI_OUTPUT : for i in 0 to 4 generate
        CHI_INNER : for j in 0 to 4 generate
            CHI_BITS : for k in 0 to 63 generate
                CHI_OUTMEM((i*5)+j)(k) <= CHI_INMEM((i*5)+j)(k) XOR ( NOT(CHI_INMEM((i*5) + ((j+1)mod 5))(k)) AND CHI_INMEM((i*5) + ((j+2)mod 5))(k) );
            end generate CHI_BITS;
        end generate CHI_INNER;
    end generate CHI_OUTPUT;  
    
    ------------------------------------------IOTA-----------------------------------------------------
    IOTA_INMEM <= CHI_OUTMEM;
    
    -- Iota output using the input IOTA_CONST
    IOTA_OUTPUT : for i in 0 to 24 generate
        IOTA_0LANE : if (i = 0) generate
            IOTA_0BITS : for j in 0 to 63 generate
                IOTA_OUTMEM(0)(j) <= IOTA_INMEM(0)(j) XOR IOTA_CONST(j);
            end generate IOTA_0BITS;
        end generate IOTA_0LANE;
        
        IOTA_ELSE : if (i /= 0) generate
            IOTA_ELSEBITS : for j in 0 to 63 generate
                IOTA_OUTMEM(i)(j) <= IOTA_INMEM(i)(j);
            end generate IOTA_ELSEBITS;
        end generate IOTA_ELSE;
    end generate IOTA_OUTPUT;
    
    ------------------------------------------Output-----------------------------------------------------
    
    -- Load output chunk (1600 bits)
    OUT_LANES : for x in 0 to 24 generate
        OUT_BYTES : for y in 0 to 7 generate
                DATA_OUT((1600-(x*64)-(y*8)-1) downto (1600-(x*64)-((y+1)*8))) <= IOTA_OUTMEM(x)((y+1)*8 - 1 downto y * 8);
        end generate OUT_BYTES;
    end generate OUT_LANES;

end Behavioral;