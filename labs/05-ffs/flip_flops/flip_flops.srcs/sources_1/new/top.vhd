----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2023 12:05:46 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (0 downto 0);
           LED : out STD_LOGIC_VECTOR (3 downto 0));
end top;

------------------------------------------------------------------------
-- Architecture body for top level
------------------------------------------------------------------------
architecture behavioral of top is

  -- Internal signals between flip-flops
  signal sig_ff0 : std_logic;
  signal sig_ff1 : std_logic;
  signal sig_ff2 : std_logic;
  signal sig_ff3 : std_logic;
  
  signal sig_ff0_bar : std_logic;
  signal sig_ff1_bar : std_logic;
  signal sig_ff2_bar : std_logic;
  signal sig_ff3_bar : std_logic;

begin

  --------------------------------------------------------------------
  -- Four instances (copies) of D-type FF entity
  d_ff_0 : entity work.d_ffs_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          d => SW(0),
          q  => sig_ff0,
          q_bar => sig_ff0_bar
      );
  d_ff_1 : entity work.d_ffs_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          d => sig_ff0,
          q  => sig_ff1,
          q_bar => sig_ff1_bar
      );
  d_ff_2 : entity work.d_ffs_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          d => sig_ff1,
          q  => sig_ff2,
          q_bar => sig_ff2_bar
      );
   d_ff_3 : entity work.d_ffs_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          d => sig_ff2,
          q  => sig_ff3,
          q_bar => sig_ff3_bar
      ); 
    LED <= sig_ff3 & sig_ff2 & sig_ff1 & sig_ff0;
end architecture behavioral;
