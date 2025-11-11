library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_dispHexMux is
   port(
      clk, reset : in  std_logic;
      hex_in     : in  std_logic_vector(3 downto 0); -- Dígito menos significativo.
      hex_in2    : in  std_logic_vector(3 downto 0); -- Dígito mais significativo.
      dp_in      : in  std_logic_vector(7 downto 0); -- Controle do ponto decimal (dp).
      an         : out std_logic_vector(7 downto 0); -- Seleção do dígito (anodo).
      sseg       : out std_logic_vector(7 downto 0)  -- Saída para os segmentos.
   );
end fsm_dispHexMux;

architecture arch of fsm_dispHexMux is
   -- Constante para o contador de multiplexação.
   constant N    : integer := 18;
   signal q_reg  : unsigned(N - 1 downto 0);
   signal q_next : unsigned(N - 1 downto 0);
   signal sel    : std_logic_vector(1 downto 0);     -- Sinal de seleção (2 bits para 4 displays, mas só 2 são usados).
   signal hex    : std_logic_vector(3 downto 0);
   signal dp     : std_logic;
begin
   -- Processo síncrono para o contador de multiplexação.
   process(clk, reset)
   begin
      if reset = '1' then
         q_reg <= (others => '0');
      elsif (clk'event and clk = '1') then
         q_reg <= q_next;
      end if;
   end process;
   q_next <= q_reg + 1;
   sel <= std_logic_vector(q_reg(N - 1 downto N - 2));

   -- Processo combinacional para a multiplexação.
   process(sel, hex_in, hex_in2, dp_in)
   begin
      case sel is
         when "00" =>
            an(7 downto 0) <= "11111110"; -- Habilita o primeiro display.
            hex            <= hex_in;
            dp             <= dp_in(0);
         when others =>
            an(7 downto 0) <= "11111101"; -- Habilita o segundo display.
            hex            <= hex_in2;
            dp             <= dp_in(1);
      end case;
   end process;

   -- Decodificador de hexadecimal para 7 segmentos.
   with hex select 
      sseg(6 downto 0) <=
         "1000000" when "0000", -- '0'
         "1111001" when "0001", -- '1'
         "0100100" when "0010", -- '2'
         "0110000" when "0011", -- '3'
         "0011001" when "0100", -- '4'
         "0010010" when "0101", -- '5'
         "0000010" when "0110", -- '6'
         "1111000" when "0111", -- '7'
         "0000000" when "1000", -- '8'
         "0010000" when others;   -- '9'
   
   sseg(7) <= dp; -- Ponto decimal.
end arch;