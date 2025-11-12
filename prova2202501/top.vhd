fpga_top_genericlibrary ieee;
use ieee.std_logic_1164.all;

-- Entidade top-level para o FPGA (Somador 4 bits Genérico + Display Decimal)
entity fpga_top_generic is
    port(
        sw : in std_logic_vector(15 downto 0);        -- Chaves de entrada (SW7..0 para A e B)
        led : out std_logic_vector(15 downto 0);      -- LEDs discretos
        
        display_left : out std_logic_vector(6 downto 0);  -- Display da Esquerda (Dezena)
        display_right : out std_logic_vector(6 downto 0) -- Display da Direita (Unidade)
    );
end fpga_top_generic;

architecture fpga_generic_arch of fpga_top_generic is
    -- Constante para definir a largura (N=4)
    constant N_BITS : integer := 4; 
    
    -- Componentes
    component generic_adder
        generic (DATA_WIDTH : integer);
        port( A_in, B_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
              C_in : in std_logic;
              S_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
              C_out : out std_logic );
    end component;
    
    component bin_to_7seg_converter
        port( bin_in : in std_logic_vector(4 downto 0);
              seg_left : out std_logic_vector(6 downto 0);
              seg_right : out std_logic_vector(6 downto 0) );
    end component;
    
    -- Sinais internos
    signal sum_4bit : std_logic_vector(N_BITS - 1 downto 0); -- 4 bits da Soma
    signal carry_final : std_logic;                          -- Bit de estouro
    signal sum_5bit_display : std_logic_vector(4 downto 0);  -- Resultado completo de 5 bits
    
begin
    -- 1. INSTANCIAÇÃO DO SOMADOR GENÉRICO (N=4)
    Adder_Unit : entity work.generic_adder
    generic map (
        DATA_WIDTH => N_BITS -- Define N=4
    )
    port map(
        A_in  => sw(7 downto 4),   
        B_in  => sw(3 downto 0),    
        C_in  => '0',              -- Carry Inicial aterrado em '0'
        S_out => sum_4bit,         -- 4 bits da soma
        C_out => carry_final       -- Bit de estouro
    );
    
    -- Concatena os 5 bits para o display
    sum_5bit_display <= carry_final & sum_4bit; 
    
    -- Mapeia os 5 bits de resultado para LEDs discretos (LED4 a LED0)
    led(4 downto 0) <= sum_5bit_display;
    led(15 downto 5) <= (others => '0');
    
    -- 2. INSTANCIAÇÃO DO CONVERSOR BINÁRIO -> 7 SEGMENTOS
    Converter_Unit : entity work.bin_to_7seg_converter(behavioral)
        port map(
            bin_in => sum_5bit_display,
            seg_left => display_left,  
            seg_right => display_right
        );

end fpga_generic_arch;