library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_clk is
    Port ( clk : in STD_LOGIC;     -- Clock de alta frequência de entrada.
           en  : out STD_LOGIC);   -- Pulso de habilitação de saída.
end div_clk;

architecture Behavioral of div_clk is
constant N : integer := 49999999;           -- Constante para o contador. Para um clock de 50 MHz,
                                            -- um pulso 'en' é gerado a cada 1 segundo (50M ciclos).
signal divide_clk : integer range 0 to N;   -- Contador para o divisor.
begin

 PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk='1') THEN      -- Detecta a borda de subida do clock.
            divide_clk <= divide_clk+1;     -- Incrementa o contador.
            IF divide_clk = N THEN          -- Quando o contador atinge o valor limite, ele zera.
                divide_clk <= 0;
            END IF;
        END IF;
 END PROCESS;
 
 -- O pulso 'en' é ativado apenas quando o contador atinge o valor limite.
 en <= '1' when divide_clk = N else '0';

end Behavioral;