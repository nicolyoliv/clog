library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF_D is
    Port ( D   : in STD_LOGIC;      -- Entrada de dados.
           e   : in STD_LOGIC;      -- Sinal de habilitação.
           Q   : out STD_LOGIC;     -- Saída de dados.
           clk : in STD_LOGIC);     -- Clock para sincronização.
end FF_D;

architecture Behavioral of FF_D is
begin
process(clk,e)
begin
   if (clk'event and clk='1') then  -- Detecta a borda de subida do clock.
      if (e='1') then               -- Se o sinal de habilitação estiver ativo,
         Q <= D;                    -- a saída Q é atualizada com o valor de D.
      end if;
   end if;
end process;
end Behavioral;
