library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity disp_hex_mux is
   port(
      clk, reset : in  std_logic;
      hex3, hex2 : in  std_logic_vector(3 downto 0); -- Dados de 4 bits para cada dígito.
      hex1, hex0 : in  std_logic_vector(3 downto 0);
      dp_in      : in  std_logic_vector(3 downto 0); -- Ponto decimal para cada dígito.
      an         : out std_logic_vector(3 downto 0); -- Seleção de dígito (ânodo).
      sseg       : out std_logic_vector(7 downto 0)  -- Saída para os segmentos.
   );
end disp_hex_mux;

architecture arch of disp_hex_mux is
   -- Constante para o contador de multiplexação.
   constant N    : integer := 18;
   signal q_reg  : unsigned(N - 1 downto 0);
   signal q_next : unsigned(N - 1 downto 0);
   signal sel    : std_logic_vector(1 downto 0); -- Sinal de seleção (2 bits para 4 dígitos).
   signal hex    : std_logic_vector(3 downto 0); -- Dado hexadecimal a ser exibido.
   signal dp     : std_logic;                    -- Ponto decimal a ser exibido.
begin
   -- Processo síncrono para o contador de multiplexação.
   process(clk, reset)
   begin
      if reset = '1' then
         q_reg <= (others => '0');
      elsif (clk'event and clk = '1') then
         q_reg <= q_next;
      end if;
   end process;
   
   -- Lógica de próximo estado do contador.
   q_next <= q_reg + 1;
   -- Os 2 bits mais significativos do contador selecionam o dígito.
   sel <= std_logic_vector(q_reg(N - 1 downto N - 2));
   
   -- Processo combinacional de multiplexação.
   process(sel, hex0, hex1, hex2, hex3, dp_in)
   begin
      case sel is
         when "00" => -- Seleciona o dígito 0.
            an(3 downto 0) <= "1110"; -- Habilita o 1º dígito.
            hex            <= hex0;
            dp             <= dp_in(0);
         when "01" => -- Seleciona o dígito 1.
            an(3 downto 0) <= "1101";
            hex            <= hex1;
            dp             <= dp_in(1);
         when "10" => -- Seleciona o dígito 2.
            an(3 downto 0) <= "1011";
            hex            <= hex2;
            dp             <= dp_in(2);
         when others => -- Seleciona o dígito 3.
            an(3 downto 0) <= "0111";
            hex            <= hex3;
            dp             <= dp_in(3);
      end case;
   end process;
   
   -- Decodificador de hexadecimal para 7 segmentos (lógica combinacional).
   with hex select 
      sseg(6 downto 0) <= -- Os 7 bits de sseg controlam os segmentos 'a' a 'g'.
         "1000000" when "0000", -- '0'
         "1111001" when "0001", -- '1'
         "0100100" when "0010", -- '2'
         "0110000" when "0011", -- '3'
         "0011001" when "0100", -- '4'
         "0010010" when "0101", -- '5'
         "0000010" when "0110", -- '6'
         "1111000" when "0111", -- '7'
         "0000000" when "1000", -- '8'
         "0010000" when "1001", -- '9'
         "0001000" when "1010", -- 'A'
         "0000011" when "1011", -- 'B'
         "1000110" when "1100", -- 'C'
         "0100001" when "1101", -- 'D'
         "0000110" when "1110", -- 'E'
         "0001110" when others; -- 'F'
         
   -- O bit 7 de sseg controla o ponto decimal (dp).
   sseg(7) <= dp;
end arch;

Esse conjunto de códigos VHDL cria um sistema completo para contar o número de vezes que um botão é pressionado, mas com uma inteligência extra: ele elimina os "quiques" elétricos (o chamado debounce). Quando você pressiona um botão físico, o contato não é perfeito e ele gera uma série de sinais "ligado-desligado" muito rápidos, em vez de uma transição única e limpa.

O sistema faz o seguinte:

    Conta os "quiques" (o que não queremos): Um contador mostra a contagem exata dos pulsos ruidosos gerados pelo botão. Este número será muito maior do que a quantidade de vezes que você realmente pressionou.

    Conta a ação real (o que queremos): Outro contador mostra a contagem filtrada e correta, ou seja, o número de vezes que você de fato pressionou o botão.

    Exibe os resultados: Os valores dos dois contadores são mostrados em um display de 4 dígitos de 7 segmentos.