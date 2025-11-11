library ieee;
use ieee.std_logic_1164.all;

-- Entidade top-level para o FPGA
entity fpga_top is
    port(
        sw : in std_logic_vector(15 downto 0);  -- 16 chaves de entrada
        led : out std_logic_vector(15 downto 0) -- 16 LEDs de saída
    );
end fpga_top;

-- Arquitetura: Mapeia as chaves e LEDs para as portas do módulo top
architecture fpga_arch of fpga_top is
begin
    top_unit : entity work.top(top_arch)
        port map(
            num1 => sw(7 downto 4),    -- Usa os switches 4 a 7 como num1
            num2 => sw(3 downto 0),    -- Usa os switches 0 a 3 como num2
            mode => sw(8),             -- Usa o switch 8 como o seletor de modo
            res => led(3 downto 0)     -- Exibe o resultado nos LEDs 0 a 3
        );
end fpga_arch;