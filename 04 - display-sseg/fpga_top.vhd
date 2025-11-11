library ieee;
use ieee.std_logic_1164.all;

entity fpga_top is
    port(
        clk : in std_logic; -- Entrada de clock principal do FPGA
        sw : in std_logic_vector(15 downto 0); -- Entrada: 16 chaves
        sseg : out std_logic_vector(7 downto 0); -- Saída: 7 segmentos + DP
        an : out std_logic_vector(7 downto 0) -- Saída: Anodo de seleção (8 displays)
    );
end fpga_top;

architecture fpga_top_arch of fpga_top is
begin
    -- Instancia o módulo 'top' (onde está a lógica de conversão e incremento)
    top_unit : entity work.top(top_desafio_arch) -- Usando a arquitetura do Desafio (+1)
        port map(
            clk => clk,
            hex0 => sw(3 downto 0),   -- sw[3:0] para hex0
            hex1 => sw(7 downto 4),   -- sw[7:4] para hex1
            hex2 => sw(11 downto 8),  -- sw[11:8] para hex2
            hex3 => sw(15 downto 12), -- sw[15:12] para hex3
            sseg => sseg,
            an => an
        );
end fpga_top_arch;