library ieee;
use ieee.std_logic_1164.all;

-- Entidade top-level para o FPGA (Subtrator 1 bit)
entity fpga_top_1bit_sub is
    port(
        sw : in std_logic_vector(15 downto 0);  -- Chaves de entrada
        led : out std_logic_vector(15 downto 0) -- LEDs de saída
    );
end fpga_top_1bit_sub;

-- Arquitetura: Mapeia as chaves e LEDs para o módulo top
architecture fpga_sub_arch of fpga_top_1bit_sub is
    signal D_result : STD_LOGIC;
    signal B_result : STD_LOGIC;
begin
    -- Instancia o módulo top_1bit_sub
    top_unit : entity work.top_1bit_sub(top_sub_arch)
        port map(
            A_in      => sw(0), -- A: Chave SW0
            B_in      => sw(1), -- B: Chave SW1
            B_in_ctrl => sw(2), -- B_in: Chave SW2
            D_out     => D_result,
            B_out_led => B_result
        );
        
    -- Mapeia as saídas para os LEDs
    led(0) <= D_result;   -- LED 0: Diferença (D)
    led(1) <= B_result;   -- LED 1: Borrow Out (Bout)
    
    -- Desliga outros LEDs
    led(15 downto 2) <= (others => '0');

end fpga_sub_arch;