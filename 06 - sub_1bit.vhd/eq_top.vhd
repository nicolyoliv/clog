library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade TOP para o Subtrator Completo de 1 bit
entity eq_top is
    port(
        A_in, B_in, B_in_ctrl : in  STD_LOGIC;  -- Entradas de controle (Chaves)
        D_out, B_out_led      : out STD_LOGIC   -- Saídas de resultado (LEDs)
    );
end eq_top;

architecture top_sub_arch of eq_top is
begin
    -- Instanciação do Subtrator Completo de 1 bit
    Subtractor_Unit : entity work.subtractor_1bit(subtractor_arch)
        port map(
            a  => A_in,
            b  => B_in,
            bi => B_in_ctrl, -- Mapeia o Borrow In para uma chave de controle
            d  => D_out,
            bo => B_out_led  -- Mapeia o Borrow Out para um LED
        );
end top_sub_arch;