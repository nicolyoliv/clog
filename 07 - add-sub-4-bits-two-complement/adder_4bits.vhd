library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: somador de 4 bits
entity adder_4bits is
    port(
        num1, num2 : in std_logic_vector(3 downto 0); -- Entradas de 4 bits
        num3 : out std_logic_vector(4 downto 0)      -- Saída de 5 bits (inclui o carry out final)
    );
end adder_4bits;

architecture adder_arch of adder_4bits is
    signal co0, co1, co2, co3 : std_logic; -- Sinais de carry intermediários entre os somadores
    signal res : std_logic_vector(4 downto 0); -- Sinal interno para o resultado da soma
begin
    -- Instanciação do somador do bit 0 (LSB)
    adder_a: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(0),
        b => num2(0),
        ci => '0',       -- O carry inicial do primeiro bit é zero
        co => co0,
        s => res(0)
    );
    
    -- Instanciação do somador do bit 1, com carry do bit 0
    adder_b: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(1),
        b => num2(1),
        ci => co0,
        co => co1,
        s => res(1)
    );
    
    -- Instanciação do somador do bit 2, com carry do bit 1
    adder_c: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(2),
        b => num2(2),
        ci => co1,
        co => co2,
        s => res(2)
    );
    
    -- Instanciação do somador do bit 3 (MSB), com carry do bit 2
    adder_d: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(3),
        b => num2(3),
        ci => co2,
        co => res(4),   -- O carry out final se torna o 5º bit da saída
        s => res(3)
    );
    
    num3 <= res; -- Atribui o resultado completo de 5 bits à saída do módulo

end adder_arch;
