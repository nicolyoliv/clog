library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port(
    clk :   in std_logic; -- Clock de entrada (geralmente 50 MHz em FPGAs de baixo custo)
    sw :    in std_logic_vector(15 downto 0); -- Entradas de switches, usadas para controlar a FSM
    sseg :  out std_logic_vector(7 downto 0); -- Saída para os 8 segmentos do display
    an :    out std_logic_vector(7 downto 0)  -- Saída para os ânodos dos displays
  );
end top;

architecture top_arch of top is
  constant N : integer := 49999999; -- Constante para dividir o clock. Com um clock de 50 MHz, N+1 ciclos
                                   -- correspondem a 1 segundo.
  signal divide_clk : integer range 0 to N; -- Contador para a divisão de frequência.
  signal enable : std_logic;              -- Sinal para habilitar a FSM (FSM 'enable' na listagem 5.1).
begin
  -- Instanciação da FSM.
  -- Este componente é o responsável por controlar o display.
  fsm_unit: entity work.fsm_sseg(two_seg_arch)
    port map(
      clk => clk,             -- Conecta o clock principal da placa
      reset => '0',           -- Reset é mantido em '0' (não há reset externo conectado)
      -- 'in0' a 'in7' são os padrões dos segmentos. O valor "10011100" corresponde ao '0' no display (anodo comum)
      -- '10100011' corresponde ao '1' no display.
      -- A FSM alternará entre 4 displays mostrando '0' e 4 displays mostrando '1'.
      in0 => "10011100",
      in1 => "10011100",
      in2 => "10011100",
      in3 => "10011100",
      in4 => "10100011",
      in5 => "10100011",
      in6 => "10100011",
      in7 => "10100011",
      an => an,               -- Conecta a saída 'an' da FSM à saída 'an' do módulo 'top'
      sseg => sseg,           -- Conecta a saída 'sseg' da FSM à saída 'sseg' do módulo 'top'
      enable => enable,       -- Conecta o sinal 'enable' (gerado pelo divisor de clock) à FSM
      en => sw(0),            -- Conecta o switch 0 para controlar a habilitação do contador de estado
      cw => sw(1)             -- Conecta o switch 1 para controlar a direção do contador
    );

  -- Lógica para o divisor de frequência.
  -- 'enable' fica em '1' apenas quando 'divide_clk' atinge o valor de N.
  -- Isso cria um pulso 'enable' muito lento, fazendo a FSM de multiplexação
  -- atualizar o estado muito lentamente (uma vez por segundo), ao invés de
  -- atualizar na frequência da multiplexação real (kHz).
  -- A multiplexação idealmente deveria ser muito mais rápida para evitar o efeito "pisca-pisca".
  enable <= '1' when divide_clk = N else '0'; 
  
  -- Processo do contador de clock. É um contador síncrono.
  process (clk)
  begin
    if (clk'event and clk='1') then
      divide_clk <= divide_clk+1;
      if divide_clk = N then
        divide_clk <= 0;
      end if;
    end if;
  end process;
end top_arch;
