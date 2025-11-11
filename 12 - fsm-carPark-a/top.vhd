library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port(
    clk : in std_logic; -- Clock de entrada do sistema
    sw  : in std_logic_vector(1 downto 0); -- Entradas de switches, que representam os sensores do estacionamento
    led : out std_logic_vector(1 downto 0) -- Saídas para LEDs, indicando entrada ou saída de carro
  );
end top;

architecture top_arch of top is
  constant N : integer := 49999999; -- Constante para o divisor de frequência. Com um clock de 50 MHz,
                                   -- isso cria um pulso 'enable' a cada 1 segundo.
  signal divide_clk : integer range 0 to N; -- Contador para dividir a frequência do clock
  signal enable : std_logic;              -- Sinal de habilitação para a FSM
begin
  -- Instanciação da Máquina de Estados Finita (FSM) de controle do estacionamento.
  fsm_unit: entity work.fsm_carPark(moore_arch)
    port map(
      clk => clk,             -- Conecta o clock principal
      reset => '0',           -- Reset é mantido desativado
      enable => enable,       -- A FSM só avança de estado quando 'enable' é '1' (a cada segundo)
      a => sw(1),             -- Conecta o sensor 'a' ao switch sw(1)
      b => sw(0),             -- Conecta o sensor 'b' ao switch sw(0)
      car_enter => led(1),    -- Saída 'car_enter' conectada ao LED 1
      car_exit => led(0)      -- Saída 'car_exit' conectada ao LED 0
    );
  
  -- Lógica do divisor de frequência.
  -- O sinal 'enable' é ativado apenas por um ciclo de clock quando o contador 'divide_clk' atinge 'N'.
  -- Isso torna as transições da FSM mais lentas, permitindo que a simulação e os LEDs sejam observados.
  enable <= '1' when divide_clk = N else '0'; 
  
  -- Processo síncrono para o contador de clock.
  process (clk)
  begin
    if (clk'event and clk='1') then -- Na borda de subida do clock
      divide_clk <= divide_clk+1;    -- Incrementa o contador
      if divide_clk = N then         -- Se o contador atinge o limite
        divide_clk <= 0;             -- Reseta o contador
      end if;
    end if;
  end process;
end top_arch;
s
