library ieee;
use ieee.std_logic_1164.all;

-- Módulo que executa o deslocamento baseado no código de modo (mode) de 2 bits.
entity shifter is
    port(
        mode : in std_logic_vector(1 downto 0);   -- Entrada: Código de 2 bits (prio_mode)
        bits_in : in std_logic_vector(2 downto 0); -- Entrada: 3 bits de dados (D2 D1 D0)
        bits_out : out std_logic_vector(2 downto 0) -- Saída: 3 bits de resultado (Y2 Y1 Y0)
    );
end shifter;

architecture shifter_arch of shifter is
begin
    -- O processo é reativado com qualquer mudança nas entradas combinacionais (mode, bits_in).
    process(mode, bits_in)
    begin
        -- Caso "11": Deslocamento Lógico para a DIREITA (SHR)
        if mode = "11" then
            -- Y = 0 D2 D1
            bits_out(2) <= '0';                         -- Bit MSB (Y2) é preenchido com '0'
            bits_out(1 downto 0) <= bits_in(2 downto 1);  -- Move D2 para Y1, D1 para Y0
            
        -- Caso "10": Deslocamento CIRCULAR para a DIREITA (SHRC)
        elsif mode = "10" then
            -- Y = D0 D2 D1
            bits_out(2) <= bits_in(0);                  -- Bit LSB (D0) é movido para o MSB (Y2)
            bits_out(1 downto 0) <= bits_in(2 downto 1);  -- Move D2 para Y1, D1 para Y0
            
        -- Caso "01": Deslocamento Lógico para a ESQUERDA (SHL)
        elsif mode = "01" then
            -- Y = D1 D0 0
            bits_out(0) <= '0';                         -- Bit LSB (Y0) é preenchido com '0'
            bits_out(2 downto 1) <= bits_in(1 downto 0);  -- Move D1 para Y2, D0 para Y1
            
        -- Caso "00": Manter o valor (NO-OP)
        else
            bits_out <= bits_in;                         -- Y = D2 D1 D0
        end if;
    end process;
end shifter_arch;

As equações definem a saída $Y_i$ como função dos dados de entrada $D_i$ e do modo de controle $P_1 P_0$ (onde $P = \text{mode}$ do módulo shifter).$$\mathbf{Y_2} = (P_1 \cdot P_0 \cdot 0) + (P_1 \cdot P_0' \cdot D_0) + (P_1' \cdot P_0 \cdot D_1) + (P_1' \cdot P_0' \cdot D_2)$$Onde $(P_1 \cdot P_0 \cdot 0)$ é a condição SHR, resultando em 0.$$\mathbf{Y_1} = (P_1 \cdot P_0 \cdot D_2) + (P_1 \cdot P_0' \cdot D_2) + (P_1' \cdot P_0 \cdot D_0) + (P_1' \cdot P_0' \cdot D_1)$$A operação SHR e SHRC usam $D_2$. A operação SHL usa $D_0$.$$\mathbf{Y_0} = (P_1 \cdot P_0 \cdot D_1) + (P_1 \cdot P_0' \cdot D_1) + (P_1' \cdot P_0 \cdot 0) + (P_1' \cdot P_0' \cdot D_0)$$Onde $(P_1' \cdot P_0 \cdot 0)$ é a condição SHL, resultando em 0.