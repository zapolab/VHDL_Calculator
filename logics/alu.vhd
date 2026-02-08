library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Definizione entita' ALU: gli ingressi devono tenere conto del segno!
entity alu is
  Port (
    -- Inserire qui le dichiarazioni delle porte:
    -- * Un ingresso 31 bit signed "a"
    -- * Un ingresso 31 bit signed "b"
    -- * 4 ingressi binari per la selezione dell'operazione "add, subtract, multiply, divide"
    -- * Una uscita 31 bit signed "r"
    a: in signed(31 downto 0);
    b: in signed(31 downto 0);
    r: out signed(31 downto 0);
    add: in std_logic;
    subtract: in std_logic;
    multiply: in std_logic;
    divide: in std_logic
  );
end alu;

-- Definizione architettura ALU
architecture Behavioral of alu is begin
  -- Processo viene eseguito ad ogni variazione su operandi e operazione selezionata
  process (a, b, add, subtract, multiply) 
    variable moltiplica: signed(63 downto 0);
  begin
    -- assegnazione di default
    r <= a;

    if add = '1' then
      r <= a + b;
    elsif subtract = '1' then
      r <= a - b;
    elsif multiply = '1' then
      moltiplica := a * b;
      r <= moltiplica(31 downto 0);
    end if;
  end process;

end Behavioral;
