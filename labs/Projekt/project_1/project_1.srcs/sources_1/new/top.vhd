library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top is
  port (
    CLK100MHZ               : in  std_logic; 
    zap                     : in  std_logic; --nove
    SW                      : in  std_logic_vector(3 downto 0);   --nove
    BTNC                    : in  std_logic;  
    sig_timer_12bit_O       : out std_logic_vector(11 downto 0); 
    sig_rounds_6bit_O       : out std_logic_vector(5 downto 0);   
    sig_pause_12bit_O       : out std_logic_vector(11 downto 0);
    sig_clk_1ns_O           : out std_logic;
    sig_minutes             : buffer std_logic_vector(7 downto 0);
    sig_seconds             : buffer std_logic_vector(11 downto 0);
    sig_rounds              : out std_logic_vector(5 downto 0);   
    sig_pause               : out std_logic_vector(11 downto 0);
    sig_minutes_tens        : inout std_logic_vector(3 downto 0);
    sig_minutes_ones        : inout std_logic_vector(3 downto 0);
    sig_seconds_tens        : inout std_logic_vector(3 downto 0);
    sig_seconds_ones        : inout std_logic_vector(3 downto 0);
    sig_pause_tens          : inout std_logic_vector(3 downto 0);
    sig_pause_ones          : inout std_logic_vector(3 downto 0);
    an                      : out std_logic_vector(3 downto 0); -- anodes for the 7-segment displays
    seg                     : out std_logic_vector(6 downto 0); -- segments for the 7-segment displays
    
    --nove
    CA : out STD_LOGIC;
    CB : out STD_LOGIC;
    CC : out STD_LOGIC;
    CD : out STD_LOGIC;
    CE : out STD_LOGIC;
    CF : out STD_LOGIC;
    CG : out STD_LOGIC;

    --switches
    SW0 : in std_logic;
    SW1 : in std_logic;
    SW2 : in std_logic;
    SW3 : in std_logic;
    SW4 : in std_logic;
    SW5 : in std_logic;
    SW6 : in std_logic;
    SW7 : in std_logic;
    SW8 : in std_logic;
    SW9 : in std_logic;
    SW10 : in std_logic;
    SW11 : in std_logic;
    SW12 : in std_logic;
    SW13 : in std_logic;
    SW14 : in std_logic;
    SW15 : in std_logic

    
  );
end entity top;

-- Architecture body for top level
architecture behavioral of top is

  -- Signal declarations
  signal sig_pause_12bit    : std_logic_vector(11 downto 0);
  signal sig_rounds_6bit    : unsigned(5 downto 0) := (others => '0');
  signal sig_timer_12bit    : std_logic_vector(11 downto 0);
  signal sig_timer_en       : std_logic := '1';
  signal sig_pause_en       : std_logic := '0';
  signal sig_clk_1ns        : std_logic;
  signal seg_min_tens       : std_logic_vector(6 downto 0);
  signal seg_min_ones       : std_logic_vector(6 downto 0);
  signal seg_sec_tens       : std_logic_vector(6 downto 0);
  signal seg_sec_ones       : std_logic_vector(6 downto 0);
  signal round_limit_from_switches : unsigned(3 downto 0) := (others => '0');
  signal pause_limit_from_switches : unsigned(5 downto 0) := (others => '0');
  signal counter_limit_from_switches : unsigned(5 downto 0) := (others => '0');

type t_state is (
    COUNTER,
    PAUSE
);

  signal sig_state : t_state;
  
begin


--nove
--------------------------------------------------------------------
  -- Instance (copy) of hex_7seg entity
  --------------------------------------------------------------------

  hex2seg : entity work.hex_7seg
    port map (
      blank  => BTNC,
      hex    => SW,
      seg(6) => CA,
      seg(5) => CB,
      seg(4) => CC,
      seg(3) => CD,
      seg(2) => CE,
      seg(1) => CF,
      seg(0) => CG
      
    );

  -- Connect one common anode to 3.3V
  AN <= b"0111_0111";



  -- Instance of clock_enable entity
  clk_en1 : entity work.clock_enable
    generic map (
      g_MAX => 2      
    )
    port map (
      clk => CLK100MHZ, 
      rst => '0',     
      ce  => sig_clk_1ns 
    );

  -- Instance of cnt_up_down entity for Timer
  cnt_timer : entity work.cnt_up_down
    generic map (
      g_CNT_WIDTH => 12   
    )
    port map (
      clk    => sig_clk_1ns,       -- Main clock input
      rst    => BTNC,              
      en     => sig_timer_en,
      cnt_up => '1',              
      cnt    => sig_timer_12bit 
    );
    
    -- Instance of cnt_up_down entity for Timer
  cnt_pause : entity work.cnt_up_down
    generic map (
      g_CNT_WIDTH => 12    -- Counter width (12 bits)
    )
    port map (
      clk    => sig_clk_1ns,        
      rst    => BTNC,              
      en     => sig_pause_en,       
      cnt_up => '1',              
      cnt    => sig_pause_12bit    
    );
    
      -- Instance of hex_7seg entity for minutes tens
  hex_7seg_min_tens : entity work.hex_7seg
    port map (
      blank => '0',
      hex   => sig_minutes_tens,
      seg   => seg_min_tens
    );

  -- Instance of hex_7seg entity for minutes ones
  hex_7seg_min_ones : entity work.hex_7seg
    port map (
      blank => '0',
      hex   => sig_minutes_ones,
      seg   => seg_min_ones
    );

  -- Instance of hex_7seg entity for seconds tens
  hex_7seg_sec_tens : entity work.hex_7seg
    port map (
      blank => '0',
      hex   => sig_seconds_tens,
      seg   => seg_sec_tens
    );

  -- Instance of hex_7seg entity for seconds ones
  hex_7seg_sec_ones : entity work.hex_7seg
    port map (
      blank => '0',
      hex   => sig_seconds_ones,
      seg   => seg_sec_ones
    );

p_round_limit_switches : process (SW0, SW1, SW2, SW3) is
begin
  round_limit_from_switches <= (SW3 & SW2 & SW1 & SW0);
end process p_round_limit_switches;

p_pause_limit_switches : process (SW4, SW5, SW6, SW7, SW8, SW9) is
begin
  pause_limit_from_switches <= (SW9 & SW8 & SW7 & SW6 & SW5 & SW4);
end process p_pause_limit_switches;

p_counter_limit_switches : process (SW10, SW11, SW12, SW13, SW14, SW15) is
begin
  counter_limit_from_switches <= (SW15 & SW14 & SW13 & SW12 & SW11 & SW10);
end process p_counter_limit_switches;

p_pause_cycle : process (sig_clk_1ns) is
begin
  if (rising_edge(sig_clk_1ns)) then
    if (BTNC = '1') then
      sig_state             <= COUNTER;
      sig_rounds_6bit       <= "000000";
    elsif (zap = '1') then
      if (sig_rounds_6bit < round_limit_from_switches) then
        case sig_state is
          when COUNTER =>
            sig_timer_en <= '1';
            sig_pause_en <= '0';
            if (unsigned(sig_timer_12bit) = counter_limit_from_switches) then
              sig_state <= PAUSE;
              sig_rounds_6bit <= sig_rounds_6bit + 1;
              
            end if;
          when PAUSE =>
            sig_timer_en <= '0';
            sig_pause_en <= '1';
            if (unsigned(sig_pause_12bit) = pause_limit_from_switches) then
              sig_state <= COUNTER;
            end if;
        end case;
      else
        sig_timer_en <= '0';
        sig_pause_en <= '0';
      end if;
    end if;
  end if; 
end process p_pause_cycle;



p_out : process (sig_clk_1ns) is
begin
sig_timer_12bit_O   <= sig_timer_12bit;
  -- Output must be retyped from "unsigned" to "std_logic_vector"
sig_rounds_6bit_O   <= std_logic_vector(sig_rounds_6bit);
sig_pause_12bit_O   <= sig_pause_12bit;
sig_clk_1ns_O       <= sig_clk_1ns;
sig_rounds   <= std_logic_vector(sig_rounds_6bit);
sig_pause    <= sig_pause_12bit;
end process p_out;
    
p_extract_min_sec_pause : process (sig_timer_12bit)
  variable sig_minutes, sig_seconds: integer;
begin
  sig_minutes := to_integer(unsigned(sig_timer_12bit)) / 60;
  sig_seconds := to_integer(unsigned(sig_timer_12bit)) mod 60;
  
  sig_minutes_tens <= std_logic_vector(to_unsigned(sig_minutes / 10, 4));
  sig_minutes_ones <= std_logic_vector(to_unsigned(sig_minutes mod 10, 4));
  
  sig_seconds_tens <= std_logic_vector(to_unsigned(sig_seconds / 10, 4));
  sig_seconds_ones <= std_logic_vector(to_unsigned(sig_seconds mod 10, 4));
  
end process p_extract_min_sec_pause;

p_extract_pause : process (sig_pause_12bit)
  variable sig_pause_tens_val, sig_pause_ones_val, sig_pause_seconds: integer;
begin
  sig_pause_seconds := to_integer(unsigned(sig_pause_12bit(11 downto 0))) mod 60;

  sig_pause_tens_val := sig_pause_seconds / 10;
  sig_pause_ones_val := sig_pause_seconds mod 10;

  sig_pause_tens <= std_logic_vector(to_unsigned(sig_pause_tens_val, 4));
  sig_pause_ones <= std_logic_vector(to_unsigned(sig_pause_ones_val, 4));

end process p_extract_pause;


  -- Process for driving the 7-segment displays
p_drive_7seg : process (CLK100MHZ)
    variable counter : integer := 0;
  begin
    if rising_edge(CLK100MHZ) then
      counter := (counter + 1) mod 1000000; -- Change the divider value for the desired refresh rate
      
      case counter is
        when 0 =>
          an  <= "1110";
          seg <= seg_min_tens;
        when 250000 =>
          an  <= "1101";
          seg <= seg_min_ones;
        when 500000 =>
          an  <= "1011";
          seg <= seg_sec_tens;
        when 750000 =>
          an  <= "0111";
          seg <= seg_sec_ones;
        when others =>
          -- do nothing
      end case;
    end if;
  end process p_drive_7seg;

end architecture behavioral;