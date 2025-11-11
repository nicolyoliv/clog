-- Listing 1.2
library ieee;
use ieee.std_logic_1164.all;

entity eq2 is
   port(
      a, b : in std_logic_vector(1 downto 0); -- Entradas: vetores de 2 bits A e B
      aeqb : out std_logic                    -- Saída: 1 se A = B
   );
end eq2;

architecture sop_arch of eq2 is
   signal p0, p1, p2, p3: std_logic; -- Sinais internos para os 4 termos de produto (pelas 4 combinações 00, 01, 10, 11)
begin
   -- SOMA: A saída é o OR (SOMA) dos 4 termos.
   -- aeqb = p0 OR p1 OR p2 OR p3
   aeqb <= p0 or p1 or p2 or p3;
   
   -- P0: A=00 e B=00 (A1'B1') AND (A0'B0')
   p0 <= ((not a(1)) and (not b(1))) and 
         ((not a(0)) and (not b(0))); 
         
   -- P1: A=01 e B=01 (A1'B1') AND (A0B0)
   p1 <= ((not a(1)) and (not b(1))) and (a(0) and b(0)); 
   
   -- P2: A=10 e B=10 (A1B1) AND (A0'B0')
   p2 <= (a(1) and b(1)) and ((not a(0)) and (not b(0))); 
   
   -- P3: A=11 e B=11 (A1B1) AND (A0B0)
   p3 <= (a(1) and b(1)) and (a(0) and b(0)); 
   
end sop_arch;

-- Listing 1.3
architecture struc_arch of eq2 is
   signal e0, e1: std_logic; -- Sinais internos: e0 = Igualdade do Bit 0; e1 = Igualdade do Bit 1.
begin
   -- INSTANCIAÇÃO (Bit 0): Verifica a igualdade dos bits menos significativos (A0 e B0).
   eq_bit0_unit: entity work.eq1(sop_arch)
      port map(i0=>a(0), i1=>b(0), eq=>e0);
      
   -- INSTANCIAÇÃO (Bit 1): Verifica a igualdade dos bits mais significativos (A1 e B1).
   eq_bit1_unit: entity work.eq1(sop_arch)
      port map(i0=>a(1), i1=>b(1), eq=>e1);
      
   -- LÓGICA FINAL: A e B são iguais SE os bits individuais forem iguais.
   -- aeqb = e0 AND e1
   aeqb <= e0 and e1;
   
end struc_arch;

-- Listing 1.4
architecture vhd_87_arch of eq2 is
   -- DECLARAÇÃO DO COMPONENTE: Necessária em VHDL mais antigo ('87) para informar ao compilador 
   -- sobre a interface (portas) do sub-módulo 'eq1' antes de usá-lo.
   component eq1 
      port(
         i0, i1: in std_logic;
         eq: out std_logic
      );
   end component;
   signal e0, e1: std_logic;
begin
   -- O resto da arquitetura é idêntico ao Listing 1.3, demonstrando o uso da declaração de componente.
   -- O VHDL moderno (2002/2008) geralmente não requer a declaração de componente se 'entity work.eq1' for usado.
   
   -- INSTANCIAÇÃO (Bit 0)
   eq_bit0_unit: eq1   -- Usa o nome declarado do componente 'eq1'
      port map(i0=>a(0), i1=>b(0), eq=>e0);
      
   -- INSTANCIAÇÃO (Bit 1)
   eq_bit1_unit: eq1   -- Usa o nome declarado do componente 'eq1'
      port map(i0=>a(1), i1=>b(1), eq=>e1);
      
   -- Lógica Final (AND)
   aeqb <= e0 and e1;
   
end vhd_87_arch;


a1a0 b1b0 aeqb
00   00    1
00   01    0
00   10    0
00   11    0
01   00    0
01   01    1
01   10    0
01   11    0
10   00    0
10   01    0
10   10    0
10   11    0
11   00    0
11   01    0
11   10    0
11   11    1

aeqb = (A_1' B_1' A_0' B_0') + (A_1' B_1' A_0 B_0) + (A_1 B_1 A_0' B_0') + (A_1 B_1 A_0 B_0)}

e_1 = (A_1 = B_1)$ e $e_0 = (A_0 = B_0)$.
aeqb = e_1 . e0
aeqb = [(A_1' B_1') + (A_1 B_1)] . [(A_0' B_0') + (A_0 B_0)]}