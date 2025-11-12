-- Exemplo de uso para um Somador de 8 bits:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    port (
        A_8bit, B_8bit : in std_logic_vector(7 downto 0);
        C_in_ext : in std_logic;
        
        S_8bit : out std_logic_vector(7 downto 0);
        C_out_ext : out std_logic
    );
end top_level;

architecture usage_example of top_level is
begin
    -- Instanciação do Somador Genérico
    -- Especifica DATA_WIDTH = 8
    Adder_Unit : entity work.generic_adder
    generic map (
        DATA_WIDTH => 8
    )
    port map (
        A_in  => A_8bit,
        B_in  => B_8bit,
        C_in  => C_in_ext,
        S_out => S_8bit,
        C_out => C_out_ext
    );
end usage_example;

-- Para um somador de 16 bits, bastaria mudar DATA_WIDTH => 16.