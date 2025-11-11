library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade TOP para Somador/Subtrator Separados de 1 bit
entity top_1bit_mux is
    port(
        A_in  : in STD_LOGIC;  -- Entrada A
        B_in  : in STD_LOGIC;  -- Entrada B
        M     : in STD_LOGIC;  -- Controle: '0'=Soma, '1'=Subtração
        CB_in : in STD_LOGIC;  -- Carry In (se M=0) ou Borrow In (se M=1)
        
        S_D_out : out STD_LOGIC; -- Saída: Soma ou Diferença
        CB_out  : out STD_LOGIC  -- Saída: Carry Out ou Borrow Out
    );
end top_1bit_mux;

architecture top_mux_arch of top_1bit_mux is
    -- Componentes
    component adder_1bit
        port( a, b, ci : in std_logic; co : out std_logic; s : out std_logic );
    end component;
    
    component subtractor_1bit
        port( a, b, bi : in std_logic; bo : out std_logic; d : out std_logic );
    end component;
    
    -- Sinais Internos para os resultados de cada operação
    signal S_result, D_result : STD_LOGIC;
    signal C_out_add, B_out_sub : STD_LOGIC;
    
begin
    -- 1. INSTANCIAÇÃO DO SOMADOR
    Adder_Unit: entity work.adder_1bit(adder_arch)
    port map(
        a => A_in,
        b => B_in,
        ci => CB_in,
        s => S_result,
        co => C_out_add
    );
    
    -- 2. INSTANCIAÇÃO DO SUBTRATOR
    Subtractor_Unit: entity work.subtractor_1bit(subtractor_arch)
    port map(
        a => A_in,
        b => B_in,
        bi => CB_in,
        d => D_result,
        bo => B_out_sub
    );
    
    -- 3. MULTIPLEXAÇÃO DA SAÍDA (Controlada por M)
    -- Se M='0' (Soma), seleciona a saída do Somador.
    -- Se M='1' (Subtração), seleciona a saída do Subtrator.
    
    S_D_out <= S_result when M = '0' else D_result;
    CB_out <= C_out_add when M = '0' else B_out_sub;

end top_mux_arch;