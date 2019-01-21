
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity cont_BCD_tb is 

end;

architecture cont_BCD_tb_arq of cont_BCD_tb is
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal ena : std_logic := '1';
	signal Q : std_logic_vector (3 downto 0);
	signal hab : std_logic;
begin 
 	clk <= not clk after 10 ns;
	ena <= '1' after 50 ns;
	inst : entity work.cont_BCD port map (clk,ena,rst,hab,Q);
	rst <= '0' after 85 ns;
end;
