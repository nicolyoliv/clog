library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaração da entidade: Somador de 4 bits
entity adder_4bits is
    port(
        num1, num2 : in std_logic_vector(3 downto 0); -- Entradas de 4 bits
        num3 : out std_logic_vector(4 downto 0)      -- Saída de 5 bits (4 da soma + 1 do carry)
    );
end adder_4bits;

-- Arquitetura: Instancia 4 somadores de 1 bit.
architecture adder_arch of adder_4bits is
    signal co0, co1, co2, co3 : std_logic; -- Sinais de carry intermediários
    signal res : std_logic_vector(4 downto 0); -- Sinal interno para o resultado
begin
    -- Somador do LSB (bit 0)
    adder_a: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(0),
        b => num2(0),
        ci => '0',       -- O carry inicial é 0
        co => co0,
        s => res(0)
    );
    
    -- Somador do bit 1, usando o carry out do anterior
    adder_b: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(1),
        b => num2(1),
        ci => co0,
        co => co1,
        s => res(1)
    );
    
    -- Somador do bit 2
    adder_c: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(2),
        b => num2(2),
        ci => co1,
        co => co2,
        s => res(2)
    );
    
    -- Somador do MSB (bit 3)
    adder_d: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(3),
        b => num2(3),
        ci => co2,
        co => res(4),   -- O carry out final é o 5º bit do resultado
        s => res(3)
    );
    -- Atribui o resultado final, com uma lógica de overflow simplista
    num3 <= res when res(4) = '0' else
            "10000"; 

end adder_arch;
