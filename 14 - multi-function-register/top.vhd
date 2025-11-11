library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port(
        clk                     : in std_logic;
        SHR_in, cLD, cINC, cSHR : in std_logic;      -- Controles de operação.
        L                       : in std_logic_vector(3 downto 0); -- Entrada para a operação 'Load'.
        S                       : out std_logic_vector(3 downto 0)  -- Saída do registrador.
    );
end top;

architecture arch of top is
    signal en              : std_logic;                 -- Sinal de habilitação do divisor de clock.
    signal c               : std_logic_vector(1 downto 0); -- Saída do codificador de prioridade.
    signal S_int, Q, Q_inc : std_logic_vector(3 downto 0); -- Sinais internos.
begin
    S <= Q;  -- A saída 'S' reflete o estado atual do registrador 'Q'.

    -- Instancia o divisor de clock.
    div_clk : entity work.div_clk(Behavioral)
        port map(
            clk => clk,
            en  => en
        );
    -- Instancia o codificador de prioridade, que mapeia os controles para o seletor.
    LC : entity work.cod_prio(cond_arch)
        port map(
            r(2)  => cLD,       -- Prioridade 2: Carregar (Load).
            r(1)  => cINC,      -- Prioridade 1: Incrementar (Increment).
            r(0)  => cSHR,      -- Prioridade 0: Deslocar (Shift).
            pcode => c
        );
    -- Instancia 4 multiplexadores, um para cada bit do registrador.
    -- Cada mux seleciona a entrada apropriada com base na operação.
    MUX_4x1_3 : entity work.mux_4x1(cond_arch)
        port map(
            i(3) => L(3),          -- Carga (Load).
            i(2) => Q_inc(3),      -- Incremento.
            i(1) => SHR_in,        -- Deslocamento (entrada).
            i(0) => Q(3),          -- Manter (sem operação).
            c    => c,
            s    => S_int(3)
        );
    MUX_4x1_2 : entity work.mux_4x1(cond_arch)
        port map(
            i(3) => L(2),
            i(2) => Q_inc(2),
            i(1) => Q(3),          -- Deslocamento (bit do lado).
            i(0) => Q(2),
            c    => c,
            s    => S_int(2)
        );
    MUX_4x1_1 : entity work.mux_4x1(cond_arch)
        port map(
            i(3) => L(1),
            i(2) => Q_inc(1),
            i(1) => Q(2),
            i(0) => Q(1),
            c    => c,
            s    => S_int(1)
        );
    MUX_4x1_0 : entity work.mux_4x1(cond_arch)
        port map(
            i(3) => L(0),
            i(2) => Q_inc(0),
            i(1) => Q(1),
            i(0) => Q(0),
            c    => c,
            s    => S_int(0)
        );
    -- Instancia 4 flip-flops para criar o registrador de 4 bits.
    FF_D_3 : entity work.FF_D(Behavioral)
        port map(
            clk => clk,
            D   => S_int(3),
            e   => en,
            Q   => Q(3)
        );
    FF_D_2 : entity work.FF_D(Behavioral)
        port map(
            clk => clk,
            D   => S_int(2),
            e   => en,
            Q   => Q(2)
        );
    FF_D_1 : entity work.FF_D(Behavioral)
        port map(
            clk => clk,
            D   => S_int(1),
            e   => en,
            Q   => Q(1)
        );
    FF_D_0 : entity work.FF_D(Behavioral)
        port map(
            clk => clk,
            D   => S_int(0),
            e   => en,
            Q   => Q(0)
        );
    -- Instancia o incrementador.
    INC_4bits : entity work.inc_4bits(Behavioral)
        port map(
            inc_in  => Q,
            inc_out => Q_inc
        );
end arch;
Este conjunto de códigos VHDL implementa um registrador de 4 bits com múltiplas operações controladas por prioridade e um divisor de clock. Ele é projetado para ser implementado em um FPGA, onde chaves de entrada (sw) controlam as funcionalidades do registrador e LEDs de saída (led) exibem o resultado.

cod_prio (Codificador de Prioridade)

Este módulo é um codificador de prioridade de 3 para 2 bits.

    Funcionalidade: Ele recebe 3 bits de entrada (r(2 downto 0)) e gera uma saída de 2 bits (pcode) que indica qual a entrada de maior prioridade está ativa ('1'). A prioridade é definida de r(2) (maior prioridade) para r(0) (menor prioridade).

    Exemplo:

        Se r(2) for '1', pcode será "11", independentemente dos valores de r(1) e r(0).

        Se r(2) for '0' e r(1) for '1', pcode será "10".

        Se r(2) e r(1) forem '0' e r(0) for '1', pcode será "01".

        Se nenhuma entrada for '1', pcode será "00".

    Uso no Sistema: No top principal, ele é usado para priorizar as operações (Carregar, Incrementar, Deslocar) com base nas entradas de controle.

div_clk (Divisor de Clock)

Este módulo é um divisor de frequência de clock que gera um pulso lento de habilitação.

    Funcionalidade: Ele divide um clock de alta frequência de entrada (clk) para produzir um sinal de habilitação (en) que é '1' por um único ciclo de clock a cada 50 milhões de ciclos do clock de entrada (definido pela constante N). Se o clock principal for de 50 MHz, isso gera um pulso de habilitação a cada segundo.

    Uso no Sistema: O sinal en é usado para controlar quando o registrador (FF_Ds) irá carregar um novo valor, efetivamente diminuindo a velocidade das operações para que possam ser observadas em um display ou LEDs.

FF_D (Flip-Flop Tipo D com Habilitação)

Este módulo é um Flip-Flop tipo D que captura um valor na borda de subida do clock, mas apenas se habilitado.

    Funcionalidade: Na borda de subida do clk, se o sinal de habilitação e for '1', o valor da entrada D é transferido para a saída Q. Caso contrário, Q mantém seu valor.

    Uso no Sistema: Quatro instâncias deste FF_D são usadas em paralelo para criar um registrador de 4 bits, onde D recebe o dado a ser armazenado e e é o sinal en (do divisor de clock) que controla a atualização.

inc_4bits (Incrementador de 4 bits)

Este módulo é um incrementador de 4 bits.

    Funcionalidade: Ele recebe uma entrada de 4 bits (inc_in) e produz uma saída (inc_out) que é o valor da entrada incrementado em 1. Ele usa a função unsigned() para tratar os std_logic_vector como números para a operação de adição.

    Uso no Sistema: Ele calcula o próximo valor caso a operação de incremento seja selecionada para o registrador.

mux_4x1 (Multiplexador 4 para 1)

Este módulo é um multiplexador de 4 entradas para 1 saída.

    Funcionalidade: Ele seleciona um de seus 4 bits de entrada (i(3) a i(0)) e o roteia para a saída s, com base no valor de um sinal de controle de 2 bits (c).

    Uso no Sistema: Quatro instâncias deste mux_4x1 são usadas em paralelo para formar um multiplexador de 4 bits. Este multiplexador é crucial para selecionar qual operação (carregar, incrementar, deslocar, manter) será aplicada ao registrador. A entrada c vem do cod_prio e define a operação.

top (Módulo Principal da Lógica)

Esta é a lógica principal do registrador de 4 bits com múltiplos modos de operação.

    Funcionalidade:

        Divisor de Clock (div_clk): Gera o sinal en para controlar a frequência das operações.

        Codificador de Prioridade (cod_prio): Recebe os sinais de controle cLD, cINC, cSHR (que vêm das chaves sw no módulo fpga) e os converte em um código de 2 bits (c) com prioridade, determinando a operação.

        Incrementador (inc_4bits): Calcula o valor incrementado do registrador atual (Q_inc).

        Multiplexadores (mux_4x1): Quatro multiplexadores selecionam o dado de entrada para cada bit do registrador (S_int) com base no código c gerado pelo cod_prio. As opções de entrada para cada bit são:

            Carregar (cLD): O valor da entrada L (do sw(3 downto 0)).

            Incrementar (cINC): O valor incrementado (Q_inc).

            Deslocar (cSHR): Desloca o registrador para a direita, com SHR_in (do sw(4)) entrando no bit mais significativo.

            Manter (nenhuma das anteriores): O valor atual do registrador (Q).

        Flip-Flops (FF_D): Quatro flip-flops armazenam o valor de 4 bits do registrador (Q), atualizando-o apenas quando o sinal en do divisor de clock estiver ativo.

    Entradas:

        clk: Clock do sistema.

        SHR_in: Bit de entrada para a operação de deslocamento à direita.

        cLD: Sinal de controle para Carregar.

        cINC: Sinal de controle para Incrementar.

        cSHR: Sinal de controle para Deslocar à direita.

        L: Entrada de 4 bits para a operação de Carregar.

    Saída:

        S: Saída de 4 bits que representa o valor atual do registrador.

fpga (Módulo Top-Level para FPGA)

Este módulo atua como o top-level (módulo principal) para o projeto quando implementado em um FPGA.

    Funcionalidade: Ele mapeia as portas do módulo top (o registrador) para os pinos físicos do FPGA, especificamente chaves (sw) e LEDs (led).

    Mapeamento:

        clk do FPGA para clk do top.

        sw(4) para SHR_in (bit de entrada para deslocamento).

        sw(7) para cLD (controle de carregar).

        sw(6) para cINC (controle de incrementar).

        sw(5) para cSHR (controle de deslocar).

        sw(3 downto 0) para L (dados de carregamento).

        led (saída de 4 bits para LEDs) para S (valor do registrador).

Resumo da Operação Completa

Este sistema permite que um usuário em um FPGA controle um registrador de 4 bits através de chaves. O divisor de clock garante que as operações ocorram em um ritmo lento e visível nos LEDs. O codificador de prioridade decide qual operação será executada se várias chaves de controle forem pressionadas simultaneamente. Os multiplexadores roteiam os dados apropriados (entrada, incrementado, deslocado) para os flip-flops, que armazenam o valor final do registrador. Os LEDs exibirão o estado atual do registrador.