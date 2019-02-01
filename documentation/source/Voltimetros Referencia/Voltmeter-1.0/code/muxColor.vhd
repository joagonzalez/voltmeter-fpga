--	Multiplexor derminador de color (muxColor):						--
--	Módulo para la determinación del color de todos los caracteres 	--
--	a imprimir en pantalla basado en el siguiente código:			--
--	| rango de voltajes [V] | 	Color	   | RGB |					--
--	| 		0.00-0.99 		|	azul	   | 001 |					--
--	| 		1.00-1.99		|	verde	   | 010 |					--
--	| 		2.00-2.99		|	amarillo   | 110 |					--
--	| 		3.00-3.99		|	rojo 	   | 100 |					--
--	| 		4.00-inf	 	|   blanco 	   | 111 |					--
--	Artista: Calcagno, Misael Dominique. Legajo: CyT-6322 			--

library IEEE;
use IEEE.std_logic_1164.all;

entity muxColor is
    port(
	D1_color: in std_logic_vector(3 downto 0); 	-- Entrada codificada en BCD variable del Dígito más siginificativo
	R_c: out std_logic;				-- Salida variable en "1" para imprimir rojo
	G_c: out std_logic;				-- Salida variable en "1" para imprimir verde
	B_c: out std_logic				-- Salida variable en "1" para imprimir azul
    );
end muxColor;

architecture muxColor_arch of muxColor is

signal D1: std_logic_vector(3 downto 0); -- Cable vectorial auxiliar para cargar la entrada D1_color en la lógica

begin

	D1 <= D1_color; -- Carga del Dígito más significativo

--	0	=	0 		0		 0
	R_c <= D1(3) or D1(2) or D1(1); -- Vale "0" solo cuando D1="0000"="0" o D1="0001"="1" 

--	0	=	0	 	 0	  		0	  	 0			0		0			1				1
	G_c <= (D1(3) or D1(2) or D1(1) or D1(0)) and (D1(3) or D1(2) or (not D1(1)) or (not D1(0))); -- Vale "0" solo cuando D1="0000"="0" o D1="0011"="3"	

--	0	=	0		  0				1		     0	     0             1
	B_c <= (D1(3) or D1(2) or (not D1(0))) and (D1(3) or D1(2) or (not D1(1))); -- Vale "0" solo cuando D1="0001"="1", D1="0011"=3 o D1="0010"="2" 

end;
