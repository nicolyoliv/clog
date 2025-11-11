library ieee;
use ieee.std_logic_1164.all;

-- Entidade top-level para o FPGA (Somador 4 bits)
entity fpga_top_adder is
    port(
        sw : in std_logic_vector(15 downto 0);  -- Chaves de entrada (SW0 a SW8 são usadas)
        led : out std_logic_vector(15 downto 0) -- LEDs de saída (LED0 a LED4 são usados)
    );
end fpga_top_adder;

architecture fpga_arch of fpga_top_adder is
    -- Componente do Somador TOP (para hierarquia)
    component top_adder_4bits
        port( A_in, B_in : in std_logic_vector(3 downto 0);
              C_in : in std_logic;
              S_out : out std_logic_vector(3 downto 0);
              C_out : out std_logic );
    end component;
    
    -- Sinais internos
    signal S_result : std_logic_vector(3 downto 0);
    signal C_final : std_logic;
    
begin
    -- Instancia o módulo TOP do somador
    TOP_Unit : entity work.top_adder_4bits(top_arch)
        port map(
            A_in  => sw(3 downto 0),    -- A: Chaves SW3 a SW0
            B_in  => sw(7 downto 4),    -- B: Chaves SW7 a SW4
            C_in  => sw(8),             -- C_in: Chave SW8 (Ignorada se o adder_4bits fixar C_in='0')
            S_out => S_result,
            C_out => C_final
        );
        
    -- Mapeia as saídas para os LEDs
    led(3 downto 0) <= S_result;   -- LEDs 3 a 0: Resultado da Soma
    led(4) <= C_final;             -- LED 4: Carry Out Final
    
    -- Desliga outros LEDs para clareza
    led(15 downto 5) <= (others => '0');

end fpga_arch;