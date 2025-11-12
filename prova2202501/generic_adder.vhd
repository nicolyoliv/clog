library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Somador Ripple Carry Genérico de N bits
entity generic_adder is
    generic (
        DATA_WIDTH : integer := 4  -- Largura de bits
    );
    port(
        A_in  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        B_in  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        C_in  : in std_logic;      -- Carry de entrada (C0)
        
        S_out : out std_logic_vector(DATA_WIDTH - 1 downto 0); -- Saída da Soma (N bits)
        C_out : out std_logic      -- Carry de saída final (CN)
    );
end generic_adder;

architecture structural_clean of generic_adder is
    -- CARRY terá N+1 bits (C0 a CN). C(0) é o C_in inicial. C(N) é o C_out final.
    signal CARRY : std_logic_vector(DATA_WIDTH downto 0); 
    
    component full_adder
        port(a, b, ci : in std_logic; co, s : out std_logic);
    end component;
    
begin
    
    -- 1. O Carry In inicial (C0) é o C_in externo
    CARRY(0) <= C_in;
    
    -- 2. Loop de Geração (GENERATE): Cria N Somadores Completo (Bit 0 ao N-1)
    G_ADDER : for i in 0 to DATA_WIDTH - 1 generate
        FA_i : entity work.full_adder(fa_arch)
        port map(
            a  => A_in(i),
            b  => B_in(i),
            s  => S_out(i),
            
            ci => CARRY(i),     -- Carry In é o CARRY do estágio 'i'
            co => CARRY(i+1)    -- Carry Out é o CARRY do estágio 'i+1'
        );
    end generate G_ADDER;
    
    -- 3. O Carry Out final (CN) é o último bit do vetor CARRY
    C_out <= CARRY(DATA_WIDTH);
    
end structural_clean;