library ieee;
use ieee.std_logic_1164.all;

entity cod_prio is
   port(
      r     : in  std_logic_vector(2 downto 0);    -- Entrada de 3 bits, onde a prioridade é r(2) > r(1) > r(0).
      pcode : out std_logic_vector(1 downto 0)     -- Saída de 2 bits que representa a operação selecionada.
   );
end cod_prio;

architecture cond_arch of cod_prio is
begin
   -- O comando 'when-else' implementa a lógica de prioridade.
   -- A primeira condição verdadeira é a que será executada.
   pcode <= "11" when (r(2) = '1') else  -- Prioridade mais alta: r(2)
            "10" when (r(1) = '1') else  -- Prioridade intermediária: r(1)
            "01" when (r(0) = '1') else  -- Prioridade mais baixa: r(0)
            "00";                        -- Nenhuma operação selecionada.
end cond_arch;