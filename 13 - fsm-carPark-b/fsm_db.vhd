library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_db is
   port(
      clk   : in std_logic;  -- Clock do sistema.
      reset : in std_logic;  -- Reset assíncrono.
      sw    : in std_logic;  -- Entrada ruidosa do botão.
      db    : out std_logic  -- Saída filtrada e limpa.
   );
end fsm_db;

architecture arch of fsm_db is
   -- Constante para o contador que gera um "tick" de 10ms.
   constant N: integer := 20; 
   -- Estados da FSM para o processo de estabilização do sinal.
   type db_state_type is 
         (zero,wait1_1,wait1_2,wait1_3,one,wait0_1,wait0_2,wait0_3);
   signal q_reg, q_next : unsigned(N-1 downto 0);
   signal m_tick        : std_logic;
   signal state_reg     : db_state_type;
   signal state_next    : db_state_type;
begin
   -- Processo síncrono para o contador de tempo.
   process(clk)
   begin
      if (clk'event and clk='1') then
         q_reg <= q_next;
      end if;
   end process;
   q_next <= q_reg + 1;
   m_tick <= '1' when q_reg=0 else '0';  -- Pulso a cada 10ms.

   -- Processo síncrono para o registrador de estado da FSM.
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= zero;
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
      end if;
   end process;

   -- Processo combinacional para a lógica de debounce.
   process(state_reg,sw,m_tick)
   begin
      state_next <= state_reg;
      db <= '0';   -- Saída padrão.
      case state_reg is
         -- Estado 'zero': sinal baixo e estável.
         when zero =>
            if sw='1' then
               state_next <= wait1_1;    -- Inicia a espera pela estabilização em '1'.
            end if;
         when wait1_1 =>
            if sw='0' then
               state_next <= zero;
            elsif m_tick='1' then
               state_next <= wait1_2;
            end if;
         when wait1_2 =>
            if sw='0' then
               state_next <= zero;
            elsif m_tick='1' then
               state_next <= wait1_3;
            end if;
         when wait1_3 =>
            if sw='0' then
               state_next <= zero;
            elsif m_tick='1' then
               state_next <= one;      -- Sinal estável, muda para o estado 'one'.
            end if;
         -- Estado 'one': sinal alto e estável.
         when one =>
            db <='1';                 -- A saída é '1'.
            if sw='0' then
               state_next <= wait0_1; -- Inicia a espera pela estabilização em '0'.
            end if;
         when wait0_1 =>
            db <='1';
            if sw='1' then
               state_next <= one;
            elsif m_tick='1' then
               state_next <= wait0_2;
            end if;
         when wait0_2 =>
            db <='1';
            if sw='1' then
               state_next <= one;
            elsif m_tick='1' then
               state_next <= wait0_3;
            end if;
         when wait0_3 =>
            db <='1';
            if sw='1' then
               state_next <= one;
            elsif m_tick='1' then
               state_next <= zero;    -- Sinal estável, muda para o estado 'zero'.
            end if;
      end case;
   end process;
end arch;