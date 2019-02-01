-- Celda Contadora binaria universal:	                     					--
-- Módulo para generar contadores Binarios              						--
-- Artista: Calcagno, Misael Dominique. Legajo: CyT-6322 						--

library IEEE;
use IEEE.std_logic_1164.all;

entity c_bu is
	port(
		clk: in std_logic;	-- Clock del sistema
		rst: in std_logic;	-- Reset del módulo
		ena: in std_logic;	-- Enable del módulo
		D: in std_logic;    -- Entrada del carry del módulo anterior
		Q: out std_logic;   -- Salida del módulo
		C: out std_logic    -- Carry de salida
	);
end;

architecture c_bu_a of c_bu is

component ffd
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D: in std_logic;
		Q: out std_logic
	);	
end component;

signal D_x: std_logic;		-- Cable auxiliar para conectar la entrada del módulo
signal D_ff: std_logic;		-- Cable auxiliar para conectar la entrada del flip-flop
signal Q_x: std_logic;		-- Cable auxiliar para conectar la salida del módulo

begin
    ffd1: ffd
       port map(
          clk => clk,		-- Clock del sistema
          rst => rst,		-- Reset del módulo
          ena => ena,		-- Enable del módulo
          D => D_ff,
          Q => Q_x
	  );
    C <= D_x and Q_x;
    D_ff <= D_x xor Q_x;
    D_x <= D;
    Q <= Q_x;
end;