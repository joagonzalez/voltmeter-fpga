library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity controlador_vga is
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
end;

architecture controlador_vga_arq of controlador_vga is

	constant hpixels: std_logic_vector(9 downto 0) := "1100100000";	-- Número de pixeles en una linea horizontal (800, "1100100000")
	constant vlines: std_logic_vector(9 downto 0) := "1000001001";	-- Número de lineas horizontales en el display (521, "1000001001")
	
	constant hpw: natural := 96; 									-- Ancho del pulso de sincronismo horizontal [pixeles]
	constant hbp: std_logic_vector(9 downto 0):= "0010010000";      -- Back porch horizontal (144, "0010010000")
	constant hfp: std_logic_vector(9 downto 0):= "1100010000";	    -- Front porch horizontal (784, "1100010000")

	constant vpw: natural := 2; 									-- Ancho del pulso de sincronismo vertical [líneas]
	constant vbp: std_logic_vector(9 downto 0):= "0000011111";	 	-- Back porch vertical (31, "0000011111")
	constant vfp: std_logic_vector(9 downto 0):= "0111111111";		-- Front porch vertical (511, "0111111111")
	
	signal hc, vc: std_logic_vector(9 downto 0);					-- Contadores (horizontal y vertical)
	signal clkdiv_flag: std_logic;      							-- Flag para obtener una habilitación cada dos ciclos de clock
	signal vidon: std_logic;										-- Habilita la visualización de datos
	signal vsenable, habcontadorV_vga: std_logic;					-- Habilita el contador vertical
	
begin
    -- Generación de la señal de habilitación para dividir el clock de 50Mhz a la mitad
  
	fft25MHz: entity work.fft port map(clk, '0', '0', '1', '1', clkdiv_flag);
	
    -- Contador para el sincronismo horizontal
   
    contadorH_vga: entity work.contadorH_vga port map(clk, clkdiv_flag, hc, vsenable);
   
    -- Contador para el sincronismo vertical
    
	habcontadorV_vga<= clkdiv_flag and vsenable;    
	contadorV_vga: entity work.contadorV_vga port map(clk, habcontadorV_vga, vc);
	
	-- Generación de señales de sincronismo horizontal y vertical
    hs <= '1' when (hc <= hpw) else '0';
    vs <= '1' when (vc <= vpw) else '0';
	
	-- Ubicación dentro de la pantalla
	
	--Pixel_X
	
	mux_x: entity work.mux_x port map(vidon, hc, hc, pixel_x);
	
	--Pixel_Y
	
	mux_y: entity work.mux_y port map(vidon, vc, vc, pixel_y);
	
	-- Señal de habilitación para la salida de datos por el display
	vidon <= '1' when (((hfp > hc) and (hc > hbp)) and ((vfp > vc) and (vc > vbp))) else '0';
	
    red_o <= '1' when (red_i = '1' and vidon = '1') else '0';			-- Pinta la pantalla del color formado
    grn_o <= '1' when (grn_i = '1' and vidon = '1') else '0';			-- por la combinación de las entradas
    blu_o <= '1' when (blu_i = '1' and vidon = '1') else '0';			-- red_i, grn_i y blu_i (switches)

end;