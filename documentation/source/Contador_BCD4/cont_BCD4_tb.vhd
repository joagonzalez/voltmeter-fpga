library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.utils.all;
entity cont_BCD4_tb is 

end;

architecture cont_BCD4_tb_arq of cont_BCD4_tb is
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal ena : std_logic := '1';
	signal Q : vector (3 downto 0);
	
begin 
 	clk <= not clk after 10 ns;
	ena <= '1' after 50 ns;
	inst : entity work.cont_BCD4 port map (clk,ena,rst,Q);
	rst <= '0' after 85 ns;
end;