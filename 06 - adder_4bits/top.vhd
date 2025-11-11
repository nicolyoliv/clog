library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade TOP para o Somador de 4 bits
entity top_adder_4bits is
    port(
        A_in  : in std_logic_vector(3 downto 0); -- Entrada A (4 bits)
        B_in  : in std_logic_vector(3 downto 0); -- Entrada B (4 bits)
        C_in  : in std_logic;                    -- Carry de entrada (C0)
        
        S_out : out std_logic_vector(3 downto 0);-- Saída da Soma (4 bits)
        C_out : out std_logic                    -- Carry de saída final (C4)
    );
end top_adder_4bits;

architecture top_arch of top_adder_4bits is
    -- Componente do Somador de 4 bits
    component adder_4bits
        port( num1, num2 : in std_logic_vector(3 downto 0);
              num3 : out std_logic_vector(4 downto 0) );
    end component;

    -- Sinal interno para receber a saída de 5 bits do adder_4bits
    signal result_5bit : std_logic_vector(4 downto 0); 
    
begin
    -- Instancia o Somador de 4 bits (assumindo que ele tem o ci='0' fixo)
    -- NOTA: O seu módulo adder_4bits não tem pino C_in. Vamos adaptar a instância.
    
    -- Se o seu adder_4bits original for usado, C_in deve ser fixado internamente.
    -- Vamos criar uma versão que expõe o C_in para flexibilidade.
    
    -- ALTERNATIVA: Se usarmos a versão reestruturada, os pinos seriam:
    -- Adder_Unit : entity work.adder_4bits(structural)
    --     port map(
    --         A_in => A_in, B_in => B_in, C_in => C_in,
    --         S_out => S_out, C_out => C_out
    --     );

    -- USANDO O CÓDIGO FORNECIDO (COM SAÍDA DE 5 BITS E C_in FIXO EM '0'):
    Adder_Unit : entity work.adder_4bits(adder_arch)
    port map(
        num1 => A_in,
        num2 => B_in,
        num3 => result_5bit
    );

    -- Como o seu adder_4bits não tem pino C_in exposto (e usa '0' interno):
    -- A entrada C_in externa é ignorada, mas é mantida na entidade por completude.
    -- A saída é dividida: os 4 bits menos significativos (Soma) e o MSB (Carry Out).
    S_out <= result_5bit(3 downto 0); -- 4 bits da soma
    C_out <= result_5bit(4);          -- 1 bit do Carry Out
    
end top_arch;