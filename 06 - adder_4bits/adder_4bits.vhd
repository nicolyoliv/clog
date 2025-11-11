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
    signal co0, co1, co2, co3 : std_logic;     -- Sinais de carry intermediários (C1, C2, C3)
    signal s_result : std_logic_vector(3 downto 0); -- Sinal interno para os 4 bits da Soma
    signal c_final : std_logic;                -- Sinal interno para o Carry Out Final (C4)
begin
    -- -----------------------------------------------------------
    -- Instanciação e Encadeamento dos Somadores de 1 bit
    -- -----------------------------------------------------------
    
    -- Somador do LSB (bit 0)
    adder_a: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(0),
        b => num2(0),
        ci => '0',       -- O carry inicial (C0) é 0
        co => co0,       -- C1
        s => s_result(0)
    );
    
    -- Somador do bit 1
    adder_b: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(1),
        b => num2(1),
        ci => co0,       -- Recebe C1
        co => co1,       -- C2
        s => s_result(1)
    );
    
    -- Somador do bit 2
    adder_c: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(2),
        b => num2(2),
        ci => co1,       -- Recebe C2
        co => co2,       -- C3
        s => s_result(2)
    );
    
    -- Somador do MSB (bit 3)
    adder_d: entity work.adder_1bit(adder_arch)
    port map(
        a => num1(3),
        b => num2(3),
        ci => co2,       -- Recebe C3
        co => c_final,   -- O carry out final (C4)
        s => s