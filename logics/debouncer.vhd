library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
  generic (
    counter_size : integer := 4
  );
  port (
    clock : in std_logic;
    reset : in std_logic;
    bouncy : in std_logic;
    flat : out std_logic;
    pulse : out std_logic
  );
end entity debouncer;

architecture behavioral of debouncer is

  -- Definire i segnali interni
  signal count_en : std_logic;
  signal count_init : std_logic;
  signal counter : integer;
  signal tc : std_logic;
  signal prev_bouncy: std_logic;
  signal stable_value : std_logic;
  signal prev_stable : std_logic;

begin
  -- Define the counter
  process ( clock, reset ) begin
    -- Processo del contatore
    if reset = '0' then
        counter <= 0;
        tc <= '0';
    elsif rising_edge( clock ) then
        if count_init = '1' then
            counter <= 0;
        elsif count_en = '1' and counter /= counter_size then
            counter <= counter + 1;
        end if;
        
        if counter = counter_size then
            tc <= '1';
        else
            tc <= '0';
        end if;
    end if;
  
  end process;
  
  -- Define the controlling state machine
  process ( clock, reset ) begin
    if reset = '0' then
      -- Resettare la macchina a stati
      count_en <= '0';
      count_init <= '0';
      stable_value <= '0';
      prev_bouncy <= bouncy;
    elsif rising_edge( clock ) then
      -- Stati futuri
      -- if bouncy = prev_bouncy and bouncy = '1' then
      --   if tc = '1' then
      --       stable_value <= not stable_value;
      --       count_init <= '1';
      --       count_en <= '0';
      --   else
      --       count_init <= '0';
      --   end if;
      -- elsif bouncy = '1' then
      --   count_init <= '0';
      --   count_en <= '1';
      -- else
      --   count_init <= '0';
      -- end if;   
      -- prev_bouncy <= bouncy;
      
      if bouncy = '1' then
        if bouncy = prev_bouncy and tc = '1' then
          stable_value <= '1';
          -- count_init <= '1';
          -- count_en <= '0';
        else
          count_init <= '0';
          count_en <= '1';
        end if;
      else
        count_init <= '1';
        count_en <= '0';
        stable_value <= '0';
      end if;
      prev_bouncy <= bouncy;
   end if;

  end process;

  -- Edge detector
  process ( clock, reset ) begin
    if reset = '0' then
        pulse <= '0';
        prev_stable <= '0';
    elsif rising_edge( clock ) then
        if prev_stable = not stable_value and stable_value = '1' then
            pulse <= '1';
        else
            pulse <= '0';   
        end if;
        prev_stable <= stable_value;
    end if;    
  end process;

end architecture behavioral;
