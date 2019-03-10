library IEEE;
use IEEE.std_logic_1164.all;

use work.matrix_type.all;

entity a2d_tb is
end;

architecture a2d_tb_A of a2d_tb is

    signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '1';
    signal ena_tb : std_logic := '1';
	signal entrada_tb :std_logic := '1';	
	signal D1_tb: std_logic_vector(3 downto 0);
	signal D2_tb: std_logic_vector(3 downto 0);
	signal D3_tb: std_logic_vector(3 downto 0);
	signal point_tb: std_logic_vector(3 downto 0);
	signal V_tb: std_logic_vector(3 downto 0);
	signal Q_33000_tb: std_logic_vector(15 downto 0);
	signal Q_BCD_tb: matrix;
	
begin
	clk_tb <= not clk_tb after 10 ns;
	ena_tb <= '1' after 100 ns;
	rst_tb <= '0' after 10 ns;
	--entrada_tb <= '0' after 33001 ns, '1' after 55000 ns;
	
	block_instance : entity work.a2d port map (
            clk => clk_tb,
            rst => rst_tb,
            ena => ena_tb,
            entrada => entrada_tb,
			D1  => D1_tb,
			D2 => D2_tb,
			D3  => D3_tb,
			point  => point_tb,
			V => V_tb,
			Q_33000 => Q_33000_tb,
			bcd => Q_BCD_tb
        );
		
end;