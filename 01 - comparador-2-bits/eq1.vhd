library ieee;
use ieee.std_logic_1164.all;

entity eq1 is
   port(
      i0, i1 : in  std_logic; -- Entradas: dois bits a serem comparados
      eq     : out std_logic  -- Saída: 1 se i0 = i1 (igualdade)
   );
end eq1;

architecture sop_arch of eq1 is
   signal p0, p1 : std_logic; -- Sinais internos para os termos do produto
begin
   -- SOMA: A saída de igualdade é o OR (SOMA) dos termos do produto.
   -- eq = p0 OR p1
   eq <= p0 or p1; 
   
   -- TERMO P0: Implementa o caso '00'. p0 = i0' AND i1'
   -- O resultado é 1 se i0=0 E i1=0.
   p0 <= (not i0) and (not i1); 
   
   -- TERMO P1: Implementa o caso '11'. p1 = i0 AND i1
   -- O resultado é 1 se i0=1 E i1=1.
   p1 <= i0 and i1; 
   
end sop_arch;

io i1 eq
0   0  1
0   1  0
1   0  0
1   1  1
eq = (io'i1')+(i0i1)