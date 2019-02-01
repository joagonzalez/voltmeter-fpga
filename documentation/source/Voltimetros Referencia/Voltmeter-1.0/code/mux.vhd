--	Multiplexor (mux):													--
--	Módulo para la determinación del caracter a imprimir a pantalla		--
--	Artista: Calcagno, Misael Dominique. Legajo: CyT-6322 				--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux is
    port(
       D1: in std_logic_vector(3 downto 0);		-- Entrada codificada en BCD variable del Dígito más siginificativo
       point: in std_logic_vector(3 downto 0);	-- Entrada codificada constante del punto decimal
       D2: in std_logic_vector(3 downto 0);		-- Entrada codificada en BCD variable del segundo Dígito más siginificativo 
       D3: in std_logic_vector(3 downto 0);		-- Entrada codificada en BCD variable del tercer Dígito más siginificativo
       V: in std_logic_vector(3 downto 0);		-- Entrada codificada constante del punto decimal
       charb: in std_logic_vector(9 downto 0);	-- Posición horizontal del pixel 
       mux_o: out std_logic_vector(3 downto 0)	-- Salida seleccionada
    );
end mux;

architecture mux_a of mux is

type matrix is array (4 downto 0) of std_logic_vector(3 downto 0);

signal pos: std_logic_vector(4 downto 0);
signal busm, buso: matrix;

begin

--	1		=		0			0			0					Franja de pantalla 1/5
	pos(0) <= not (charb(9) or charb(8) or charb(7));

--	1		=		0					0			  1			Franja de pantalla 2/5
	pos(1) <= (not charb(9)) and (not charb(8)) and charb(7);

--	1		=		0				1				0			Franja de pantalla 3/5
	pos(2) <= (not charb(9)) and charb(8) and (not charb(7));

--	1		=		0				1			1				Franja de pantalla 4/5
	pos(3) <= (not charb(9)) and charb(8) and charb(7);

--	1		=	1				  0					0			Franja de pantalla 5/5
	pos(4) <= charb(9) and (not charb(8)) and (not charb(7));
	
	busm(0) <= D1;
	busm(1) <= point;
	busm(2) <= D2;
	busm(3) <= D3;
	busm(4) <= V;
	
	chufa1: for i in 0 to 4 generate
	   buso(i) <= (busm(i)(3)and pos(i))&(busm(i)(2)and pos(i))&(busm(i)(1)and pos(i))&(busm(i)(0)and pos(i));
	end generate chufa1;
	
	mux_o <= buso(4) or buso(3) or buso(2) or buso(1) or buso(0);
	
end;