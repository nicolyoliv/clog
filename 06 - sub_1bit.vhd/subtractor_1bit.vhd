library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade: Subtrator Completo de 1 bit (Full Subtractor)
entity subtractor_1bit is
    port(
        a : in std_logic;      -- Minuendo (A)
        b : in std_logic;      -- Subtraendo (B)
        bi : in std_logic;     -- Borrow de entrada (B_in)
        bo : out std_logic;    -- Borrow de saída (B_out)
        d : out std_logic      -- Diferença (D)
    );
end subtractor_1bit;

-- Arquitetura: Implementa a lógica combinacional do Subtrator Completo.
architecture subtractor_arch of subtractor_1bit is
begin
    -- Equação da Diferença: D = A ⊕ B ⊕ B_in
    d <= (a xor b xor bi);
    
    -- Equação do Borrow Out: B_out = (A' · B) + (A' · B_in) + (B · B_in)
    bo <= (not(a) and b) or (not(a) and bi) or (b and bi);

end subtractor_arch;

A,B,Bin​,D (Diferença),Bout​ (Empréstimo)
0,0,0,0,0
0,0,1,1,1
0,1,0,1,1
0,1,1,0,1
1,0,0,1,0
1,0,1,0,0
1,1,0,0,0
1,1,1,1,1
D = A xor B xor bin 
bout= (A' .B) + (A'. B_{in}) + (B.B_{in})$$