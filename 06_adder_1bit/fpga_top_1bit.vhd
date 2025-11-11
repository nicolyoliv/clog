library ieee;
use ieee.std_logic_1164.all;

-- Entidade top-level para o FPGA (Somador 1 bit)
entity fpga_top_1bit is
    port(
        sw : in std_logic_vector(15 downto 0);  -- 16 chaves de entrada
        led : out std_logic_vector(15 downto 0) -- 16 LEDs de saída
    );
end fpga_top_1bit;

-- Arquitetura: Mapeia as chaves e LEDs para o módulo top_1bit
architecture fpga_arch of fpga_top_1bit is
    -- Sinais para conectar o módulo top_1bit
    signal S_result : STD_LOGIC;
    signal C_result : STD_LOGIC;
begin
    -- Instancia o módulo top_1bit
    top_unit : entity work.top_1bit(top_arch)
        port map(
            A_in      => sw(0), -- A: Chave SW0
            B_in      => sw(1), -- B: Chave SW1
            C_in_ctrl => sw(2), -- C_in: Chave SW2
            S_out     => S_result,
            C_out_led => C_result
        );
        
    -- Mapeia as saídas para os LEDs
    led(0) <= S_result;   -- LED 0: Soma (S)
    led(1) <= C_result;   -- LED 1: Carry Out (Cout)
    
    -- Desliga outros LEDs para clareza
    led(15 downto 2) <= (others => '0');

end fpga_arch;