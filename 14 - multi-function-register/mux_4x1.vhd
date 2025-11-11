library ieee;
use ieee.std_logic_1164.all;

entity mux_4x1 is
   port(
      i: in std_logic_vector(3 downto 0);  -- Quatro entradas de 1 bit.
      c: in std_logic_vector(1 downto 0);  -- Seletor de 2 bits.
      s: out std_logic                     -- Saída selecionada.
   );
end mux_4x1;

architecture cond_arch of mux_4x1 is
begin
   -- Usa o seletor 'c' para escolher uma das entradas.
   s <= i(3) when (c="11") else  -- Seleciona i(3).
        i(2) when (c="10") else  -- Seleciona i(2).
        i(1) when (c="01") else  -- Seleciona i(1).
        i(0) ;                   -- Seleciona i(0).
        
end cond_arch;