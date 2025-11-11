--Listing 3.1
library ieee;
use ieee.std_logic_1164.all;
entity prio_encoder is
   port(
      r     : in  std_logic_vector(4 downto 1);
      pcode : out std_logic_vector(2 downto 0)
   );
end prio_encoder;

architecture cond_arch of prio_encoder is
begin
   -- [EQUAÇÃO LÓGICA: Y = Y(R)]
   -- A ordem do WHEN...ELSE define a prioridade: R4 é testado primeiro.
   pcode <= "100" when (r(4) = '1') else  -- Se R4='1', Pcode="100".
            "011" when (r(3) = '1') else  -- Senão, se R3='1', Pcode="011".
            "010" when (r(2) = '1') else  -- Senão, se R2='1', Pcode="010".
            "001" when (r(1) = '1') else  -- Senão, se R1='1', Pcode="001".
            "000";                        -- Senão (se tudo é '0'), Pcode="000".
end cond_arch;

--Listing 3.3
architecture sel_arch of prio_encoder is
begin
   -- [EQUAÇÃO LÓGICA: MUX de 16 entradas agrupadas por prioridade]
   with r select pcode <=
      "100" when "1000" | "1001" | "1010" | "1011" | "1100" | "1101" | "1110" | "1111", -- Casos onde R4=1
      "011" when "0100" | "0101" | "0110" | "0111",                                     -- Casos onde R4=0, R3=1
      "010" when "0010" | "0011",                                                       -- Casos onde R4=0, R3=0, R2=1
      "001" when "0001",                                                                -- Caso onde R4=0, R3=0, R2=0, R1=1
      "000" when others;                                                                -- Caso R="0000"
end sel_arch;

--Listing 3.5
architecture if_arch of prio_encoder is
begin
   process(r) -- Executa quando R muda.
   begin
      -- [EQUAÇÃO LÓGICA: Estrutura sequencial de prioridade]
      if (r(4) = '1') then      -- Testa R4 primeiro.
         pcode <= "100";
      elsif (r(3) = '1') then   -- Se R4=0, testa R3.
         pcode <= "011";
      elsif (r(2) = '1') then   -- Se R4=0, R3=0, testa R2.
         pcode <= "010";
      elsif (r(1) = '1') then   -- Se R4=0, R3=0, R2=0, testa R1.
         pcode <= "001";
      else                      -- Se nenhuma é '1'.
         pcode <= "000";
      end if;
   end process;
end if_arch;

--Listing 3.7
architecture case_arch of prio_encoder is
begin
   process(r) -- Executa quando R muda.
   begin
      -- [EQUAÇÃO LÓGICA: Mapeamento de casos de entrada]
      case r is
         when "1000" | "1001" | "1010" | "1011" | "1100" | "1101" | "1110" | "1111" =>
            pcode <= "100";  -- Casos onde R4=1
         when "0100" | "0101" | "0110" | "0111" =>
            pcode <= "011";  -- Casos onde R4=0, R3=1
         when "0010" | "0011" =>
            pcode <= "010";  -- Casos onde R4, R3=0, R2=1
         when "0001" =>
            pcode <= "001";  -- Caso onde R1=1
         when others =>
            pcode <= "000";  -- Caso R="0000"
      end case;
   end process;
end case_arch;