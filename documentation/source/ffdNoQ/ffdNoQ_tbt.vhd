
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ffdNoQ_tb is 

end;

architecture ffdNoQ_tb_arq of ffdNoQ_tb is
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal set : std_logic := '1';
	signal ena : std_logic := '1';
	signal D : std_logic := '0';
	signal Q : std_logic;
	signal notQ: std_logic;
begin 
 	clk <= not clk after 10 ns;
	ena <= '1';
	set <= '0';
	inst : entity work.ffdNoQ port map (clk,rst,set,ena,D,Q,notQ);
	rst <= '0' after 85 ns;
	D <= '1';
end;
