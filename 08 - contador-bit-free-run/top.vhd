library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Módulo top-level que integra o contador e o divisor de frequência
entity top is
    Port ( clk : in STD_LOGIC;  -- Entrada de clock do FPGA (ex: 50 MHz)
           led : out STD_LOGIC_VECTOR (8 downto 0)); -- 9 LEDs de saída (8 para a contagem + 1 para o max_tick)
end top;

architecture lab8 of top is
constant N : integer := 49999999; -- Valor para a divisão do clock (50,000,000 - 1)
signal enable : std_logic;        -- Sinal de habilitação para o contador
signal divide_clk : integer range 0 to N; -- Contador para o divisor de frequência
begin

-- Instancia o contador binário, configurado para 8 bits por padrão
bin_counter_unit_0 : entity work.free_run_bin_counter
      port map(
                clk      => clk,
                reset    => '0',               -- Não usa reset
                enable   => enable,            -- Conectado ao sinal gerado pelo divisor
                max_tick => led(8),            -- O nono LED mostra quando o contador atingiu o valor máximo
                q        => led(7 downto 0)    -- Os 8 primeiros LEDs mostram o valor da contagem
                );
    
     -- Lógica de Geração do Sinal 'enable'
     enable <= '1' when divide_clk = N else '0';
     
     -- Processo para o Divisor de Frequência
     PROCESS (clk)
        BEGIN
            IF (clk'EVENT AND clk='1') THEN -- Na borda de subida do clock
                divide_clk <= divide_clk+1; -- Incrementa o contador
                IF divide_clk = N THEN
                    divide_clk <= 0;        -- Reinicia o contador ao atingir o valor N
                END IF;
            END IF;
     END PROCESS;

end lab8;
Resumo do Funcionamento do Projeto

O projeto é um contador binário de 8 bits que opera em uma frequência extremamente baixa, exibindo o seu valor em LEDs. A baixa frequência é obtida através de um divisor de frequência implementado com um contador. O sistema é síncrono, operando na borda de subida do clock do FPGA. O valor da contagem (de 0 a 255) é exibido em 8 LEDs, e um LED extra é ativado quando o contador atinge seu valor máximo.