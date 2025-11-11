-- Listing 5.1
library ieee;
use ieee.std_logic_1164.all;

-- A entidade 'fsm_sseg' é um FSM (Máquina de Estados Finita)
-- que controla a multiplexação de displays de 7 segmentos.
entity fsm_sseg is
  port(
    -- Entradas de controle de clock, reset e habilitação do FSM
    clk, reset, enable : in  std_logic;
    
    -- 'en' (enable) e 'cw' (clockwise) são os sinais de controle da transição de estado.
    -- en = '0' pausa a transição; en = '1' permite a transição.
    -- cw = '1' move o estado no sentido horário (s0 -> s1 -> s2...), cw = '0' no sentido anti-horário (s0 -> s7 -> s6...).
    en, cw              : in  std_logic;
    
    -- Entradas de dados para os 8 displays de 7 segmentos.
    -- Cada 'in' é um vetor de 8 bits que representa o padrão do display (anodo comum, por exemplo).
    in3, in2, in1, in0 : in  std_logic_vector(7 downto 0);
    in7, in6, in5, in4 : in  std_logic_vector(7 downto 0);
    
    -- Saídas para controle dos ânodos dos 8 displays de 7 segmentos.
    -- Apenas uma linha estará ativa ('0') por vez, multiplexando os displays.
    an                  : out std_logic_vector(7 downto 0);
    
    -- Saída para os 8 segmentos do display (incluindo o ponto decimal).
    -- Este sinal é o mesmo para todos os displays, mas apenas o display habilitado por 'an' irá mostrá-lo.
    sseg                : out std_logic_vector(7 downto 0)
  );
end fsm_sseg;

-- Listing 5.2
architecture two_seg_arch of fsm_sseg is
  -- Define um novo tipo de dados 'eg_state_type' para os 8 estados da FSM.
  type eg_state_type is (s0, s1, s2, s3, s4, s5, s6, s7);
  
  -- Sinais para armazenar o estado atual ('state_reg') e o próximo estado ('state_next').
  signal state_reg, state_next : eg_state_type;
begin
  -- O primeiro 'process' é o registrador de estado. Ele é síncrono.
  -- Ele armazena o próximo estado na borda de subida do clock ('clk').
  process(clk, reset)
  begin
    if (reset = '1') then
      -- Se o reset é ativado ('1'), o estado volta para o estado inicial 's0'.
      state_reg <= s0;
    elsif (clk'event and clk = '1') then
      -- Na borda de subida do clock...
      if (enable = '1') then
        -- ...se o sinal 'enable' estiver ativo ('1'), o estado atual é atualizado com o próximo estado.
        -- Isso permite pausar a FSM (multiplexação) se 'enable' for '0'.
        state_reg <= state_next;
      end if;
    end if;
  end process;

  -- O segundo 'process' é a lógica de próximo estado e de saída. Ele é combinacional.
  -- A FSM opera como um FSM de Moore, pois as saídas (an e sseg) dependem apenas do estado atual.
  process(state_reg, in0, in1, in2, in3, in4, in5, in6, in7)
  begin
    state_next <= state_reg; -- Atribuição padrão: se nenhuma condição for atendida, o estado se mantém.
    
    -- Define a lógica de saída e transição com base no estado atual.
    case state_reg is
      when s0 =>
        an   <= "11111110"; -- Habilita o display 0 (anodo 0)
        sseg <= in0;        -- Envia os dados de 'in0' para o display
        -- Lógica de próximo estado:
        if en = '0' then
          state_next <= s0;  -- Pausa no estado atual
        elsif cw = '0' then
          state_next <= s7;  -- Se 'cw' é '0', vai para o estado anterior (anti-horário)
        else
          state_next <= s1;  -- Senão, vai para o próximo estado (horário)
        end if;
      when s1 =>
        an   <= "11111101"; -- Habilita o display 1
        sseg <= in1;        -- Envia os dados de 'in1'
        if en = '0' then
          state_next <= s1;
        elsif cw = '0' then
          state_next <= s0; -- Anti-horário
        else
          state_next <= s2; -- Horário
        end if;
      when s2 =>
        an   <= "11111011"; -- Habilita o display 2
        sseg <= in2;
        if en = '0' then
          state_next <= s2;
        elsif cw = '0' then
          state_next <= s1; -- Anti-horário
        else
          state_next <= s3; -- Horário
        end if;
      when s3 =>
        an   <= "11110111"; -- Habilita o display 3
        sseg <= in3;
        if en = '0' then
          state_next <= s3;
        elsif cw = '0' then
          state_next <= s2; -- Anti-horário
        else
          state_next <= s4; -- Horário
        end if;
      when s4 =>
        an   <= "11110111"; -- Habilita o display 4. Observação: este 'an' é igual ao de s3.
        sseg <= in4;
        if en = '0' then
          state_next <= s4;
        elsif cw = '0' then
          state_next <= s3; -- Anti-horário
        else
          state_next <= s5; -- Horário
        end if;
      when s5 =>
        an   <= "11111011"; -- Habilita o display 5
        sseg <= in5;
        if en = '0' then
          state_next <= s5;
        elsif cw = '0' then
          state_next <= s4; -- Anti-horário
        else
          state_next <= s6; -- Horário
        end if;
      when s6 =>
        an   <= "11111101"; -- Habilita o display 6
        sseg <= in6;
        if en = '0' then
          state_next <= s6;
        elsif cw = '0' then
          state_next <= s5; -- Anti-horário
        else
          state_next <= s7; -- Horário
        end if;
      when s7 =>
        an   <= "11111110"; -- Habilita o display 7
        sseg <= in7;
        if en = '0' then
          state_next <= s7;
        elsif cw = '0' then
          state_next <= s6; -- Anti-horário
        else
          state_next <= s0; -- Volta ao estado inicial
        end if;
    end case;
  end process;
end two_seg_arch;

