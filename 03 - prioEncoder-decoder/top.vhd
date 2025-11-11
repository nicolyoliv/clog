-- MÓDULO TOP-LEVEL: CONEXÕES FÍSICAS
library ieee;
use ieee.std_logic_1164.all;

entity eq_top is
   port(
      sw  : in  std_logic_vector(3 downto 0); -- 4 chaves (entradas)
      led : out std_logic_vector(3 downto 0) -- 4 LEDs (saídas)
   );
end eq_top;

-- ARQUITETURA ATIVA: DECODIFICADOR 2x4 (SEL_ARCH)
architecture sel_arch of eq_top is
begin
    -- Instanciação do Decodificador 2x4
    u2 : entity work.decoder_2_4(sel_arch)
        port map(
            en => sw(3),       -- Chave SW3 conecta ao Enable
            a => sw(2 downto 1), -- Chaves SW2 e SW1 conectam à entrada A
            y => led           -- Saídas Y conectam aos LEDs (led3 a led0)
        );
end sel_arch;

-- ARQUITETURAS COMENTADAS (Exemplos de conexão para os outros módulos)
/*
architecture cond_arch of eq_top is
   u1 : entity work.decoder_2_4(cond_arch)
      port map(en => sw(3), a => sw(2 downto 1), y => led);
end cond_arch;

architeture if_arch of eq_top is 
   u3 : entity work.prio_encoder(if_arch)
       port map(r => sw, pcode => led(3 downto 1)); -- Nota: a saída pcode precisa de 3 bits, então led(0) deve ser deixado de lado ou usado como Válido
end if_arch;
*/