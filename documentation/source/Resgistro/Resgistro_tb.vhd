library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Registro_tb is 

end;

architecture Registro_tb_arq of Registro_tb is
	signal clk : std_logic := '0';
	signal ena : std_logic := '1';
	signal Q : std_logic_vector (15 downto 0);
	signal D: std_logic_vector(15 downto 0);
begin 
 	clk <= not clk after 10 ns;
	ena <= '1' after 50 ns;
	inst : entity work.Registro port map (clk,ena,D,Q);
	D <= "1100000000000000";
end;
