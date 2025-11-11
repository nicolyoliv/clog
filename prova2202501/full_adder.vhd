library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Somador Completo (Full Adder)
entity full_adder is
    port(
        a, b, ci : in std_logic;  -- Entradas A, B e Carry In
        co, s    : out std_logic   -- Carry Out e Soma
    );
end full_adder;

architecture fa_arch of full_adder is
begin
    s <= (a xor b xor ci);
    co <= (a and b) or (ci and (a xor b));
end fa_arch;