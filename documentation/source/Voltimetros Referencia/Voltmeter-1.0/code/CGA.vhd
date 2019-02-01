-- 	Character Generator and Asigner (CGA):												--
-- 	Módulo para la determinación de encendido o apagado de superpixels con ROM cargada	--
--	Artista: Calcagno, Misael Dominique. Legajo: CyT-6322 								--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CGA is
	port(
		char: in std_logic_vector(3 downto 0);		-- Entrada del caracter elegido
		pixel_x: in std_logic_vector(9 downto 0);	-- Entrada de la posición horizontal
		pixel_y: in std_logic_vector(9 downto 0);	-- Entrada de la posición vertical
		Wo: out std_logic							-- Salida binaria
		);
end;

architecture CGA_arch of CGA is

type matrix is array (0 to 7) of std_logic_vector(0 to 7);	-- Creación del tipo matriz 2 dimensiones 8x8

type matrix3D is array (0 to 11) of matrix;					-- Creación del tipo matriz 3 dimensiones 12x8x8

--..................................Declaración e indexación de la ROM..............................................--
constant ROM_0:  matrix:=("01111110","01000010","01000010","01000010","01000010","01000010","01000010","01111110");	--
constant ROM_1:  matrix:=("00001000","00001000","00001000","00001000","00001000","00001000","00001000","00001000");	--
constant ROM_2:  matrix:=("01111110","01000010","00000110","00001000","00010000","00100000","01000000","01111110");	--
constant ROM_3:  matrix:=("01111110","00000010","00000010","00111110","00000010","00000010","00000010","01111110");	--
constant ROM_4:  matrix:=("01000010","01000010","01000010","01000010","01111110","00000010","00000010","00000010");	--
constant ROM_5:  matrix:=("01111110","01000000","01000000","01111110","00000010","00000010","00000010","01111110");	--
constant ROM_6:  matrix:=("00011110","00100000","01000000","01111110","01000010","01000010","01000010","01111110");	--
constant ROM_7:  matrix:=("01111110","00000010","00000100","00000100","00001000","00001000","00010000","00010000");	--
constant ROM_8:  matrix:=("01111110","01000010","01000010","01111110","01000010","01000010","01000010","01111110");	--
constant ROM_9:  matrix:=("01111110","01000010","01000010","01111110","00000010","00000010","00000010","01111110");	--
constant ROM_10: matrix:=("00000000","00000000","00000000","00000000","00000000","00000000","00011000","00011000");	--
constant ROM_11: matrix:=("01000010","01000010","01000010","00100100","00100100","00100100","00011000","00011000");	--
--..................................................................................................................--

signal ROM: matrix3D:=(ROM_0,ROM_1,ROM_2,ROM_3,ROM_4,ROM_5,ROM_6,ROM_7,ROM_8,ROM_9,ROM_10,ROM_11);
															--
--..........Funcioamiento de subíndices:................................................................................--
--..........ROM(Z1)(Y2)(X4) = ROM_Z1(Y2)(X4)............................................................................-- 
--..........ROM_Z1 = ("Y10", "Y11", "Y12", "Y13", "Y14", "Y15", "Y16", "Y17")..=>..ROM(Z1)(Y2)(X4)="Y12"................--
--.........."Y2"='X120'X121'X122'X123'X124'X125'X126'X127'..=>..ROM(Z1)(Y2)(X4)='X124'..................................--

signal v, h: integer range 0 to 7; 		-- Índices verticales y horizontales
signal num: integer range 0 to 11;		-- Índice para el caracter
signal sp_h: std_logic_vector(2 downto 0);	-- Cable vectorial para la determinación del superpixel horizontal
signal sp_v: std_logic_vector(2 downto 0);	-- Cable vectorial para la determinación del superpixel vertical

begin

	sp_h <= pixel_x(6)&pixel_x(5)&pixel_x(4); -- Determinación del superpixel horizontal
	sp_v <= pixel_y(6)&pixel_y(5)&pixel_y(4); -- Determinación del superpixel vertical

	num <= to_integer(unsigned(char));	-- Determinación del subíndice para el caracter seleccionado
	h <= to_integer(unsigned(sp_h));	-- Determinación del subíndice para el superpixel horizontal
	v <= to_integer(unsigned(sp_v));	-- Determinación del subíndice para el superpixel vertical

	Wo <= ROM(num)(v)(h);	-- Salida binaria

end;