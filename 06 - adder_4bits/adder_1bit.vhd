library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaração da entidade: Somador de 1 bit.
entity adder_1bit is
    port(
        a : in std_logic;      -- Entrada 1 (A)
        b : in std_logic;      -- Entrada 2 (B)
        ci : in std_logic;     -- Carry de entrada (C_in)
        co : out std_logic;    -- Carry de saída (C_out)
        s : out std_logic      -- Soma (S)
    );
end adder_1bit;

-- Arquitetura: Implementa a lógica do somador.
architecture adder_arch of adder_1bit is
begin
    -- Equação da Soma: S = A ⊕ B ⊕ C_in
    s <= (a xor b xor ci);
    
    -- Equação do Carry Out: C_out = (A·B) + (C_in · (A ⊕ B))
    co <= (a and b) or (ci and (a xor b));
end adder_arch;