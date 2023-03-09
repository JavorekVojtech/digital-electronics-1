library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------
entity tb_ff_rst is
  -- Entity of testbench is always empty
end entity tb_ff_rst;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------
architecture testbench of tb_ff_rst is

    constant c_CLK_100MHZ_PERIOD : time := 10 ns;

    -- local signals
    -- common to all flip-flops
    signal sig_clk_100MHz : std_logic;
    signal sig_rst        : std_logic;
    -- data signal common for D and T flip-flops
    signal sig_data_dt       : std_logic;
    -- D flip-flop signals
    signal sig_dq         : std_logic;
    signal sig_dq_bar     : std_logic;
    -- T flip-flop signals
    signal sig_tq         : std_logic;
    signal sig_tq_bar     : std_logic;
    -- JK flip-flop signals
    signal sig_data_j     : std_logic;
    signal sig_data_k     : std_logic;
    signal sig_jkq        : std_logic;
    signal sig_jkq_bar    : std_logic;

begin
    -- Connecting testbench signals with d_ff_rst and t_ff_rst entities
    -- (Unit Under Test)
    uut_d_ff_rst : entity work.d_ffs_rst
        port map (
            clk   => sig_clk_100MHz,
            rst   => sig_rst,
            d     => sig_data_dt,
            q     => sig_dq,
            q_bar => sig_dq_bar
        );
    uut_t_ff_rst : entity work.t_ff_rst
       port map (
           clk   => sig_clk_100MHz,
           rst   => sig_rst,
           t     => sig_data_dt,
           q     => sig_tq,
           q_bar => sig_tq_bar
       );
    uut_jk_ff_rst : entity work.jk_ff_rst
       port map (
           clk   => sig_clk_100Mhz,
           rst   => sig_rst,
           j     => sig_data_j,
           k     => sig_data_k,
           q     => sig_jkq,
           q_bar => sig_jkq_bar
       );

    -- clock generation process
    p_clk_gen : process
    begin
        while now < 350 ns loop -- 30 periods of 100MHz clock
            sig_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            sig_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;                -- Process is suspended forever
    end process p_clk_gen;

    -- reset generation process
    p_reset_gen : process
    begin
        sig_rst <= '0';
        wait for 120 ns;
        sig_rst <= '1';
        wait for 70 ns;
        sig_rst <= '0';
        wait for 160 ns;
        wait;
    end process p_reset_gen;

    -- D and T flip-flop data generation process
    dt_stimulus : process
    begin
        report "D/T stimulus process started";
        sig_data_dt <= '1'; wait for 61 ns;
        sig_data_dt <= '0'; wait for 80 ns;
        sig_data_dt <= '1'; wait for 46 ns;
        sig_data_dt <= '0'; wait for 55 ns;
        sig_data_dt <= '1'; wait for 58 ns;
        sig_data_dt <= '0'; wait for 25 ns;
        sig_data_dt <= '1'; wait for 25 ns;
        report "D/T stimulus process finished";
        wait;
    end process dt_stimulus;
    
    -- J(K) flip-flop data generation process
    j_stimulus : process
    begin
        report "J stimulus process started";
           
            while now < 350 ns loop
                sig_data_j <= '0';
                wait for 20 ns;
                sig_data_j <= '1';
                wait for 20 ns;
            end loop;
            
        report "J stimulus process finished";
        wait;
    end process j_stimulus;
        -- JK flip-flop data generation process
    k_stimulus : process
    begin
        report "K stimulus process started";
           
            while now < 350 ns loop
                sig_data_k <= '0';
                wait for 30 ns;
                sig_data_k <= '1';
                wait for 30 ns;
            end loop;
            
        report "K stimulus process finished";
        wait;
    end process k_stimulus;

end architecture testbench;