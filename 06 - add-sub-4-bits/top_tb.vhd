library ieee;
use ieee.std_logic_1164.all;

-- Declaração da bancada de testes
entity top_tb is
end top_tb;

-- Arquitetura da bancada de testes
architecture tb_arch of top_tb is
    -- Sinais para conectar ao módulo sob teste
    signal test_num1, test_num2 : std_logic_vector(3 downto 0);
    signal test_mode : std_logic;
    signal test_res : std_logic_vector(4 downto 0);
begin
    -- Instancia a unidade 'top'
    test_unit : entity work.top(top_arch)
        port map(
            num1 => test_num1,
            num2 => test_num2,
            mode => test_mode,
            res => test_res
        );
    -- Processo que aplica os vetores de teste
    process
    begin
        -- Teste 1: Subtração (0011 - 0101) = (3 - 5)
        test_num1 <= "0011";
        test_num2 <= "0101";
        test_mode <= '0';
        wait for 250 ns;
        
        -- Teste 2: Adição (0011 + 0101) = (3 + 5)
        test_num1 <= "0011";
        test_num2 <= "0101";
        test_mode <= '1';
        wait for 250 ns;

        -- Teste 3: Subtração (1001 - 1101) = (9 - 13)
        test_num1 <= "1001";
        test_num2 <= "1101";
        test_mode <= '0';
        wait for 250 ns;

        -- Teste 4: Adição (1000 + 0101) = (8 + 5)
        test_num1 <= "1000";
        test_num2 <= "0101";
        test_mode <= '1';
        wait for 250 ns;
    end process;
end tb_arch;