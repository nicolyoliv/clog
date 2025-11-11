library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: somador completo de 1 bit
entity adder_1bit is
    port(
        a : in std_logic;
        b : in std_logic;
        ci : in std_logic;  -- Sinal de carry de entrada
        co : out std_logic; -- Sinal de carry de saída
        s : out std_logic   -- Sinal da soma
    );
end adder_1bit;

architecture adder_arch of adder_1bit is
begin
    -- A lógica do carry out (co) é '1' se houver pelo menos duas entradas '1'
    co <= (a and b) or (ci and (a xor b));
    -- A lógica da soma (s) é '1' se houver um número ímpar de entradas '1'
    s <= (a xor b xor ci);
end adder_arch;