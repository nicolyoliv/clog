library ieee;
use ieee.std_logic_1164.all;

-- Módulo que converte a entrada de controle de 3 bits para 2 bits,
-- seguindo a prioridade: mode(2) > mode(1) > mode(0).
entity prio_encoder is
    port(
        bits_in : in std_logic_vector(2 downto 0);  -- Entrada: 3 bits de modo (sw[15:13])
        bits_out : out std_logic_vector(1 downto 0) -- Saída: Código de 2 bits para o Shifter
    );
end prio_encoder;

architecture prio_encoder_arch of prio_encoder is
begin
    -- Atribuição concorrente condicional (WHEN...ELSE) define a prioridade.
    bits_out <= "11" when (bits_in(2) = '1') else   -- Prio 1: Se mode(2) for '1', a saída é "11"
                "10" when (bits_in(1) = '1') else   -- Prio 2: Senão, se mode(1) for '1', a saída é "10"
                "01" when (bits_in(0) = '1') else   -- Prio 3: Senão, se mode(0) for '1', a saída é "01"
                "00";                               -- Padrão: Se NENHUM for '1', a saída é "00"
end prio_encoder_arch;

--M2​M1​M0​, P1​P0​, Ativa,     Função
--1 X X,  1 1,  M2​=1,      Deslocar Direita (SHR)
--0 1 X,1 0,    M2′​=1,M1​=1,Deslocar Circular Direita (SHRC)
--0 0 1,0 1,    M2′​M1′​M0​=1,Deslocar Esquerda (SHL)
--0 0 0,0 0,    M2′​M1′​M0′​=1,Manter Valor (NO-OP)

P_1 = M_2 + (M_2'. M_1)
P_0} = M_2' .m1' .M_0