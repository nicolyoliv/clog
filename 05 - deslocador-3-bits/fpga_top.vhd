library ieee;
use ieee.std_logic_1164.all;

-- Este é o módulo de nível superior para o FPGA.
-- Ele mapeia os pinos de entrada e saída físicos (switches e LEDs)
-- para as portas do módulo 'top'.
library ieee;
use ieee.std_logic_1164.all;

entity fpga_top is
    port(
        sw : in std_logic_vector(15 downto 0);   -- Entrada de 16 chaves (switches)
        led : out std_logic_vector(15 downto 0)  -- Saída para 16 LEDs
    );
end fpga_top;

architecture fpga_top_arch of fpga_top is
begin
    top_unit : entity work.top(top_arch) -- Instancia o módulo 'top'
        port map(
            bits => sw(2 downto 0),          -- Os 3 bits de dados vêm dos switches 0, 1 e 2
            mode => sw(15 downto 13),        -- Os 3 bits de modo vêm dos switches 13, 14 e 15
            leds => led(15 downto 13)        -- O resultado é exibido nos LEDs 13, 14 e 15
        );
end fpga_top_arch;