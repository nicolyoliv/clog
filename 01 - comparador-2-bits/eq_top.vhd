library ieee;
use ieee.std_logic_1164.all;

entity eq_top is
   port(
      sw  : in  std_logic_vector(3 downto 0); -- Entrada: 4 bits dos switches (chaves)
      led : out std_logic_vector(0 downto 0) -- Saída: 1 bit para o LED vermelho (indicando igualdade)
   );
end eq_top;

architecture struc_arch of eq_top is
begin
   -- O bloco 'eq2_unit' instancia (cria) o comparador de 2 bits.
   -- 'entity work.eq2(struc_arch)' indica que queremos usar a arquitetura 'struc_arch' 
   -- do componente 'eq2' definido no nosso diretório de trabalho ('work').
   eq2_unit : entity work.eq2(struc_arch)
      port map(
         -- Mapeamento das portas:
         -- Conecta os 2 bits mais significativos de 'sw' à entrada 'a' do comparador (A).
         a    => sw(3 downto 2), 
         -- Conecta os 2 bits menos significativos de 'sw' à entrada 'b' do comparador (B).
         b    => sw(1 downto 0),
         -- Conecta a saída de igualdade do comparador à saída 'led'.
         aeqb => led(0) 
      );
end struc_arch;