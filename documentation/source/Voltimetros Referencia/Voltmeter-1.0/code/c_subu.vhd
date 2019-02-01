-- Celda Substractora Unitaria (c_subu):	                   	--
-- Módulo para generar restadores binarios              		--
-- Artista: Calcagno, Misael Dominique. Legajo: CyT-6322 		--

library IEEE;
use IEEE.std_logic_1164.all;

entity c_subu is
	port(
		ena: in std_logic;	-- Enable del módulo
		num: in std_logic;    	-- Sustraendo
		sub: in std_logic;  	-- Subtractor
		Ci: in std_logic;	-- Carry de entrada
		R: out std_logic;	-- Resultado
		Co: out std_logic	-- Carry de salida
	);
end;

architecture c_subu_a of c_subu is

begin

R  <= ena 
	and (((not Ci) and (((not num) and sub) or (num and (not sub)))) 
	or (Ci and (((not num) and (not sub)) or (num and sub))));

Co <= ((not Ci) and ((not num) and sub)) 
	or (Ci and (not num)) 
	or (Ci and sub);

end;