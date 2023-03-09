library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jk_ff_rst is
    Port ( clk   : in STD_LOGIC;
           j     : in STD_LOGIC;
           k     : in STD_LOGIC;
           q     : out STD_LOGIC;
           q_bar : out STD_LOGIC;
           rst   : in STD_LOGIC);
end jk_ff_rst;

architecture Behavioral of jk_ff_rst is
    -- it must use this local signal instead of output ports
    -- because "out" ports cannot be read within the architecture
    signal sig_q : std_logic;
begin
 p_jk_ff_rst : process (clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then 
                sig_q <= '0';
            else 
                -- characteristic bool logic function of JK-type flip flop
                sig_q <= (j and not sig_q) or (not k and sig_q);
            end if; 
        end if; 

    end process p_jk_ff_rst;
    -- output ports are permanently connected to local signal
    q     <= sig_q;
    q_bar <= not sig_q;
end Behavioral;