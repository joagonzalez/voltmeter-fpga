library IEEE;
use IEEE.std_logic_1164.all;

entity cont_bin_2_tb is
end;

architecture cont_bin_2_tb_arq of cont_bin_2_tb is
	signal clk_tb: std_logic := '0';
	signal rst_tb: std_logic := '1';
	signal set_tb: std_logic := '0';
	signal ena_tb: std_logic := '1';
	signal Q_tb: std_logic_vector(1 downto 0);

begin
	clk_tb <= not clk_tb after 10 ns;
	rst_tb <= '0' after 100 ns;
	ena_tb <= '0' after 300 ns, '1' after 500 ns;

	DUT: entity work.cont_bin_2
		port map(
			clk => clk_tb,
			rst => rst_tb,
			set => set_tb,
			ena => ena_tb,
			Q => Q_tb
		);
	
end;