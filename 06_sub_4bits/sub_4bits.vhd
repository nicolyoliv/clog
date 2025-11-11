library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaração da entidade: Subtrator de 4 bits
entity subtractor_4bits is
    port(
        num1, num2 : in std_logic_vector(3 downto 0); -- Entradas A (Minuendo) e B (Subtraendo)
        num3 : out std_logic_vector(4 downto 0)      -- Saída de 5 bits (4 da diferença + 1 do borrow out)
    );
end subtractor_4bits;

-- Arquitetura: Instancia 4 subtratores de 1 bit.
architecture subtractor_arch of subtractor_4bits is
    signal bo0, bo1, bo2 : std_logic;          -- Sinais de borrow intermediários (B1, B2, B3)
    signal D_result : std_logic_vector(3 downto 0); -- Sinal interno para os 4 bits da Diferença
    signal B_final : std_logic;                -- Sinal interno para o Borrow Out Final (B4)

    -- Declaração do componente de 1 bit
    component subtractor_1bit
        port( a : in std_logic; b : in std_logic; bi : in std_logic; bo : out std_logic; s : out std_logic );
    end component;
    
begin
    -- Subtrator do LSB (bit 0)
    subtractor_a: entity work.subtractor_1bit(subtractor_arch)
    port map(
        a => num1(0),
        b => num2(0),
        bi => '0',        -- O borrow inicial é 0
        bo => bo0,
        s => D_result(0)
    );
    
    -- Subtrator do bit 1, usando o borrow out do anterior
    subtractor_b: entity work.subtractor_1bit(subtractor_arch)
    port map(
        a => num1(1),
        b => num2(1),
        bi => bo0,
        bo => bo1,
        s => D_result(1)
        );
        
    -- Subtrator do bit 2
    subtractor_c: entity work.subtractor_1bit(subtractor_arch)
    port map(
        a => num1(2),
        b => num2(2),
        bi => bo1,
        bo => bo2,
        s => D_result(2)
    );
    
    -- Subtrator do MSB (bit 3)
    subtractor_d: entity work.subtractor_1bit(subtractor_arch)
    port map(
        a => num1(3),
        b => num2(3),
        bi => bo2,
        bo => B_final,   -- O borrow out final (B4)
        s => D_result(3)
    );

    -- Atribuição da Saída: Concatenação do Borrow Final (MSB) e os 4 bits da Diferença.
    num3 <= B_final & D_result;  

end subtractor_arch;