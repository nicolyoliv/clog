library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Somador de 4 bits (com Meio Somador no LSB)
entity adder_4bits_lsb_ha is
    port(
        num1, num2 : in std_logic_vector(3 downto 0);  -- Entradas de 4 bits
        num3 : out std_logic_vector(4 downto 0)       -- Saída de 5 bits (inclui o carry out final)
    );
end adder_4bits_lsb_ha;

architecture structural_ha of adder_4bits_lsb_ha is
    signal c1, c2, c3, c4 : std_logic; -- Sinais de carry intermediários
    signal s : std_logic_vector(4 downto 0); -- Sinal interno para o resultado
    
    -- Declaração dos componentes
    component half_adder
        port(a, b: in std_logic; co, s: out std_logic);
    end component;
    
    component full_adder
        port(a, b, ci: in std_logic; co, s: out std_logic);
    end component;
    
begin
    -- 1. HA0 (Bit 0 - LSB): Meio Somador
    HA0: entity work.half_adder(ha_arch)
    port map(
        a => num1(0),
        b => num2(0),
        co => c1,       -- Carry In do próximo (C1)
        s => s(0)
    );
    
    -- 2. FA1 (Bit 1): Somador Completo
    FA1: entity work.full_adder(fa_arch)
    port map(
        a => num1(1), b => num2(1), ci => c1,
        co => c2,       -- Carry In do próximo (C2)
        s => s(1)
    );
    
    -- 3. FA2 (Bit 2): Somador Completo
    FA2: entity work.full_adder(fa_arch)
    port map(
        a => num1(2), b => num2(2), ci => c2,
        co => c3,       -- Carry In do próximo (C3)
        s => s(2)
    );
    
    -- 4. FA3 (Bit 3 - MSB): Somador Completo
    FA3: entity work.full_adder(fa_arch)
    port map(
        a => num1(3), b => num2(3), ci => c3,
        co => c4,       -- Carry Out final (C4)
        s => s(3)
    );
    
    -- Concatena o Carry Out final (c4) com os 4 bits da soma (s(3 downto 0))
    s(4) <= c4; 
    
    num3 <= s; -- Atribui o resultado completo de 5 bits à saída.

end structural_ha;