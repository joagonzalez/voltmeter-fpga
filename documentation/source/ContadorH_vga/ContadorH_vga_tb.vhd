library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity contadorH_vga_tb is 

end;

architecture contadorH_vga_tb_arq of contadorH_vga_tb is
	signal clk : std_logic := '0';
	--signal rst : std_logic := '1';
	signal ena : std_logic := '1';
	signal Q : std_logic_vector (9 downto 0);
	signal out1 : std_logic;
begin 
 	clk <= not clk after 10 ns;
	ena <= '1' after 50 ns;
	inst : entity work.contadorH_vga port map (clk,ena,Q,out1);
	--rst <= '0' after 85 ns;
end;
