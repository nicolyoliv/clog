library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Meio Somador (Half Adder)
entity half_adder is
    port(
        a : in std_logic;      -- Entrada 1
        b : in std_logic;      -- Entrada 2
        co : out std_logic;    -- Carry de saída
        s : out std_logic      -- Soma
    );
end half_adder;

-- Arquitetura: Implementa as equações lógicas do Meio Somador.
architecture ha_arch of half_adder is
begin
    -- Equação do Carry Out: co = a E b
    co <= a and b;
    
    -- Equação da Soma: s = a XOR b
    s <= a xor b;
end ha_arch;