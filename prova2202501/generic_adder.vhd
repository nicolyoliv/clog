library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Somador Genérico de N bits
entity generic_adder is
    -- GENERIC: Define a largura de bits (N)
    generic (
        DATA_WIDTH : integer := 4  -- Padrão de 4 bits
    );
    port(
        A_in  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        B_in  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        C_in  : in std_logic;      -- Carry de entrada (C0)
        
        S_out : out std_logic_vector(DATA_WIDTH - 1 downto 0); -- Saída da Soma (N bits)
        C_out : out std_logic      -- Carry de saída final (CN)
    );
end generic_adder;

architecture structural of generic_adder is
    -- Sinal interno para a propagação do Carry (DATA_WIDTH bits para C1 até CN)
    -- O CARRY(i) é o Carry Out do bit 'i' e o Carry In do bit 'i+1'
    signal CARRY : std_logic_vector(DATA_WIDTH - 1 downto 0); 
    
    -- Declaração do componente de 1 bit
    component full_adder
        port(a, b, ci : in std_logic; co, s : out std_logic);
    end component;
    
begin
    
    -- -------------------------------------------------------------
    -- 1. Loop de Geração (GENERATE): Cria os somadores do Bit 0 ao MSB
    -- -------------------------------------------------------------
    G_ADDER : for i in 0 to DATA_WIDTH - 1 generate
        FA_i : entity work.full_adder(fa_arch)
        port map(
            a  => A_in(i),
            b  => B_in(i),
            s  => S_out(i),
            
            -- Lógica do Carry In (Ci)
            ci => CARRY_IN_i(i),   
            
            -- Lógica do Carry Out (Co)
            co => CARRY_OUT_i(i)  
        );
    end generate G_ADDER;
    
    -- -------------------------------------------------------------
    -- 2. Conexões do Carry (Cadeia Ripple Carry)
    -- -------------------------------------------------------------
    -- O Carry In do Bit 0 é o C_in externo
    CARRY(0) <= C_in;
    
    -- O Carry In do bit 'i' é o Carry Out do bit 'i-1'
    C_CHAIN : for i in 1 to DATA_WIDTH - 1 generate
        CARRY(i) <= CARRY(i-1); 
    end generate C_CHAIN;
    
    -- O Carry Out final (CN) é o Carry Out do último Somador (MSB)
    C_out <= CARRY(DATA_WIDTH - 1);
    
end structural;