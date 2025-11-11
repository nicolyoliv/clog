library ieee;
use ieee.std_logic_1164.all;

-- A entidade 'fsm_carPark' é uma FSM que detecta a direção do carro
-- com base na sequência de ativação dos sensores 'a' e 'b'.
entity fsm_carPark issss
  port(
    clk, reset, enable  : in  std_logic; -- Clock, reset e enable do registrador de estado
    a, b                : in  std_logic; -- Entradas dos sensores (switches)
    car_enter, car_exit : out std_logic   -- Saídas que indicam entrada ou saídaSs
  );
end fsm_carPark;

-- Lógica interna da arquitetura 'moore_arch'
architecture moore_arch of fsm_carPark is
  -- Define os estados da FSM para detectar as sequências de sensores.
  type eg_state_type is (start, a_on, ab_on, b_on, up, b_on2, ba_on, a_on2, down);
  signal state_reg, state_next : eg_state_type;
begin
  -- Processo do registrador de estado (síncrono)
  process(clk, reset)
  begin
    if (reset = '1') then
      state_reg <= start; -- Estado inicial ao resetar
    elsif (clk'event and clk = '1') then -- Na borda de subida do clock
      if (enable = '1') then            -- Se a FSM está habilitada
        state_reg <= state_next;       -- O estado atual se torna o próximo estado
      end if;
    end if;
  end process;
  
  -- Processo de lógica combinacional para determinar o próximo estado e as saídas.
  process(state_reg, a, b)
  begin
    state_next <= state_reg; -- Padrão: o próximo estado é o estado atual, a menos que uma condição mude.
    
    -- Lógica de saída (Moore) e transição de estado.
    case state_reg is
      when start => -- Estado inicial: nenhum sensor está ativo
        car_enter <= '0';
        car_exit <= '0';
        if (a = '1') then
          state_next <= a_on; -- 'a' ativou primeiro: possível entrada
        elsif(a = '0' and b = '1') then
          state_next <= b_on2; -- 'b' ativou primeiro: possível saída
        else -- not(a) and not(b)
          state_next <= start; -- Permanece no estado inicial
        end if;
        
      -- Sequência para ENTRADA de carro: a -> a&b -> b -> up
      when a_on => -- 'a' está ativo, 'b' não
        car_enter <= '0';
        car_exit <= '0';
        if (a = '1' and b = '1') then
          state_next <= ab_on;
        elsif(a = '0') then
          state_next <= start; -- Erro na sequência, volta ao início
        else -- a = '1' and b = '0'
          state_next <= a_on;
        end if;
        
      when ab_on => -- Ambos 'a' e 'b' estão ativos
        car_enter <= '0';
        car_exit <= '0';
        if (a = '0' and b = '1') then
          state_next <= b_on;
        elsif(b = '0') then
          state_next <= a_on; -- Erro, 'b' desativou primeiro, volta ao estado anterior
        else -- a = '1' and b = '1'
          state_next <= ab_on;
        end if;
        
      when b_on => -- 'b' está ativo, 'a' não
        car_enter <= '0';
        car_exit <= '0';
        if (b = '0') then
          state_next <= up; -- Sequência completa: 'b' desativou por último
        elsif(a = '1' and b = '1') then
          state_next <= ab_on; -- Erro, 'a' ativou de novo
        else -- a = '0' and b = '1'
          state_next <= b_on;
        end if;
        
      when up => -- Estado final de ENTRADA
        car_enter <= '1'; -- Sinaliza a entrada do carro
        car_exit <= '0';
        state_next <= start; -- Volta ao estado inicial
        
      -- Sequência para SAÍDA de carro: b -> a&b -> a -> down
      when b_on2 => -- 'b' está ativo, 'a' não
        car_enter <= '0';
        car_exit <= '0';
        if (a = '1' and b = '1') then
          state_next <= ba_on;
        elsif(b = '0') then
          state_next <= start; -- Erro na sequência
        else -- a = '0' and b = '1'
          state_next <= b_on2;
        end if;
        
      when ba_on => -- Ambos 'a' e 'b' estão ativos
        car_enter <= '0';
        car_exit <= '0';
        if (a = '1' and b = '0') then
          state_next <= a_on2;
        elsif(a = '0') then
          state_next <= b_on2; -- Erro, 'a' desativou primeiro
        else -- a = '1' and b = '1'
          state_next <= ba_on;
        end if;
        
      when a_on2 => -- 'a' está ativo, 'b' não
        car_enter <= '0';
        car_exit <= '0';
        if (a = '0') then
          state_next <= down; -- Sequência completa: 'a' desativou por último
        elsif(a = '1' and b = '1') then
          state_next <= ba_on; -- Erro, 'b' ativou de novo
        else -- a = '1' and b = '0'
          state_next <= a_on2;
        end if;
        
      when down => -- Estado final de SAÍDA
        car_enter <= '0';
        car_exit <= '1'; -- Sinaliza a saída do carro
        state_next <= start; -- Volta ao estado inicial
    end case;
  end process;
end moore_arch;
