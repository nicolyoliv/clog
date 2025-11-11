library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaração da entidade: Somador de 1 bit.
entity adder_1bit is
    port(
        a : in std_logic;      -- Entrada 1
        b : in std_logic;      -- Entrada 2
        ci : in std_logic;     -- Carry de entrada (Carry in)
        co : out std_logic;    -- Carry de saída (Carry out)
        s : out std_logic      -- Soma
    );
end adder_1bit;

-- Arquitetura: Implementa a lógica do somador.
architecture adder_arch of adder_1bit is
begin
    -- Equação do carry out: (a E b) OU (ci E (a XOR b))
    co <= (a and b) or (ci and (a xor b));
    
    -- Equação da soma: a XOR b XOR ci
    s <= (a xor b xor ci);

end adder_arch;