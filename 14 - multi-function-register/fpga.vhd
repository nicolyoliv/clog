library ieee;
use ieee.std_logic_1164.all;

entity fpga is
    port(
        clk : in std_logic;                  -- Clock da placa FPGA.
        sw  : in std_logic_vector(7 downto 0);  -- Chaves de entrada (switches).
        led : out std_logic_vector(3 downto 0)  -- LEDs de saída.
    );
end fpga;

architecture arch of fpga is 
begin
    -- Instancia a lógica principal e mapeia os pinos físicos.
    top : entity work.top(arch)
        port map(
            clk    => clk,         -- Mapeia o clock da placa.
            SHR_in => sw(4),       -- sw(4) controla o bit de entrada do deslocamento.
            cLD    => sw(7),       -- sw(7) controla a operação 'Load'.
            cINC   => sw(6),       -- sw(6) controla a operação 'Increment'.
            cSHR   => sw(5),       -- sw(5) controla a operação 'Shift'.
            L      => sw(3 downto 0), -- sw(0-3) fornecem os dados para a operação 'Load'.
            S      => led         -- A saída do registrador é conectada aos LEDs.
        );
end arch;