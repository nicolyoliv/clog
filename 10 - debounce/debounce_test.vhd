library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity debounce_test is
   port(
      clk  : in  std_logic;  -- Clock do sistema.
      btn  : in  std_logic_vector(1 downto 0); -- Entradas de botões.
      an   : out std_logic_vector(7 downto 0); -- Saídas para controle de displays.
      sseg : out std_logic_vector(7 downto 0) -- Saídas para controle de segmentos.
   );
end debounce_test;

architecture arch of debounce_test is
   -- Contadores de 8 bits para as contagens ruidosa e limpa.
   signal q1_reg, q1_next   : unsigned(7 downto 0); 
   signal q0_reg, q0_next   : unsigned(7 downto 0); 
   -- Versões em std_logic_vector para a exibição.
   signal b_count, d_count  : std_logic_vector(7 downto 0); 
   -- Sinais para detecção de borda.
   signal btn_reg, db_reg   : std_logic;
   -- Sinais de borda de subida.
   signal db_level, db_tick : std_logic;
   signal btn_tick, clr     : std_logic;
begin
   --*****************************************************************
   -- Conexões de saídas e instanciação de componentes.
   --*****************************************************************
   -- Habilita apenas os 4 primeiros displays.
   an(7 downto 4)<="1111";
        
   -- Instancia o circuito de display (multiplexador e decodificador).
   disp_unit : entity work.disp_hex_mux
      port map(
         clk   => clk,
         reset => '0',
         hex3  => d_count(7 downto 4), -- Exibe a contagem limpa (mais significativa).
         hex2  => d_count(3 downto 0), -- Exibe a contagem limpa (menos significativa).
         hex1  => b_count(7 downto 4), -- Exibe a contagem ruidosa (mais significativa).
         hex0  => b_count(3 downto 0), -- Exibe a contagem ruidosa (menos significativa).
         dp_in => "1011",
         an    => an(3 downto 0),
         sseg  => sseg
      );
   -- Instancia o circuito de debounce.
   db_unit : entity work.db_fsm(arch)
      port map(
         clk   => clk,
         reset => '0',
         sw    => btn(1), -- Conecta a entrada do botão ruidoso.
         db    => db_level -- Conecta a saída limpa.
      );

   --*****************************************************************
   -- Circuitos de detecção de borda (de subida)
   --*****************************************************************
   process(clk)
   begin
      if (clk'event and clk = '1') then
         btn_reg <= btn(1);     -- Registra o valor ruidoso do botão no ciclo anterior.
         db_reg  <= db_level;   -- Registra o valor limpo do botão no ciclo anterior.
      end if;
   end process;
   -- Lógica para detectar borda de subida: (sinal anterior = 0) E (sinal atual = 1).
   btn_tick <= (not btn_reg) and btn(1);
   db_tick  <= (not db_reg) and db_level;

   --*****************************************************************
   -- Contadores
   --*****************************************************************
   clr <= btn(0); -- O botão btn(0) serve para zerar os contadores.
   process(clk)
   begin
      if (clk'event and clk='1') then
         q1_reg <= q1_next; -- Atualiza o contador ruidoso.
         q0_reg <= q0_next; -- Atualiza o contador limpo.
      end if;
   end process;
   
   -- Lógica de próximo estado para os contadores.
   q1_next <= (others=>'0') when clr='1' else -- Zera se 'clr' for 1.
              q1_reg + 1    when btn_tick='1' else -- Incrementa na borda de subida ruidosa.
              q1_reg;
   q0_next <= (others=>'0') when clr='1' else
              q0_reg + 1    when db_tick='1' else -- Incrementa na borda de subida limpa.
              q0_reg;
              
   -- Saída para os displays.
   b_count <= std_logic_vector(q1_reg);
   d_count <= std_logic_vector(q0_reg);
end arch;