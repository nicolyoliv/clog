library ieee;
use ieee.std_logic_1164.all;

-- Entidade top-level para o FPGA (Somador/Subtrator 1 bit Separado)
entity fpga_top_1bit_mux is
    port(
        sw : in std_logic_vector(15 downto 0);  -- Chaves de entrada
        led : out std_logic_vector(15 downto 0) -- LEDs de saída
    );
end fpga_top_1bit_mux;

architecture fpga_mux_arch of fpga_top_1bit_mux is
    signal Result : STD_LOGIC;
    signal CarryBorrow : STD_LOGIC;
begin
    -- Instancia o módulo de lógica principal
    top_unit : entity work.top_1bit_mux(top_mux_arch)
        port map(
            A_in    => sw(0),    -- A: Chave SW0
            B_in    => sw(1),    -- B: Chave SW1
            CB_in   => sw(2),    -- C_in/B_in: Chave SW2
            M       => sw(3),    -- M: Chave SW3 (0=Soma, 1=Subtração)
            S_D_out => Result,
            CB_out  => CarryBorrow
        );
        
    -- Mapeia as saídas para os LEDs
    led(0) <= Result;      -- LED 0: Soma ou Diferença
    led(1) <= CarryBorrow; -- LED 1: Carry Out ou Borrow Out
    
    -- Desliga outros LEDs
    led(15 downto 2) <= (others => '0');

end fpga_mux_arch;