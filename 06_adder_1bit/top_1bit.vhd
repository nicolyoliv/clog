library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade TOP para o Somador Completo de 1 bit
entity top_1bit is
    port(
        A_in, B_in, C_in_ctrl : in  STD_LOGIC;  -- Entradas de controle (Chaves)
        S_out, C_out_led      : out STD_LOGIC   -- Saídas de resultado (LEDs)
    );
end top_1bit;

architecture top_arch of top_1bit is
begin
    -- Instanciação do Somador Completo de 1 bit
    Adder_Unit : entity work.adder_1bit(adder_arch)
        port map(
            a  => A_in,
            b  => B_in,
            ci => C_in_ctrl, -- Mapeia o Carry In para uma chave de controle
            s  => S_out,
            co => C_out_led  -- Mapeia o Carry Out para um LED
        );
end top_arch;