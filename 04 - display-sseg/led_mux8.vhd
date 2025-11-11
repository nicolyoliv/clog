library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_mux8 is
   port(
      clk, reset         : in  std_logic; -- CLOCK (Sequencial) e RESET
      in3, in2, in1, in0 : in  std_logic_vector(7 downto 0); -- Entradas de dados (D0 a D3)
      in7, in6, in5, in4 : in  std_logic_vector(7 downto 0); -- Entradas de dados (D4 a D7)
      an                 : out std_logic_vector(7 downto 0); -- Saída para o Anodo (seleciona o display)
      sseg               : out std_logic_vector(7 downto 0) -- Saída para os 7 segmentos
   );
end led_mux8;

architecture arch of led_mux8 is
   constant N           : integer := 18; -- Define o tamanho do contador (para divisão de clock)
   signal q_reg, q_next : unsigned(N - 1 downto 0); -- Contador interno (sequencial)
   signal sel           : std_logic_vector(2 downto 0); -- Sinal de Seleção (3 bits)
begin
   -- ----------------------------------------------------------------------
   -- LÓGICA SEQUENCIAL (Contador)
   -- ----------------------------------------------------------------------
   process(clk, reset)
   begin
      if reset = '1' then
         q_reg <= (others => '0'); -- Zera o contador (Reset Síncrono/Assíncrono, depende da placa)
      elsif rising_edge(clk) then
         q_reg <= q_next; -- Incrementa o contador a cada ciclo de clock
      end if;
   end process;
   
   q_next <= q_reg + 1; -- Lógica do próximo estado (Incremento)
   
   -- O sinal de seleção (sel) é formado pelos 3 bits mais significativos do contador.
   -- Isso garante que o display mude apenas a cada 2^(N-3) ciclos de clock.
   sel <= std_logic_vector(q_reg(N - 1 downto N - 3)); 
   
   -- ----------------------------------------------------------------------
   -- LÓGICA COMBINACIONAL (Multiplexação)
   -- ----------------------------------------------------------------------
   process(sel, in0, in1, in2, in3, in4, in5, in6, in7)
   begin
      case sel is
         when "000" => an <= "11111110"; sseg <= in0; -- D0 Ativo
         when "001" => an <= "11111101"; sseg <= in1; -- D1 Ativo
         when "010" => an <= "11111011"; sseg <= in2; -- D2 Ativo
         when "011" => an <= "11110111"; sseg <= in3; -- D3 Ativo
         when "100" => an <= "11101111"; sseg <= in4; -- D4 Ativo
         when "101" => an <= "11011111"; sseg <= in5; -- D5 Ativo
         when "110" => an <= "10111111"; sseg <= in6; -- D6 Ativo
         when others => an <= "01111111"; sseg <= in7; -- D7 Ativo (sel="111")
      end case;
   end process;
end arch;

Sel (q17 q16 q15),Display Ativo,An (Anodo),Seg. Saída (sseg)
000,0,11111110,in0
001,1,11111101,in1
...,...,...,...
111,7,01111111,in7

Contador (Sequencial): Implementa a equação do contador: $\mathbf{Q_{next} = Q_{reg} + 1}$ (onde a soma é binária de 18 bits).Multiplexador (Combinacional): Implementa a lógica de seleção de display e dado.