library ieee;
use ieee.std_logic_1164.all;

entity hex_to_sseg is
   port(
      hex  : in  std_logic_vector(3 downto 0); -- Entrada: Valor hexadecimal (0 a 15)
      dp   : in  std_logic; -- Entrada: Ponto decimal (DP)
      sseg : out std_logic_vector(7 downto 0) -- Saída: 7 segmentos (sseg(6 downto 0)) + DP (sseg(7))
   );
end hex_to_sseg;

architecture arch of hex_to_sseg is
begin
   -- Atribuição concorrente selecionada (WITH...SELECT) para mapear o valor HEX para o padrão de 7 segmentos.
   with hex select
      sseg(6 downto 0) <= -- Mapeia os 7 segmentos (a - g). Note que sseg(6) é 'g', sseg(0) é 'a'.
         "1000000" when "0000", -- '0': a,b,c,d,e,f ON. g OFF.
         "1111001" when "0001", -- '1': b,c ON. a,d,e,f,g OFF.
         "0100100" when "0010", -- '2'
         "0110000" when "0011", -- '3'
         "0011001" when "0100", -- '4'
         "0010010" when "0101", -- '5'
         "0000010" when "0110", -- '6'
         "1111000" when "0111", -- '7'
         "0000000" when "1000", -- '8'
         "0010000" when "1001", -- '9'
         "0001000" when "1010", -- 'A'
         "0000011" when "1011", -- 'B' (b minúsculo)
         "1000110" when "1100", -- 'C' (C maiúsculo)
         "0100001" when "1101", -- 'D' (d minúsculo)
         "0000110" when "1110", -- 'E'
         "0001110" when others; -- 'F' e qualquer outro valor (X)

   sseg(7) <= dp; -- O bit sseg(7) é dedicado ao Ponto Decimal (DP).
end arch;

Hex (H3 H2 H1 H0),Display,sseg6​sseg5​sseg4​sseg3​sseg2​sseg1​sseg0​
0000,0,1000000
0001,1,1111001
1000,8,0000000
1010,A,0001000
1111,F,0001110

Equação Lógica (Exemplo para Segmento 'a' = $sseg_0$):O segmento 'a' é ativado ('0') para os dígitos 0, 2, 3, 5, 6, 7, 8, 9, A, C, D, E, F.$$\mathbf{sseg_0 = (H_3 H_2 H_1 H_0)' \cdot \text{Função de Min-Termos dos valores ON para a}} \text{(Negada)}$$