library ieee;
use ieee.std_logic_1164.all;

-- Entidade top-level para o FPGA (Somador 4 bits + Display Decimal)
entity fpga_top_display is
    port(
        sw : in std_logic_vector(15 downto 0);        -- Chaves de entrada (SW7..0 para A e B)
        led : out std_logic_vector(15 downto 0);      -- LEDs discretos (usaremos LED4..0)
        
        -- Saída para Displays de 7 segmentos
        display_left : out std_logic_vector(6 downto 0);  -- Display da Esquerda (Dezena)
        display_right : out std_logic_vector(6 downto 0) -- Display da Direita (Unidade)
    );
end fpga_top_display;

architecture fpga_display_arch of fpga_top_display is
    -- Componentes
    component adder_4bits_lsb_ha
        port( num1, num2 : in std_logic_vector(3 downto 0);
              num3 : out std_logic_vector(4 downto 0) );
    end component;
    
    component bin_to_bcd_7seg
        port( bin_in : in std_logic_vector(4 downto 0);
              seg_left : out std_logic_vector(6 downto 0);
              seg_right : out std_logic_vector(6 downto 0) );
    end component;
    
    -- Sinal interno para o resultado de 5 bits do Somador
    signal sum_5bit : std_logic_vector(4 downto 0);
    
begin
    -- 1. INSTANCIAÇÃO DO SOMADOR DE 4 BITS
    -- Entradas A e B mapeadas para chaves (SW7..4 e SW3..0)
    Adder_Unit : entity work.adder_4bits_lsb_ha(structural_ha)
        port map(
            num1 => sw(7 downto 4),   
            num2 => sw(3 downto 0),    
            num3 => sum_5bit          -- Resultado vai para o sinal interno
        );
        
    -- Mapeia os 5 bits de resultado para LEDs discretos (LED4 a LED0)
    led(4 downto 0) <= sum_5bit;
    led(15 downto 5) <= (others => '0'); -- Desliga outros LEDs
    
    -- 2. INSTANCIAÇÃO DO CONVERSOR BINÁRIO -> 7 SEGMENTOS
    -- A entrada é o resultado de 5 bits da soma
    Converter_Unit : entity work.bin_to_bcd_7seg(behavioral)
        port map(
            bin_in => sum_5bit,
            seg_left => display_left,  -- Saída para o display da esquerda
            seg_right => display_right -- Saída para o display da direita
        );

end fpga_display_arch;