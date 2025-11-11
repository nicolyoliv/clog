library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaração da entidade: Subtrator de 1 bit.
entity subtractor_1bit is
    port(
        a : in std_logic;      -- Entrada 1
        b : in std_logic;      -- Entrada 2
        bi : in std_logic;     -- Borrow de entrada (Borrow in)
        bo : out std_logic;    -- Borrow de saída (Borrow out)
        s : out std_logic      -- Diferença
    );
end subtractor_1bit;

-- Arquitetura: Implementa a lógica do subtrator.
architecture subtractor_arch of subtractor_1bit is
begin
    -- Equação do borrow out: (NOT a E b) OU (NOT a E bi) OU (b E bi)
    bo <= (not(a) and b) or (not(a) and bi) or (b and bi);
    
    -- Equação da diferença: a XOR b XOR bi
    s <= (a xor b xor bi);

end subtractor_arch;