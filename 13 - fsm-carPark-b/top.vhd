library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port(
        clk  : in std_logic;                       -- Clock principal do sistema.
        btn  : in std_logic_vector(2 downto 0);    -- Entradas para 3 botões/sensores.
        an   : out std_logic_vector(7 downto 0);   -- Saída para o display.
        sseg : out std_logic_vector(7 downto 0)    -- Saída para o display.
    );
end top;

architecture top_arch of top is
    -- Sinais de controle de incremento/decremento.
    signal inc, dec         : std_logic;
    -- Sinais de entrada filtrados (de-bounced).
    signal db_a, db_b, db_c : std_logic;  
    -- Sinal para a contagem de carros.
    signal counter          : std_logic_vector(7 downto 0);
begin
    -- Instancia a FSM de controle do estacionamento.
    carPark_unit: entity work.fsm_carPark(moore_arch)
        port map(
            clk       => clk,
            reset     => '0',
            enable    => '1',
            a         => db_a,                 -- Entrada do sensor 'a' filtrado.
            b         => db_b,                 -- Entrada do sensor 'b' filtrado.
            car_enter => inc,                  -- Saída para o contador (incrementa).
            car_exit  => dec                   -- Saída para o contador (decrementa).
        );
    -- Instancia 3 módulos de debounce para filtrar as 3 entradas de botão.
    db_a_unit: entity work.fsm_db(arch)
        port map(
            clk   => clk,
            reset => '0',
            sw    => btn(0),                   -- Botão 0 (sensor 'a' ruidoso).
            db    => db_a
        );
    db_b_unit: entity work.fsm_db(arch)
        port map(
            clk   => clk,
            reset => '0',
            sw    => btn(1),                   -- Botão 1 (sensor 'b' ruidoso).
            db    => db_b
        );
     db_c_unit: entity work.fsm_db(arch)
        port map(
            clk   => clk,
            reset => '0',
            sw    => btn(2),                   -- Botão 2 (reset da contagem).
            db    => db_c
        );
    -- Instancia o módulo que controla e exibe a contagem no display.
    disp_unit: entity work.fsm_dispHexMux(arch)
        port map(
            clk     => clk,
            reset   => '0',
            hex_in  => counter(3 downto 0),    -- Dígito menos significativo.
            hex_in2 => counter(7 downto 4),    -- Dígito mais significativo.
            dp_in   => "11111111",             -- Todos os pontos decimais desligados.
            an      => an(7 downto 0),
            sseg    => sseg
        );
    -- Instancia o contador que armazena o número de carros.
    counter_unit: entity work.reg(arch)
        port map(
            clk     => clk,
            reset   => db_c,                   -- Botão 2 (filtrado) zera o contador.
            enable  => '1',
            inc     => inc,                    -- Sinal da FSM carPark para incrementar.
            dec     => dec,                    -- Sinal da FSM carPark para decrementar.
            counter => counter                 -- Saída da contagem.
        );
end top_arch;

fsm_carPark (Lógica do Estacionamento)

Esta é a FSM principal que determina se um carro está entrando ou saindo.

    Objetivo: Detectar a sequência de sensores para diferenciar entre um carro entrando e um carro saindo.

    Entradas: a e b, que representam sensores no chão (ou detectores de presença) posicionados em uma ordem específica.

    Lógica: A FSM entra em uma sequência de estados para cada cenário:

        Carro Entrando: Se a sequência de detecção for a -> ab -> b (o carro passa pelo sensor a primeiro, depois por ambos, e finalmente só por b), a FSM transita para o estado up.

        Carro Saindo: Se a sequência for b -> ba -> a (o carro passa pelo sensor b primeiro, depois por ambos, e finalmente só por a), a FSM transita para o estado down.

    Saídas:

        car_enter: Ativa um pulso quando a sequência de entrada é detectada.

        car_exit: Ativa um pulso quando a sequência de saída é detectada.

fsm_db (Filtro de Ruído - Debounce)

Este módulo é um filtro digital essencial para eliminar o "ruído" elétrico gerado por botões ou sensores mecânicos.

    Objetivo: Fornecer um sinal estável e limpo a partir de uma entrada ruidosa.

    Lógica: Uma FSM e um contador de tempo são usados para verificar se o sinal da entrada (sw) se mantém estável por um período suficiente (cerca de 40ms) antes de considerar a mudança como válida. Isso previne que a FSM de controle de estacionamento conte vários eventos por um único carro.

    Uso no Sistema: Este módulo é instanciado três vezes no top para filtrar os sinais de três botões ou sensores (btn(0), btn(1) e btn(2)).

reg (Contador)

Este módulo é um simples contador de 8 bits.

    Objetivo: Incrementar ou decrementar um valor.

    Entradas de Controle:

        inc: Se ativada, incrementa a contagem.

        dec: Se ativada, decrementa a contagem.

    Funcionamento no Sistema: O módulo reg é usado para manter a contagem de carros no estacionamento. Ele recebe os pulsos de car_enter (como inc) e car_exit (como dec) da FSM do estacionamento. Um terceiro botão (db_c) é usado como reset para zerar a contagem.

fsm_dispHexMux (Display)

Este módulo gerencia a exibição da contagem em um display de 7 segmentos.

    Objetivo: Converter o valor binário do contador em um formato exibível para o usuário.

    Lógica:

        Ele usa a técnica de multiplexação, alternando rapidamente entre dois displays para mostrar os dígitos mais e menos significativos do contador.

        Possui um decodificador interno que traduz os valores hexadecimais (0-9) para o padrão de 7 bits que acende os segmentos corretos do display.

top (Módulo Principal)

Este é o módulo de nível superior que conecta todos os componentes para formar o sistema completo.

    Conexões:

        Os sinais brutos dos botões/sensores (btn) são enviados para instâncias separadas do fsm_db para serem filtrados.

        Os sinais limpos (db_a, db_b) são enviados para a fsm_carPark, que determina se um carro está entrando (inc) ou saindo (dec).

        O sinal de um terceiro botão filtrado (db_c) é usado como o reset do contador.

        Os pulsos inc e dec da FSM de estacionamento controlam o reg (contador).

        O valor atual do contador é então enviado para o fsm_dispHexMux, que o exibe no display.

