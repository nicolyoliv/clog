library ieee;
use ieee.std_logic_1164.all;

-- Esta é a bancada de testes para o módulo 'top'.
-- Ela não possui entradas ou saídas físicas, apenas sinais internos
-- para simular os valores de entrada e observar os de saída.
library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture top_tb_arch of top_tb is
    -- Sinais de teste para as entradas e saídas do módulo 'top'
    signal test_mode : std_logic_vector(2 downto 0); 
    signal test_bits : std_logic_vector(2 downto 0);
    signal test_leds : std_logic_vector(2 downto 0);
begin
    -- Instancia a unidade 'top' que será testada
    test_unit : entity work.top(top_arch)
        port map(
            mode => test_mode,
            bits => test_bits,
            leds => test_leds 
        );
    
    -- Processo que aplica os vetores de teste
    process
    begin
        -- Sequência de teste 1: testando a prioridade do 'mode'
        -- O modo "111" tem a mesma prioridade que "100" (a mais alta)
        test_mode <= "111"; 
        test_bits <= "101";
        wait for 100 ns;
        -- Testando a próxima prioridade ("011")
        test_mode <= "011"; 
        test_bits <= "101";
        wait for 100 ns;
        -- Testando a prioridade mais baixa ("001")
        test_mode <= "001";
        test_bits <= "101";
        wait for 100 ns;
        -- Testando o modo 'off' ("000")
        test_mode <= "000";
        test_bits <= "101";
        wait for 100 ns;
        
        -- Sequência de teste 2: verificando a prioridade novamente com valores diferentes
        test_mode <= "100";
        test_bits <= "111";
        wait for 100 ns;
        test_mode <= "010";
        test_bits <= "111";
        wait for 100 ns;
        test_mode <= "001";
        test_bits <= "111";
        wait for 100 ns;
        test_mode <= "000";
        test_bits <= "111";
        wait for 100 ns;
    end process;

end top_tb_arch;