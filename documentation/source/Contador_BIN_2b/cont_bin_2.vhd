library IEEE;
use IEEE.std_logic_1164.all;

entity cont_bin_2 is
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		set: in std_logic;
		Q: out std_logic_vector(1 downto 0)
	);
end;

architecture cont_bin_2_arq of cont_bin_2 is
	signal D0_aux, D1_aux: std_logic;
	signal Q0, Q1: std_logic;
begin

	-- Funcion D0
	D0_aux <= not Q0;
	
	-- Funcion D1
	D1_aux <= Q0 xor Q1;
	
	-- Instancia flip-flop 0
	ffd_0: entity work.ffd
		port map(
			clk => clk,
			rst => rst,
			ena => ena,
			set => set,
			D => D0_aux,
			Q => Q0
		);

	-- Instancia flip-flop 1
	ffd_1: entity work.ffd
		port map(
			clk => clk,
			rst => rst,
			ena => ena,
			set => set,
			D => D1_aux,
			Q => Q1
		);
	
	Q <= Q1 & Q0;
	
end;