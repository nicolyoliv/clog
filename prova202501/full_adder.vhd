library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Somador Completo (Full Adder)
entity full_adder is
    port(
        a : in std_logic;
        b : in std_logic;
        ci : in std_logic;  -- Carry de entrada
        co : out std_logic; -- Carry de saída
        s : out std_logic   -- Soma
    );
end full_adder;

-- Arquitetura: Implementa as equações lógicas do Somador Completo.
architecture fa_arch of full_adder is
begin
    -- Equação do Carry Out: co = (a E b) OU (ci E (a XOR b))
    co <= (a and b) or (ci and (a xor b));
    
    -- Equação da Soma: s = a XOR b XOR ci
    s <= (a xor b xor ci);
end fa_arch;