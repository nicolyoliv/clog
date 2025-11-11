library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
    port(
        clk, reset, enable : in std_logic;       -- Clock, reset e habilitação.
        inc, dec           : in std_logic;       -- Sinais para incrementar/decrementar.
        counter            : out std_logic_vector(7 downto 0) -- Saída da contagem.
    );
end reg;

architecture arch of reg is
    signal reg        : unsigned(7 downto 0) := (others=>'0');
    signal reg_next   : unsigned(7 downto 0) := (others=>'0');
begin
    -- Processo síncrono para o registrador do contador.
    process(clk,reset)
    begin
       if (reset='1') then
          reg <= (others=>'0');
       elsif (clk'event and clk='1') then
          if (enable='1') then
             reg <= reg_next;
          end if;
       end if;
    end process;
    
    -- Lógica combinacional para o próximo valor do contador.
    process(inc, dec, reg) -- O 'reg' precisa estar na lista de sensibilidade.
    begin
        reg_next <= reg; -- Padrão: mantém o valor.
        if(inc = '1') then
            reg_next <= reg + 1;
        elsif(dec = '1') then
            reg_next <= reg - 1;
        end if;
    end process;

    counter <= std_logic_vector(reg); -- Converte o valor para o formato de saída.
end arch;