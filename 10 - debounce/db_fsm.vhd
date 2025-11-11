library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity db_fsm is
   port(
      clk   : in std_logic;  -- Clock do sistema para sincronização.
      reset : in std_logic;  -- Reset assíncrono para inicializar a FSM.
      sw    : in std_logic;  -- Entrada ruidosa do botão (o sinal com "ruído").
      db    : out std_logic  -- Saída do botão já filtrada (sinal limpo e estável).
   );
end db_fsm;

architecture arch of db_fsm is
   -- Constante para definir o período do "tick" do contador.
   -- 2^N * 10ns (período do clk) = tempo de espera (ex: 10ms)
   constant N: integer := 20;
   
   -- Tipos de estados da FSM para o processo de debounce.
   type db_state_type is 
         (zero, wait1_1, wait1_2, wait1_3, one, wait0_1, wait0_2, wait0_3);
   
   signal q_reg, q_next : unsigned(N-1 downto 0); -- Sinais para o contador.
   signal m_tick        : std_logic;             -- Sinal de pulso gerado pelo contador.
   signal state_reg     : db_state_type;         -- Registrador do estado atual.
   signal state_next    : db_state_type;         -- Sinal para o próximo estado.
begin
   --*****************************************************************
   -- Contador para gerar um pulso (tick) de 10ms
   --*****************************************************************
   process(clk)
   begin
      if (clk'event and clk='1') then
         q_reg <= q_next;
      end if;
   end process;
   -- Lógica de próximo estado para o contador.
   q_next <= q_reg + 1;
   -- O 'tick' é um pulso de 1 ciclo quando o contador atinge 0 (após ter completado um ciclo).
   m_tick <= '1' when q_reg=0 else '0';
   
   --*****************************************************************
   -- FSM do Debounce
   --*****************************************************************
   -- Processo síncrono para o registrador de estado.
   process(clk,reset)
   begin
      if (reset='1') then  -- Reset assíncrono.
         state_reg <= zero;
      elsif (clk'event and clk='1') then -- Borda de subida do clock.
         state_reg <= state_next;
      end if;
   end process;
   
   -- Processo combinacional para a lógica de próximo estado e saída.
   process(state_reg,sw,m_tick)
   begin
      state_next <= state_reg; -- Padrão: permanece no mesmo estado.
      db <= '0';   -- Padrão: saída do botão limpa é '0'.
      
      case state_reg is
         -- Estado 'zero': botão solto (sinal baixo) e estável.
         when zero =>
            if sw='1' then
               state_next <= wait1_1; -- Transiciona se o botão for pressionado.
            end if;
         -- Estados de espera: o sinal mudou, aguardando estabilização.
         when wait1_1 =>
            if sw='0' then -- Se o sinal voltar a '0', era ruído, então retorna.
               state_next <= zero;
            else
               if m_tick='1' then -- Se o sinal se mantiver '1' por 1 tick, avança.
                  state_next <= wait1_2;
               end if;
            end if;
         when wait1_2 =>
            if sw='0' then
               state_next <= zero;
            else
               if m_tick='1' then
                  state_next <= wait1_3;
               end if;
            end if;
         when wait1_3 =>
            if sw='0' then
               state_next <= zero;
            else
               if m_tick='1' then
                  state_next <= one; -- Após 4 ticks, o sinal está estável, transiciona.
               end if;
            end if;
         -- Estado 'one': botão pressionado (sinal alto) e estável.
         when one =>
            db <='1'; -- A saída limpa é '1'.
            if sw='0' then
               state_next <= wait0_1; -- Transiciona se o botão for solto.
            end if;
         when wait0_1 =>
            db <='1';
            if sw='1' then
               state_next <= one;
            else
               if m_tick='1' then
                  state_next <= wait0_2;
               end if;
            end if;
         when wait0_2 =>
            db <='1';
            if sw='1' then
               state_next <= one;
            else
               if m_tick='1' then
                  state_next <= wait0_3;
               end if;
            end if;
         when wait0_3 =>
            db <='1';
            if sw='1' then
               state_next <= one;
            else
               if m_tick='1' then
                  state_next <= zero; -- Após 4 ticks, o sinal está estável, transiciona.
               end if;
            end if;
      end case;
   end process;
end arch;