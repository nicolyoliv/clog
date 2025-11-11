library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Conversor Binário (5 bits) -> 2 Displays 7 Segmentos
entity bin_to_bcd_7seg is
    port(
        bin_in : in std_logic_vector(4 downto 0);   -- Entrada Binária de 5 bits (0 a 31)
        seg_left : out std_logic_vector(6 downto 0);  -- Saída Display da Esquerda (Dezena)
        seg_right : out std_logic_vector(6 downto 0) -- Saída Display da Direita (Unidade)
    );
end bin_to_bcd_7seg;

architecture behavioral of bin_to_bcd_7seg is
    -- Constantes para a codificação de 7 segmentos (ativo baixo, "0" acende o segmento)
    -- Ordem dos segmentos: gfedcba (Exemplo: "0000001" é '0', acende todos exceto 'a')
    -- Display de 7 segmentos comum: a-f aceso, g apagado
    --   a
    -- f   b
    --   g
    -- e   c
    --   d
    constant C_0 : std_logic_vector(6 downto 0) := "1000000"; -- 0
    constant C_1 : std_logic_vector(6 downto 0) := "1111001"; -- 1
    constant C_2 : std_logic_vector(6 downto 0) := "0100100"; -- 2
    constant C_3 : std_logic_vector(6 downto 0) := "0110000"; -- 3
    constant C_4 : std_logic_vector(6 downto 0) := "0011001"; -- 4
    constant C_5 : std_logic_vector(6 downto 0) := "0010010"; -- 5
    constant C_6 : std_logic_vector(6 downto 0) := "0000010"; -- 6
    constant C_7 : std_logic_vector(6 downto 0) := "1111000"; -- 7
    constant C_8 : std_logic_vector(6 downto 0) := "0000000"; -- 8
    constant C_9 : std_logic_vector(6 downto 0) := "0010000"; -- 9
    constant C_OFF : std_logic_vector(6 downto 0) := "1111111"; -- Todos apagados
    
    -- Sinal interno para o dígito da direita (Unidade)
    signal digit_unit : std_logic_vector(6 downto 0);
    -- Sinal interno para o dígito da esquerda (Dezena)
    signal digit_ten : std_logic_vector(6 downto 0);

begin
    -- -----------------------------------------------------------
    -- Lógica de Conversão (Binário 5 bits para 7 Segmentos)
    -- -----------------------------------------------------------
    with bin_in select
        (digit_ten, digit_unit) <= 
        -- Dezena 0
        (C_OFF, C_0) when "00000", -- 0
        (C_OFF, C_1) when "00001", -- 1
        (C_OFF, C_2) when "00010", -- 2
        (C_OFF, C_3) when "00011", -- 3
        (C_OFF, C_4) when "00100", -- 4
        (C_OFF, C_5) when "00101", -- 5
        (C_OFF, C_6) when "00110", -- 6
        (C_OFF, C_7) when "00111", -- 7
        (C_OFF, C_8) when "01000", -- 8
        (C_OFF, C_9) when "01001", -- 9
        -- Dezena 1
        (C_1, C_0) when "01010", -- 10
        (C_1, C_1) when "01011", -- 11
        (C_1, C_2) when "01100", -- 12
        (C_1, C_3) when "01101", -- 13
        (C_1, C_4) when "01110", -- 14
        (C_1, C_5) when "01111", -- 15
        (C_1, C_6) when "10000", -- 16 (Exemplo 1)
        (C_1, C_7) when "10001", -- 17 (Exemplo 2)
        (C_1, C_8) when "10010", -- 18
        (C_1, C_9) when "10011", -- 19
        -- Dezena 2
        (C_2, C_0) when "10100", -- 20
        (C_2, C_1) when "10101", -- 21
        (C_2, C_2) when "10110", -- 22
        (C_2, C_3) when "10111", -- 23
        (C_2, C_4) when "11000", -- 24
        (C_2, C_5) when "11001", -- 25
        (C_2, C_6) when "11010", -- 26
        (C_2, C_7) when "11011", -- 27
        (C_2, C_8) when "11100", -- 28
        (C_2, C_9) when "11101", -- 29
        -- Dezena 3
        (C_3, C_0) when "11110", -- 30
        (C_3, C_1) when "11111", -- 31
        -- Default (se necessário, embora 5 bits cubra até 31)
        (C_OFF, C_OFF) when others; 
        
    -- Mapeia os sinais internos para os pinos de saída
    seg_left <= digit_ten;
    seg_right <= digit_unit;
    
end behavioral;