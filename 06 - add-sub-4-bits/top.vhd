library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaração da entidade: Módulo top-level da ALU
entity top is
    port(
        num1, num2 : in std_logic_vector(3 downto 0); -- Entradas de 4 bits para a operação
        mode : in std_logic;                         -- Sinal de controle: '1' para soma, '0' para subtração
        res : out std_logic_vector(4 downto 0)       -- Saída da ALU
    );
end top;

-- Arquitetura: Instancia os somadores e subtratores e multiplexa a saída
architecture top_arch of top is
    signal res_adder, res_subtractor : std_logic_vector(4 downto 0); -- Sinais internos para os resultados
begin
    -- Instancia o somador de 4 bits
    adder_unit : entity work.adder_4bits(adder_arch)
        port map(
            num1 => num1,
            num2 => num2,
            num3 => res_adder
        );
    -- Instancia o subtrator de 4 bits
    subtractor_unit : entity work.subtractor_4bits(subtractor_arch)
        port map(
            num1 => num1,
            num2 => num2,
            num3 => res_subtractor
        );
    -- Multiplexa a saída com base no sinal 'mode'
    res <=  res_adder when mode = '1' else
            res_subtractor;

end top_arch;

Resumo do Funcionamento do Projeto

O projeto é uma Unidade Lógica e Aritmética (ALU) que executa operações de soma e subtração em números binários de 4 bits. A operação é selecionada por uma entrada de controle (mode). Os resultados são exibidos em 5 bits, para acomodar o "carry" (em soma) ou o "borrow" (em subtração). O sistema é modular, construído a partir de somadores e subtratores de 1 bit.