library ieee;
use ieee.std_logic_1164.all;

-- Entidade top-level para o FPGA (Subtrator 4 bits)
entity fpga_top_subtractor is
    port(
        sw : in std_logic_vector(15 downto 0);  -- Chaves de entrada
        led : out std_logic_vector(15 downto 0) -- LEDs de saída
    );
end fpga_top_subtractor;

architecture fpga_sub_arch of fpga_top_subtractor is
    -- Componente do Subtrator de 4 bits
    component subtractor_4bits
        port( num1, num2 : in std_logic_vector(3 downto 0);
              num3 : out std_logic_vector(4 downto 0) );
    end component;
    
    -- Sinal interno para o resultado de 5 bits
    signal D_result_5bit : std_logic_vector(4 downto 0);
    
begin
    -- Instancia o Subtrator de 4 bits
    Subtractor_Unit : entity work.subtractor_4bits(subtractor_arch)
        port map(
            num1 => sw(3 downto 0),    -- A (Minuendo): Chaves SW3 a SW0
            num2 => sw(7 downto 4),    -- B (Subtraendo): Chaves SW7 a SW4
            num3 => D_result_5bit
        );
        
    -- Mapeia as saídas para os LEDs
    -- LEDs 3 a 0: Diferença (D)
    led(3 downto 0) <= D_result_5bit(3 downto 0); 
    
    -- LED 4: Borrow Out Final (Bout)
    led(4) <= D_result_5bit(4);             
    
    -- Desliga outros LEDs
    led(15 downto 5) <= (others => '0');

end fpga_sub_arch;