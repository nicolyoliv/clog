library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Conversor Binário (5 bits) -> 2 Displays 7 Segmentos
entity bin_to_7seg_converter is
    port(
        bin_in : in std_logic_vector(4 downto 0);   -- Entrada Binária de 5 bits (0 a 31)
        seg_left : out std_logic_vector(6 downto 0);  -- Saída Display da Esquerda (Dezena)
        seg_right : out std_logic_vector(6 downto 0) -- Saída Display da Direita (Unidade)
    );
end bin_to_7seg_converter;

architecture behavioral of bin_to_7seg_converter is
    -- Constantes para a codificação de 7 segmentos (ativo baixo, "0" acende o segmento)
    -- Ordem: gfedcba. Ex: C_7 = "1111000"
    constant C_0 : std_logic_vector(6 downto 0) := "1000000"; -- 0
    constant C_1 : std_logic_vector(6 downto 0) := "1111001"; -- 1
    constant C_7 : std_logic_vector(6 downto 0) := "1111000"; -- 7
    -- ... (outras constantes C_2 a C_9 seriam incluídas aqui)
    constant C_OFF : std_logic_vector(6 downto 0) := "1111111"; -- Todos apagados
    
    -- Função de mapeamento de 4 bits para 7 segmentos
    function map_digit (input_digit: std_logic_vector(3 downto 0)) return std_logic_vector is
    begin
        case input_digit is
            when "0000" => return C_0;
            when "0001" => return C_1;
            when "0111" => return C_7; -- Incluindo 7 para o exemplo
            -- ... (mapeamentos de 2 a 6 e 8 a 9 continuariam aqui)
            when others => return C_OFF;
        end case;
    end function map_digit;

    -- Sinais internos para os dígitos BCD
    signal BCD_ten : std_logic_vector(3 downto 0);
    signal BCD_unit : std_logic_vector(3 downto 0);
    
begin
    -- -----------------------------------------------------------
    -- Conversão Binário (5 bits) para BCD (2 dígitos)
    -- O resultado máximo é 31 (11111), logo, Dezena=3, Unidade=1.
    -- -----------------------------------------------------------
    
    -- O bloco 'case' faz a conversão do valor bin_in (0-31) para BCD (00-31)
    with bin_in select
        (BCD_ten, BCD_unit) <= 
        -- Exemplo: 17 (10001) -> BCD (0001, 0111)
        ("0001", "0111") when "10001", 
        -- Exemplo: 16 (10000) -> BCD (0001, 0110)
        ("0001", "0110") when "10000",
        -- ... (Todas as outras 30 combinações iriam aqui) ...
        ("0011", "0001") when "11111", -- 31
        ("0000", "0000") when others;
        
    -- Mapeamento dos dígitos BCD para os códigos de 7 segmentos
    seg_left <= map_digit(BCD_ten);
    seg_right <= map_digit(BCD_unit);
    
end behavioral;