library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entidade: Contador binário que pode ser configurado com um número N de bits
entity free_run_bin_counter is
   generic(N : integer := 8); -- Parâmetro genérico para definir a largura do contador (padrão é 8)
   port(
      clk      : in  std_logic;
      reset    : in  std_logic;
      enable   : in  std_logic;
      max_tick : out std_logic;
      q        : out std_logic_vector(N-1 downto 0)
   );
end free_run_bin_counter;

architecture arch of free_run_bin_counter is
   signal r_reg  : unsigned(N-1 downto 0); -- Sinal de registrador para o valor atual da contagem
   signal r_next : unsigned(N-1 downto 0); -- Sinal para o próximo valor da contagem
begin
   -- Processo do Registrador: armazena o estado atual do contador
   process(clk,reset)
   begin
      if (reset='1') then
         r_reg <= (others=>'0'); -- Reseta o contador para zero
      elsif (clk'event and clk='1') then
         if (enable='1') then
            r_reg <= r_next; -- Atualiza o contador apenas quando 'enable' é alto
         end if;
      end if;
   end process;
   
   -- Lógica do Próximo Estado: incrementa o valor atual
   r_next <= r_reg + 1;
   
   -- Lógica de Saída
   q <= std_logic_vector(r_reg); -- Converte o valor da contagem para std_logic_vector
   -- Ativa 'max_tick' quando o contador atinge o valor máximo
   max_tick <= '1' when r_reg=(2**N - 1) else '0';
end arch;