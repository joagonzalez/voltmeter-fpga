----------------------------------------------------------------------------------
-- Modulo: aplicVGA_2
-- Descripción: Aplicación para mostrar el uso del controlador de VGA (VGActrl)
-- Autor: Electrónica Digital I
--        Universidad de San Martín - Escuela de Ciencia y Tecnología
--        http://www.mascampus.unsam.edu.ar/course/view.php?id=54512
-- Fecha: 06/05/14
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity aplicVGA2 is
	generic(
		N: integer:= 6;
		M: integer:= 3;
		W: integer:= 8
	);
	port(
		clk: in std_logic;
		RxRdy: in std_logic;
		hsync : out std_logic;
		vsync : out std_logic;
		red_out : out std_logic;
		grn_out : out std_logic;
		blu_out : out std_logic
	);
	
	-- Mapeo de pines para el kit spartan 3E starter
	attribute loc: string;
	attribute loc of clk: signal is "C9";
	attribute loc of RxRdy: signal is "L13";	-- Switch SW0
	attribute loc of hsync: signal is "F15";	-- HS
	attribute loc of vsync: signal is "F14";	-- VS
	attribute loc of red_out: signal is "H14";	-- RED
	attribute loc of grn_out: signal is "H15";	-- GRN
	attribute loc of blu_out: signal is "G15";	-- BLUE
	
end aplicVGA2;

architecture aplicVGA2_arq of aplicVGA2 is

	component vga_ctrl is
		port(
			clk : in std_logic;
			red_i : in std_logic;
			grn_i : in std_logic;
			blu_i : in std_logic;
			hs : out std_logic;
			vs : out std_logic;
			red_o : out std_logic;
			grn_o : out std_logic;
			blu_o : out std_logic;
			pixel_x: out std_logic_vector(9 downto 0);
			pixel_y: out std_logic_vector(9 downto 0)
		);
	end component vga_ctrl;

	component Char_ROM is
		generic(
			N: integer:= 6;
			M: integer:= 3;
			W: integer:= 8
		);
		port(
			char_address: in std_logic_vector(5 downto 0);
			font_row, font_col: in std_logic_vector(M-1 downto 0);
			rom_out: out std_logic
		);
	end component;
	
	signal rom_out, enable: std_logic;
	signal address: std_logic_vector(5 downto 0);
	signal font_row, font_col: std_logic_vector(M-1 downto 0);
	signal red_in, grn_in, blu_in: std_logic;
	signal pixel_row, pixel_col, pixel_col_aux, pixel_row_aux: std_logic_vector(9 downto 0);
	signal sig_startTX: std_logic;
	
	signal char_in: unsigned(7 downto 0) := "01001110";
	signal char0, char1, char2: unsigned(3 downto 0);
	signal salMux: unsigned(3 downto 0);
	
	constant char_punto: unsigned(3 downto 0) := "1011";	-- caracter '.'
	constant char_V: unsigned(3 downto 0) := "1010";		-- caracter 'V'
	constant char_blanco: unsigned(3 downto 0) := "1100";	-- caracter ' '
	
	signal sel: std_logic_vector(2 downto 0);
	signal ena_fila: std_logic;
	
begin
	address <= "00" & std_logic_vector(salMux);
	
	mux_process: process(char0, char1, char2, sel)
	begin
		case sel is
			when "000" => salMux <= char0;
			when "001" => salMux <= char1;
			when "010" => salMux <= char2;
			when "011" => salMux <= char_punto;
			when "100" => salMux <= char_V;
			when "101" => salMux <= char_blanco;
			when others => salMux <= char_blanco;
		end case;
	end process;
	
	aaa: vga_ctrl port map(clk, red_in, grn_in, blu_in, hsync, vsync, red_out, grn_out, blu_out, pixel_col, pixel_row);
	
	font_row <= pixel_row(2 downto 0);
	font_col <= pixel_col(2 downto 0);
	
	red_in <= rom_out;
	grn_in <= rom_out;
	blu_in <= '1';

	bbb: Char_ROM port map(address, font_row, font_col, rom_out);
	
	ena_fila <= '1' when to_integer(unsigned(pixel_row(9 downto 3))) = 30 else '0';
	
	process(pixel_row, pixel_col)
	begin
		if to_integer(unsigned(pixel_col(9 downto 3))) = 37 and ena_fila = '1' then
			sel <= "000";
		elsif to_integer(unsigned(pixel_col(9 downto 3))) = 38 and ena_fila = '1' then
			sel <= "011";
		elsif to_integer(unsigned(pixel_col(9 downto 3))) = 39 and ena_fila = '1' then
			sel <= "001";
		elsif to_integer(unsigned(pixel_col(9 downto 3))) = 40 and ena_fila = '1' then
			sel <= "010";
		elsif to_integer(unsigned(pixel_col(9 downto 3))) = 41 and ena_fila = '1' then
			sel <= "100";
		else
			sel <= "101";
		end if;
	end process;

	---------------------------------------------------------------------------------------------
	-- Contador para prueba
	contador: process(clk)
		variable aux0, aux1, aux2: integer := 0;
	begin
		if rising_edge(clk) then
			aux0 := aux0 + 1;
			if aux0 = 50000000 then
				aux0 := 0;
				aux1 := aux1 + 1;
				char0 <= char0 + 1;
				if char0 = "1001" then
					char0 <= "0000";
				end if;
			elsif aux1 = 2 then
				aux1 := 0;
				aux2 := aux2 + 1;
				char1 <= char1 + 1;
				if char1 = "1001" then
					char1 <= "0000";
				end if;
			elsif aux2 = 2 then
				aux2 := 0;
				char2 <= char2 + 1;
				if char2 = "1001" then
					char2 <= "0000";
				end if;				
			end if;
		end if;
	end process;

end aplicVGA2_arq;