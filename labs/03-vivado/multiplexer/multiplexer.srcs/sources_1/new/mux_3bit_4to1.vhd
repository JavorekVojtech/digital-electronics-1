----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2023 12:12:36 PM
-- Design Name: 
-- Module Name: mux_3bit_4to1 - Behavioral
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

entity mux_3bit_4to1 is
    Port ( a : in STD_LOGIC_VECTOR (2 downto 0);
           b : in STD_LOGIC_VECTOR (2 downto 0);
           c : in STD_LOGIC_VECTOR (2 downto 0);
           d : in STD_LOGIC_VECTOR (2 downto 0);
           f : out STD_LOGIC_VECTOR (2 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0));
           B_less_A    : out STD_LOGIC;
           B_greater_A : out STD_LOGIC;
           B_equals_A  : out STD_LOGIC;
end mux_3bit_4to1;

architecture Behavioral of mux_3bit_4to1 is

begin
    B_greater_A <= "1";
    B_equals_A  <= "0";
    with sel select
    f <= a when "00",  
         b when "01",
         c when "11",
         d when others; -- All other combinations
end Behavioral;
