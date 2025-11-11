library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; -- Necessário para a função unsigned() e "+"

-- Entidade: Módulo top-level que realiza soma e subtração
entity top is
    port(
        num1, num2 : in std_logic_vector(3 downto 0); -- Entradas de 4 bits
        mode : in std_logic;                         -- Sinal de controle: '0' para soma, '1' para subtração
        res : out std_logic_vector(4 downto 0)       -- Saída de 5 bits
    );
end top;

architecture top_arch of top is
    signal res_adder, res_subtractor : std_logic_vector(4 downto 0); -- Sinais para os resultados das operações
begin
    -- Instanciação do somador de 4 bits (para a operação de soma)
    adder_unit : entity work.adder_4bits(adder_arch)
        port map(
            num1 => num1,
            num2 => num2,
            num3 => res_adder
        );
    
    -- Instanciação do somador de 4 bits (para a operação de subtração)
    -- A subtração é feita com a soma do complemento de 2 do segundo número.
    -- Complemento de 2 de num2 = (NOT num2) + 1
    subtractor_unit : entity work.adder_4bits(adder_arch)
        port map(
            num1 => num1,
            num2 => std_logic_vector(unsigned(not num2) + 1), -- Calcula o complemento de 2
            num3 => res_subtractor
        );
    
    -- Lógica de seleção (multiplexador)
    res <=  res_adder when mode = '0' else   -- Se mode = '0', a saída é a soma
            res_subtractor;                  -- Se mode = '1', a saída é a subtração
end top_arch;

Resumo do Funcionamento do Projeto

O projeto implementa uma Unidade Lógica e Aritmética (ALU) de 4 bits que realiza operações de soma e subtração. A operação é selecionada por um sinal de controle (mode). A subtração é feita de forma eficiente usando a técnica de complemento de 2, que permite que a mesma lógica de somador seja utilizada para ambas as operações. O sistema usa chaves (switches) como entradas e LEDs como saídas para um FPGA.