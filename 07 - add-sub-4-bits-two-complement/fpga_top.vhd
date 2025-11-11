library ieee;
use ieee.std_logic_1164.all;

-- Entidade top-level para o FPGA
entity fpga_top is
    port(
        sw : in std_logic_vector(15 downto 0);   -- Entrada de 16 chaves (switches)
        led : out std_logic_vector(15 downto 0)  -- Saída para 16 LEDs
    );
end fpga_top;

architecture fpga_arch of fpga_top is
begin
    top_unit : entity work.top(top_arch)
        port map(
            num1 => sw(7 downto 4),    -- Usa chaves 4 a 7 como a entrada num1
            num2 => sw(3 downto 0),    -- Usa chaves 0 a 3 como a entrada num2
            mode => sw(8),             -- Usa a chave 8 como o seletor de modo
            res => led(4 downto 0)     -- Exibe o resultado de 5 bits nos LEDs 0 a 4
        );
end fpga_arch;