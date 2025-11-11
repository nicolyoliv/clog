library ieee;
use ieee.std_logic_1164.all;

entity fsm_carPark is
   port(
      clk, reset, enable  : in  std_logic;       -- Clock, reset e habilitação.
      a, b                : in  std_logic;       -- Entradas dos dois sensores (já limpos).
      car_enter, car_exit : out  std_logic        -- Saídas para incrementar/decrementar a contagem.
   );
end fsm_carPark;

architecture moore_arch of fsm_carPark is
   -- Define os estados da FSM para as sequências de entrada e saída.
   type eg_state_type is (start, a_on, ab_on, b_on, up, b_on2, ba_on, a_on2, down);
   signal state_reg, state_next : eg_state_type;
begin
   -- Processo síncrono para o registrador de estado.
   process(clk, reset)
   begin
      if (reset = '1') then
         state_reg <= start;                     -- Estado inicial de espera.
      elsif (clk'event and clk = '1') then
         if (enable = '1') then
            state_reg <= state_next;
         end if;
      end if;
   end process;

   -- Processo combinacional para a lógica de próximo estado e saídas.
   process(state_reg, a, b)
   begin
      state_next <= state_reg;                   -- Padrão: permanece no mesmo estado.
      car_enter <= '0';                          -- Padrão de saída.
      car_exit <= '0';                           -- Padrão de saída.

      case state_reg is
            -- Estado inicial: aguardando um evento.
            when start =>
               if (a = '1') then
                  state_next <= a_on;          -- Possível entrada de carro (sensor 'a' primeiro).
               elsif(a = '0' and b = '1') then
                  state_next <= b_on2;         -- Possível saída de carro (sensor 'b' primeiro).
               end if;
            
            -- Sequência de entrada (car_enter)
            when a_on =>
               if (a = '1' and b = '1') then
                  state_next <= ab_on;         -- Ambos os sensores ativados.
               elsif(a = '0') then
                  state_next <= start;         -- Sensor 'a' desativado, falha na sequência.
               end if;
            when ab_on =>
               if (a = '0' and b = '1') then
                  state_next <= b_on;          -- Sensor 'a' desativado, só 'b' ligado.
               elsif(b = '0') then
                  state_next <= a_on;          -- Sensor 'b' desativado, volta ao estado anterior.
               end if;
            when b_on =>
               if (b = '0') then
                  state_next <= up;            -- Sensor 'b' desativado, sequência de entrada completa.
               elsif(a = '1' and b = '1') then
                  state_next <= ab_on;         -- Sensores ativados novamente.
               end if;
            when up =>
               car_enter <= '1';               -- Pulso de saída para incrementar a contagem.
               state_next <= start;            -- Volta ao estado inicial.

            -- Sequência de saída (car_exit)
            when b_on2 =>
               if (a = '1' and b = '1') then
                  state_next <= ba_on;         -- Ambos os sensores ativados.
               elsif(b = '0') then
                  state_next <= start;         -- Sensor 'b' desativado, falha na sequência.
               end if;
            when ba_on =>
               if (a = '1' and b = '0') then
                  state_next <= a_on2;         -- Sensor 'b' desativado, só 'a' ligado.
               elsif(a = '0') then
                  state_next <= b_on2;         -- Sensor 'a' desativado, volta ao estado anterior.
               end if;
            when a_on2 =>
               if (a = '0') then
                  state_next <= down;          -- Sensor 'a' desativado, sequência de saída completa.
               elsif(a = '1' and b = '1') then
                  state_next <= ba_on;         -- Sensores ativados novamente.
               end if;
            when down =>
               car_exit <= '1';                -- Pulso de saída para decrementar a contagem.
               state_next <= start;            -- Volta ao estado inicial.    
      end case;
   end process;
end moore_arch;