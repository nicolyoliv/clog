library ieee;
use ieee.std_logic_1164.all;

-- Módulo que integra o codificador de prioridade e o deslocador.
entity top is
    port(
        bits : in std_logic_vector(2 downto 0); -- 3 bits de dados (D)
        mode : in std_logic_vector(2 downto 0); -- 3 bits de controle (M)
        leds : out std_logic_vector(2 downto 0) -- 3 bits de saída (Y)
    );
end top;

architecture top_arch of top is
    -- Sinal interno para a saída do codificador, que serve como entrada de modo para o deslocador.
    signal prio_mode : std_logic_vector(1 downto 0); 
begin
    -- 1. Instancia o codificador de prioridade (prio_encoder)
    mode_unit : entity work.prio_encoder(prio_encoder_arch)
        port map(
            bits_in => mode,      -- Mapeia os 3 bits de controle (mode[2:0])
            bits_out => prio_mode -- Saída: 2 bits de modo prioritário
        );
        
    -- 2. Instancia o deslocador (shifter)
    shifter_unit : entity work.shifter(shifter_arch)
        port map(
            mode => prio_mode,    -- Usa o código prioritário como controle de deslocamento
            bits_in => bits,      -- Mapeia os 3 bits de dados (D[2:0])
            bits_out => leds      -- Saída: Resultado do deslocamento (Y[2:0])
        );
end top_arch;