--La ROM de caracteres funciona de la siguiente manera:
--Por char_address se le pasa el numero de caracter con el que se quiere trabajar. En este caso 000000 es A, 000001 es B, etc...
--Por font_col se le pasa la columna que se quiere sacar y por font_row la fila.
--Entonces el circuito es un mero combinacional al cual se le pasan esos 3 datos y por la salida saca un bit que esta "prendido" o "apagado" segun el caracter y la posicion en la que se esta parado. 






library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Char_ROM is
	generic(
		N: integer:= 6;
		M: integer:= 3;
		W: integer:= 8
	);
	port(
		char_address: in std_logic_vector(5 downto 0);			--Numero de caracter.
		font_row, font_col: in std_logic_vector(M-1 downto 0);  --Fila y columna del caracter
		rom_out: out std_logic									--Es la única salida de la rom. Saca un bit dependiendo del pixel que se tenga que mostrar del caracter.
	);
end;

architecture p of Char_ROM is
	subtype tipoLinea is std_logic_vector(0 to W-1);

	type char is array(0 to W-1) of tipoLinea;
	constant cero: char:= (
								"00111100",
								"01000010",
								"01000010",
								"01000010",
								"01000010",
								"01000010",
								"00111100",
								"00000000"
						);
	constant uno: char:= (
								"00001000",
								"00011000",
								"00001000",
								"00001000",
								"00001000",
								"00001000",
								"00011100",
								"00000000"
						);
	constant dos: char:= (
								"00111100",
								"01000010",
								"00000100",
								"00001000",
								"00010000",
								"00100000",
								"01111110",
								"00000000"
						);
	constant tres: char:= (
								"00111100",
								"01000010",
								"00000010",
								"00001100",
								"00000010",
								"01000010",
								"00111100",
								"00000000"
						);

	constant cuatro: char:= (
								"00001100",
								"00010100",
								"00100100",
								"01000100",
								"01000100",
								"01111110",
								"00000100",
								"00000000"
						);

	constant cinco: char:= (
								"01111100",
								"01000000",
								"01000000",
								"00111100",
								"00000010",
								"01000010",
								"00111100",
								"00000000"
						);

	constant seis: char:= (
								"00111100",
								"01000000",
								"01000000",
								"01111100",
								"01000010",
								"01000010",
								"00111100",
								"00000000"
						);

	constant siete: char:= (
								"00111110",
								"00000010",
								"00000100",
								"00001000",
								"00010000",
								"00010000",
								"00010000",
								"00000000"
						);

	constant ocho: char:= (
								"00011100",
								"00100010",
								"00100010",
								"00011100",
								"00100010",
								"00100010",
								"00011100",
								"00000000"
						);

	constant nueve: char:= (
								"00011100",
								"00100010",
								"00100010",
								"00100010",
								"00011110",
								"00000010",
								"00011100",
								"00000000"
						);

	constant V_Char: char:= (
								"01000010",
								"01000010",
								"01000010",
								"00100100",
								"00100100",
								"00011000",
								"00011000",
								"00000000"
						);
						
	constant punto: char:= (
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00011000",
								"00011000",
								"00000000"
						);
						
	constant blanco: char:= (
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000"
						);
						

	type memo is array(0 to 255) of tipoLinea;
	signal RAM: memo:= (
						0 => cero(0), 1 => cero(1), 2 => cero(2), 3 => cero(3), 4 => cero(4), 5 => cero(5), 6 => cero(6), 7 => cero(7),
						8 => uno(0), 9 => uno(1), 10 => uno(2), 11 => uno(3), 12 => uno(4), 13 => uno(5), 14 => uno(6), 15 => uno(7),
						16 => dos(0), 17 => dos(1), 18 => dos(2), 19 => dos(3), 20 => dos(4), 21 => dos(5), 22 => dos(6), 23 => dos(7),
						24 => tres(0), 25 => tres(1), 26 => tres(2), 27 => tres(3), 28 => tres(4), 29 => tres(5), 30 => tres(6), 31 => tres(7),
						32 => cuatro(0), 33 => cuatro(1), 34 => cuatro(2), 35 => cuatro(3), 36 => cuatro(4), 37 => cuatro(5), 38 => cuatro(6), 39 => cuatro(7),
						40 => cinco(0), 41 => cinco(1), 42 => cinco(2), 43 => cinco(3), 44 => cinco(4), 45 => cinco(5), 46 => cinco(6), 47 => cinco(7),
						48 => seis(0), 49 => seis(1), 50 => seis(2), 51 => seis(3), 52 => seis(4), 53 => seis(5), 54 => seis(6), 55 => seis(7),
						56 => siete(0), 57 => siete(1), 58 => siete(2), 59 => siete(3), 60 => siete(4), 61 => siete(5), 62 => siete(6), 63 => siete(7),
						64 => ocho(0), 65 => ocho(1), 66 => ocho(2), 67 => ocho(3), 68 => ocho(4), 69 => ocho(5), 70 => ocho(6), 71 => ocho(7),
						72 => nueve(0), 73 => nueve(1), 74 => nueve(2), 75 => nueve(3), 76 => nueve(4), 77 => nueve(5), 78 => nueve(6), 79 => nueve(7),
						80 => V_Char(0), 81 => V_Char(1), 82 => V_Char(2), 83 => V_Char(3), 84 => V_Char(4), 85 => V_Char(5), 86 => V_Char(6), 87 => V_Char(7),
						88 => punto(0), 89 => punto(1), 90 => punto(2), 91 => punto(3), 92 => punto(4), 93 => punto(5), 94 => punto(6), 95 => punto(7),
						96 => blanco(0), 97 => blanco(1), 98 => blanco(2), 99 => blanco(3), 100 => blanco(4), 101 => blanco(5), 102 => blanco(6), 103 => blanco(7),
						104 to 255 => "00000000"
				);

	signal char_addr_aux: unsigned(8 downto 0);
	
begin

	char_addr_aux <= unsigned(char_address) & unsigned(font_row);
	rom_out <= RAM(to_integer(char_addr_aux))(to_integer(unsigned(font_col)));

end;