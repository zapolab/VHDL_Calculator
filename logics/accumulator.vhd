library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity accumulator is
  port (
    clock : in std_logic;
    reset : in std_logic;
    acc_init : in std_logic;
    acc_enable : in std_logic;
    acc_in : in signed(31 downto 0);
    acc_out : out signed(31 downto 0)
  );
end entity accumulator;

architecture Behavioral of accumulator is begin
  process ( clock, reset ) begin
    if reset = '0' then
      -- Valore di reset
      acc_out <= (others => '0');
    elsif rising_edge( clock ) then
      -- se acc_init e' attivo resetta l'uscita, altrimenti se acc_enable e' attivo
      -- rendi disponibile l'ingresso in uscita.
      if acc_init = '1' then
        acc_out <= (others => '0');
      elsif acc_enable = '1' then
        acc_out <= acc_in;
      end if;
    end if;
  end process;

end Behavioral;
