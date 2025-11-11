-- TESTBENCH: SIMULAÇÃO
library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture tb_arch of top_tb is
    -- Nota: Os sinais de teste precisam ser mapeados corretamente para o módulo TOP que está sendo testado.
    -- O código original parece misturar testes para Decodificador e Codificador. Vamos adaptar:
    
    signal test_A : STD_LOGIC_VECTOR(2 downto 0) := "000"; -- Seletor 3 bits para Decodificador
    signal test_R : STD_LOGIC_VECTOR(3 downto 0) := "0000"; -- Entradas 4 bits para Codificador (switches)
    
    -- Saídas esperadas (dependem do TOP que está sendo testado)
    signal test_Y : STD_LOGIC_VECTOR(3 downto 0); 

begin
    -- Instanciação do Top-Level (Assumindo que você renomeou eq_top para top para o Testbench)
    -- Atenção: Você deve instanciar o módulo que contém o circuito final que você quer testar (eq_top).
    -- Este código assume que você testará um módulo chamado 'top'.
    test_unit: entity work.eq_top(sel_arch) -- Testando o Decodificador 2x4
        port map(
            sw  => test_R, -- Mapeando R (switches)
            led => test_Y  -- Mapeando Y (LEDs)
        );
        
        -- Processo de estímulos (Teste de Decodificador 2x4 com EN=R(3) e A=R(2 downto 1))
        process
        begin
            -- Teste 1: Decodificador desabilitado
            test_R <= "0000"; -- EN='0', A="00". Esperado: Y="0000"
            wait for 20 ns;

            -- Teste 2: Habilitado, A="00"
            test_R <= "1000"; -- EN='1', A="00". Esperado: Y="0001"
            wait for 20 ns;
            
            -- Teste 3: Habilitado, A="01"
            test_R <= "1010"; -- EN='1', A="01". Esperado: Y="0010"
            wait for 20 ns;

            -- Teste 4: Habilitado, A="10"
            test_R <= "1100"; -- EN='1', A="10". Esperado: Y="0100"
            wait for 20 ns;

            -- Teste 5: Habilitado, A="11"
            test_R <= "1110"; -- EN='1', A="11". Esperado: Y="1000"
            wait for 20 ns;
            
            -- Para testar o Prio-Encoder, você teria que alterar a instância 'test_unit' para 'prio_encoder'
            -- e mapear os sinais de teste R para a entrada R e a saída pcode para o sinal de saída.
            
            wait;
        end process;  
end tb_arch;