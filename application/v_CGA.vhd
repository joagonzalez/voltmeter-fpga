library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.matrix_type.all;

entity v_CGA is
	port(
		char: in std_logic_vector(3 downto 0);
		font_x, font_y: in std_logic_vector(9 downto 0);
		rom_out: out std_logic
	);
end;

architecture v_CGA_a of v_CGA is

	component v_mux_2x1 is
		port(
			mux_x, mux_y, mux_sel: in std_logic;
			mux_out: out std_logic
		);
	end component;

	constant cero: matrix_ROM:= (
								"00111100",
								"01000010",
								"01000010",
								"01000010",
								"01000010",
								"01000010",
								"00111100",
								"00000000"
						);
	constant uno: matrix_ROM:= (
								"00001000",
								"00011000",
								"00001000",
								"00001000",
								"00001000",
								"00001000",
								"00011100",
								"00000000"
						);
	constant dos: matrix_ROM:= (
								"00111100",
								"01000010",
								"00000100",
								"00001000",
								"00010000",
								"00100000",
								"01111110",
								"00000000"
						);
	constant tres: matrix_ROM:= (
								"00111100",
								"01000010",
								"00000010",
								"00001100",
								"00000010",
								"01000010",
								"00111100",
								"00000000"
						);

	constant cuatro: matrix_ROM:= (
								"00001100",
								"00010100",
								"00100100",
								"01000100",
								"01000100",
								"01111110",
								"00000100",
								"00000000"
						);

	constant cinco: matrix_ROM:= (
								"01111100",
								"01000000",
								"01000000",
								"00111100",
								"00000010",
								"01000010",
								"00111100",
								"00000000"
						);

	constant seis: matrix_ROM:= (
								"00111100",
								"01000000",
								"01000000",
								"01111100",
								"01000010",
								"01000010",
								"00111100",
								"00000000"
						);

	constant siete: matrix_ROM:= (
								"00111110",
								"00000010",
								"00000100",
								"00001000",
								"00010000",
								"00010000",
								"00010000",
								"00000000"
						);

	constant ocho: matrix_ROM:= (
								"00011100",
								"00100010",
								"00100010",
								"00011100",
								"00100010",
								"00100010",
								"00011100",
								"00000000"
						);

	constant nueve: matrix_ROM:= (
								"00011100",
								"00100010",
								"00100010",
								"00100010",
								"00011110",
								"00000010",
								"00011100",
								"00000000"
						);

	constant V_Char: matrix_ROM:= (
								"01000010",
								"01000010",
								"01000010",
								"00100100",
								"00100100",
								"00011000",
								"00011000",
								"00000000"
						);
						
	constant punto: matrix_ROM:= (
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00011000",
								"00011000",
								"00000000"
						);
						
	constant blanco: matrix_ROM:= (
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000"
						);
						

    signal ROM: matrix3D_ROM:=(cero,uno,dos,tres,cuatro,cinco,seis,siete,ocho,nueve,V_Char,punto);

    signal v, h: integer range 0 to 7; 		    -- Indices verticales y horizontales
    signal digito: integer range 0 to 11;		-- Indice para el caracter
    signal pos_h: std_logic_vector(2 downto 0);	-- Cable vectorial para la determinacion del pixel horizontal
    signal pos_v: std_logic_vector(2 downto 0);	-- Cable vectorial para la determinacion del pixel vertical

	signal v_cond: std_logic;
	signal char_out: std_logic;
begin

	pos_h <= font_x(6)&font_x(5)&font_x(4); -- Determinacion del pixel horizontal
	pos_v <= font_y(6)&font_y(5)&font_y(4); -- Determinacion del pixel vertical

	digito <= to_integer(unsigned(char));	-- Determinacion del subondice para el caracter seleccionado
	h <= to_integer(unsigned(pos_h));	-- Determinacion del subindice para el pixel horizontal
	v <= to_integer(unsigned(pos_v));	-- Determinacion del subindice para el pixel vertical

	-- Condicion para habilitar salida (001)
	v_cond <= (not font_y(9)) and (not font_y(8)) and font_y(7);
	-- Caracter seleccionado
	char_out <= ROM(digito)(v)(h);

	mux_selector: v_mux_2x1
		port map(
			mux_x => '0',
			mux_y => char_out,
			mux_sel => v_cond,
			mux_out => rom_out
		);
end;