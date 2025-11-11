library ieee;
use ieee.std_logic_1164.all;

-- A entidade principal que conecta todos os módulos.
entity top is
port(
    clk: in std_logic; -- Entrada de clock, geralmente de alta frequência.
    sseg: out std_logic_vector(7 downto 0); -- Saída para os segmentos do display.
    an: out std_logic_vector(7 downto 0) -- Saída para os anodos (seleção de dígito).
);
end top;

architecture top_arch of top is
-- Constante usada para dividir a frequência do clock.
-- O contador vai de 0 a 9999.
constant N : integer := 9999; 
signal divide_clk : integer range 0 to N; -- Contador para a divisão do clock.
signal enable : std_logic; -- Sinal de habilitação gerado pelo contador.

begin
    -- Instancia a máquina de estados (fsm_eg).
    top_unit: entity work.fsm_eg(two_seg_arch)
        port map(
            enable => enable,
            clk => clk,
            reset => '0', -- Reset fixo em '0' (não ativo).
            sseg => sseg,
            an => an,
            -- Entradas de dados para cada um dos 8 dígitos.
            -- Esses dados parecem ser para exibir números ou caracteres específicos.
            in7 => "11000000",
            in6 => "11111001",
            in5 => "10100100",
            in4 => "10110000",
            in3 => "10011001",
            in2 => "10010010",
            in1 => "10000010",
            in0 => "11111000"  
        );

    -- O sinal 'enable' é ativado apenas quando o contador atinge o valor 'N'.
    enable <= '1' when divide_clk = N else '0';  
    
    -- Processo síncrono para o divisor de frequência.
    PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk='1') THEN -- Detecta a borda de subida do clock.
            divide_clk <= divide_clk+1; -- Incrementa o contador.
            IF divide_clk = N THEN -- Se o contador chegar ao valor máximo, zera.
                divide_clk <= 0;
            END IF;
        END IF;
    END PROCESS;
end top_arch;
Resumo do Funcionamento do Sistema

O projeto exibe uma sequência fixa de 8 dígitos hexadecimais em um display de 8 dígitos e 7 segmentos. Ele usa a técnica de multiplexação para dar a impressão de que todos os 8 dígitos estão acesos ao mesmo tempo. Isso é feito ligando um dígito de cada vez, por um período muito curto, e exibindo o valor correto para ele. O ciclo é rápido o suficiente para que o olho humano perceba todos os dígitos acesos e sem cintilação. A sequência de exibição é controlada por uma máquina de estados finitos (FSM).

