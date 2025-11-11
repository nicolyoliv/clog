--Listing 3.2
library ieee;
use ieee.std_logic_1164.all;
entity decoder_2_4 is
   port(
      a  : in  std_logic_vector(1 downto 0);
      en : in  std_logic;
      y  : out std_logic_vector(3 downto 0)
   );
end decoder_2_4;

architecture cond_arch of decoder_2_4 is
begin
   -- [EQUAÇÃO LÓGICA: Y = Y(A, EN)]
   -- A ordem impõe a prioridade: Se EN=0 (primeira condição), as outras são ignoradas.
   y <= "0000" when (en = '0') else  -- Se EN é '0', desabilita tudo (Y = 0000).
        "0001" when (a = "00") else  -- Se EN é '1' e A="00", ativa Y0.
        "0010" when (a = "01") else  -- Se EN é '1' e A="01", ativa Y1.
        "0100" when (a = "10") else  -- Se EN é '1' e A="10", ativa Y2.
        "1000";                      -- Se EN é '1' e A="11" (o caso restante), ativa Y3.
end cond_arch;

architecture sel_arch of decoder_2_4 is
   signal s : std_logic_vector(2 downto 0); -- Sinal interno: S = EN, A1, A0
begin
   s               <= en & a; -- Concatena EN com A para formar o seletor S.
   
   -- [EQUAÇÃO LÓGICA: MUX de 8 entradas]
   with s select y <=
      "0000" when "000" | "001" | "010" | "011", -- S = "0XX" (EN=0): Y = 0000.
      "0001" when "100",                         -- S = "100" (EN=1, A=00): Y = 0001 (Y0 ativo).
      "0010" when "101",                         -- S = "101" (EN=1, A=01): Y = 0010 (Y1 ativo).
      "0100" when "110",                         -- S = "110" (EN=1, A=10): Y = 0100 (Y2 ativo).
      "1000" when others;                        -- S = "111" (EN=1, A=11): Y = 1000 (Y3 ativo).
end sel_arch;

architecture if_arch of decoder_2_4 is
begin
   process(en, a) -- Lista de sensibilidade: o process é executado quando EN ou A muda.
   begin
      -- [EQUAÇÃO LÓGICA: Implementação sequencial da prioridade]
      if (en = '0') then       -- Prioridade: Se EN='0', desliga.
         y <= "0000";
      elsif (a = "00") then    -- Se EN='1' e A="00", ativa Y0.
         y <= "0001";
      elsif (a = "01") then    -- Se EN='1' e A="01", ativa Y1.
         y <= "0010";
      elsif (a = "10") then    -- Se EN='1' e A="10", ativa Y2.
         y <= "0100";
      else                     -- O caso restante: EN='1' e A="11".
         y <= "1000";
      end if;
   end process;
end if_arch;

--Listing 3.8
architecture case_arch of decoder_2_4 is
   signal s : std_logic_vector(2 downto 0);
begin
   s <= en & a;
   process(s)
   begin
      case s is
         when "000" | "001" | "010" | "011" =>
            y <= "0001";
         when "100" =>
            y <= "0001";
         when "101" =>
            y <= "0010";
         when "110" =>
            y <= "0100";
         when others =>
            y <= "1000";
      end case;
   end process;
end case_arch;