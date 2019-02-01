--	Registro de I/O x 4 (REG4):															--
--	Módulo para el registro de cuatro estados binarios utilizando un array de 4 ffD		--
--	Artista: Calcagno, Misael Dominique. Legajo: CyT-6322			 					--

library IEEE;
use IEEE.std_logic_1164.all;

entity REG4 is
	port(
		clk: in std_logic;			-- Clock del sistema
		ena: in std_logic;			-- Enable del sistema
		rst: in std_logic;			-- Reset del sistema
		D_REG4: in std_logic_vector(3 downto 0);	-- Entrada vectorial al módulo
		Q_REG4: out std_logic_vector(3 downto 0)	-- Salida vectorial del módulo
	);
end;

architecture REG4_a of REG4 is

component ffd
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D: in std_logic;
		Q: out std_logic
	);	
end component;

begin

	ffd_block: for i in 0 to 3 generate
		ffd_i: ffd
			port map(
				clk => clk,			-- Clock del sistema
				rst => rst,			-- Reset del sistema
				ena => ena,			-- Enable del sistema
				D => D_REG4(i),		-- Entrada indexada al módulo
				Q => Q_REG4(i)		-- Salida indexada del módulo
			);
	end generate ffd_block;

end;