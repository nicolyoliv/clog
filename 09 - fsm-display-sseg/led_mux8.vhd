library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Módulo responsável por multiplexar a exibição de 8 displays.
entity led_mux8 is
   port(
      clk, reset         : in  std_logic; -- Clock e reset.
      in3, in2, in1, in0 : in  std_logic_vector(7 downto 0); -- Dados de 4 displays.
      in7, in6, in5, in4 : in  std_logic_vector(7 downto 0); -- Dados dos outros 4 displays.
      an                 : out std_logic_vector(7 downto 0); -- Saída de seleção de dígito.
      sseg               : out std_logic_vector(7 downto 0) -- Saída de segmentos.
   );
end led_mux8;

architecture arch of led_mux8 is
   -- Constante para o número de bits do contador, determinando a taxa de multiplexação.
   constant N           : integer := 18;
   signal q_reg, q_next : unsigned(N - 1 downto 0); -- Sinais para o contador.
   signal sel           : std_logic_vector(2 downto 0); -- Sinal de seleção (3 bits).
begin
   -- Processo síncrono que implementa o contador.
   process(clk, reset)
   begin
      if reset = '1' then -- Lógica de reset assíncrono.
         q_reg <= (others => '0');
      elsif (clk'event and clk = '1') then -- Lógica síncrona na borda de subida do clock.
         q_reg <= q_next; -- Atualiza o contador com o próximo valor.
      end if;
   end process;

   -- Lógica combinacional para o próximo estado do contador.
   q_next <= q_reg + 1;

   -- Os 3 bits mais significativos do contador são usados para selecionar o display.
   sel <= std_logic_vector(q_reg(N - 1 downto N - 3));

   -- Lógica combinacional que seleciona o display e os dados a serem exibidos.
   process(sel, in0, in1, in2, in3, in4, in5, in6, in7)
   begin
      case sel is
         when "000" => -- Caso 0, seleciona o primeiro display e seus dados.
            an   <= "11111110";
            sseg <= in0;
         when "001" => -- Caso 1, seleciona o segundo display e seus dados.
            an   <= "11111101";
            sseg <= in1;
         when "010" =>
            an   <= "11111011";
            sseg <= in2;
         when "011" =>
            an   <= "11110111";
            sseg <= in3;
         when "100" =>
            an   <= "11101111";
            sseg <= in4;
         when "101" =>
            an   <= "11011111";
            sseg <= in5;
         when "110" =>
            an   <= "10111111";
            sseg <= in6;
         when others => -- Último caso, seleciona o oitavo display.
            an   <= "01111111";
            sseg <= in7;
      end case;
   end process;
end arch;