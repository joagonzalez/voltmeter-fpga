--------------------------------------------------------------------------
-- Modulo: VGActrl_tb
-- Descripción: Banco de pruebas para la validación del módulo
--				controlador VGA
-- Autor: Electrónica Digital I
--        Universidad de San Martín - Escuela de Ciencia y Tecnología
--        http://www.mascampus.unsam.edu.ar/course/view.php?id=54512
-- Fecha: 16/04/13
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga_ctrl_tb is
	port (
		clk: in std_logic;		-- reloj del sistema (50 MHz)
        sw2: in std_logic;		-- entrada comandada por uno de los switches del kit
        sw1: in std_logic;		-- entrada comandada por uno de los switches del kit
        sw0: in std_logic;		-- entrada comandada por uno de los switches del kit
        hs: out std_logic;		-- sincronismo horizontal
        vs: out std_logic;		-- sincronismo vertical
        red_o: out std_logic;	-- salida de color rojo	
        grn_o: out std_logic;	-- salida de color verde
        blu_o: out std_logic;	-- salida de color azul
        mov: in std_logic		-- control de movimiento
	);

	-- Mapeo de pines para el kit spartan 3E starter
	attribute loc: string;
	attribute loc of clk: signal is "C9";
	attribute loc of sw2: signal is "H18";		-- Switch SW2
	attribute loc of sw1: signal is "L14";		-- Switch SW1
	attribute loc of sw0: signal is "L13";		-- Switch SW0
	attribute loc of hs: signal is "F15";		-- HS
	attribute loc of vs: signal is "F14";		-- VS
	attribute loc of red_o: signal is "H14";	-- RED
	attribute loc of grn_o: signal is "H15";	-- GRN
	attribute loc of blu_o: signal is "G15";	-- BLUE
	attribute loc of mov: signal is "H13";		-- BTN East

end vga_ctrl_tb;

architecture vga_ctrl_tb_arq of vga_ctrl_tb is

	component vga_ctrl is
		port (
			clk: in std_logic;		-- reloj del sistema (50 MHz)
			red_i: in std_logic;	-- entrada comandada por uno de los switches del kit
			grn_i: in std_logic;	-- entrada comandada por uno de los switches del kit
			blu_i: in std_logic;	-- entrada comandada por uno de los switches del kit
			hs: out std_logic;		-- sincronismo horizontal
			vs: out std_logic;		-- sincronismo vertical
			red_o: out std_logic;	-- salida de color rojo	
			grn_o: out std_logic;	-- salida de color verde
			blu_o: out std_logic;	-- salida de color azul
			pixel_x: out std_logic_vector(9 downto 0);	--	posición horizontal del pixel en la pantalla
			pixel_y: out std_logic_vector(9 downto 0)	--	posición vertical del pixel en la pantalla
		);
	end component;
	
	signal fila, columna: std_logic_vector(9 downto 0);
	signal rojo, verde, azul: std_logic;
	
	signal pos_x: unsigned(9 downto 0);
	
begin

	----------------------------------------------------------------------------------------------
	-- Ejemplos																					--
	--																							--
	-- Los colores están comandados por los switches de entrada del kit							--
	----------------------------------------------------------------------------------------------

	-- Instanciación del componente
	inst: vga_ctrl port map(
						clk => clk,
						red_i => rojo,
						grn_i => verde,
						blu_i => azul,
						hs => hs,
						vs => vs,
						red_o => red_o,
						grn_o => grn_o,
						blu_o => blu_o,
						pixel_x => columna,
						pixel_y => fila
					);
					
	-- Dibuja un rectángulo y dos líneas
--    rojo <= '1' when ((columna(9 downto 4) = std_logic_vector(to_unsigned(19, 6))) and (fila(9 downto 4) = std_logic_vector(to_unsigned(14, 6))) and sw2 = '1') else '0';
   	-- Dibuja una línea verde (valor específico del contador horizontal)
	verde <= '1' when (columna = std_logic_vector(pos_x) and sw1 = '1') else '0';
	-- Dibuja una línea azul (valor específico del contador vertical)
    azul <= '1' when (fila = std_logic_vector(to_unsigned(200, 10)) and sw0 = '1') else '0';


	-- Puntos
	--rojo <= '1' when (unsigned(columna) mod 8 = 0) and (unsigned(fila) mod 8 = 0) and (sw2 = '1') else '0'; 

	-- Grilla
	rojo <= '1' when ((unsigned(columna) mod 16 = 0) or (unsigned(fila) mod 16 = 0)) and (sw2 = '1') else '0'; 
	
	-- Movimiento de una línea
	mover_linea: process(mov)
		variable count: natural := 0;
	begin
		if rising_edge(clk) then
			if count = 40000000 then
				if mov = '1' then
					pos_x <= pos_x + 1;
				end if;
				count := 0;
			else
				count := count + 1;
			end if;
		end if;
	end process;

end vga_ctrl_tb_arq;