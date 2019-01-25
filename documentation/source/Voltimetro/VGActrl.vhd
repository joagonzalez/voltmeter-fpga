--------------------------------------------------------------------------
-- Modulo: VGActrl
-- Descripción: 
-- Autor: Electrónica Digital I
--        Universidad de San Martín - Escuela de Ciencia y Tecnología
--        http://www.mascampus.unsam.edu.ar/course/view.php?id=54512
-- Fecha: 16/04/13
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga_ctrl is
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
end vga_ctrl;

architecture vga_ctrl_arq of vga_ctrl is

	constant hpixels: unsigned(9 downto 0) := to_unsigned(800, 10);	-- Número de pixeles en una linea horizontal (800, "1100100000")
	constant vlines: unsigned(9 downto 0) := to_unsigned(521, 10);	-- Número de lineas horizontales en el display (521, "1000001001")
	
	constant hpw: natural := 96; 									-- Ancho del pulso de sincronismo horizontal [pixeles]
	constant hbp: unsigned(7 downto 0) := to_unsigned(144, 8);		-- Back porch horizontal (144, "0010010000")
	constant hfp: unsigned(9 downto 0) := to_unsigned(784, 10);	 	-- Front porch horizontal (784, "1100010000")

	constant vpw: natural := 2; 									-- Ancho del pulso de sincronismo vertical [líneas]
	constant vbp: unsigned(9 downto 0) := to_unsigned(31, 10);	 	-- Back porch vertical (31, "0000011111")
	constant vfp: unsigned(9 downto 0) := to_unsigned(511, 10);		-- Front porch vertical (511, "0111111111")
	
	signal hc, vc: unsigned(9 downto 0);							-- Contadores (horizontal y vertical)
	signal clkdiv_flag: std_logic;      							-- Flag para obtener una habilitación cada dos ciclos de clock
	signal vidon: std_logic;										-- Habilitar la visualización de datos
	signal vsenable: std_logic;										-- Habilita el contador vertical
	
begin
    -- Generación de la señal de habilitación para dividir el clock de 50Mhz a la mitad
    clkdiv_flag <= not clkdiv_flag when rising_edge(clk);

    -- Contador para el sincronismo horizontal
    process(clk)
    begin
        if rising_edge(clk) then
            if clkdiv_flag = '1' then
                if hc = hpixels then														
                    hc <= (others => '0');	-- El cont horiz se resetea cuando alcanza la cuenta máxima de pixeles
                    vsenable <= '1';		-- Habilitación del cont vert
                else
                    hc <= hc + 1;			-- Incremento del cont horiz
                    vsenable <= '0';		-- El cont vert se mantiene deshabilitado
                end if;
            end if;
        end if;
    end process;

    -- Contador para el sincronismo vertical
    process(clk)
    begin
        if rising_edge(clk) then			 
            if clkdiv_flag = '1' then           -- Flag que habilita la operación una vez cada dos ciclos (25 MHz)
                if vsenable = '1' then          -- Cuando el cont horiz llega al máximo de su cuenta habilita al cont vert
                    if vc = vlines then															 
                        vc <= (others => '0');  -- El cont vert se resetea cuando alcanza la cantidad maxima de lineas
                    else
                        vc <= vc + 1;           -- Incremento del cont vert
                    end if;
                end if;
            end if;
        end if;
    end process;

	-- Generación de señales de sincronismo horizontal y vertical
    hs <= '1' when (hc <= hpw) else '0';
    vs <= '1' when (vc <= vpw) else '0';
	
	-- Ubicación dentro de la pantalla
    pixel_x <= std_logic_vector(hc - hbp) when (vidon = '1') else std_logic_vector(hc);    
    pixel_y <= std_logic_vector(vc - vbp) when (vidon = '1') else std_logic_vector(vc);
      
	-- Señal de habilitación para la salida de datos por el display
	vidon <= '1' when (((hfp > hc) and (hc > hbp)) and ((vfp > vc) and (vc > vbp))) else '0';
	
    red_o <= '1' when (red_i = '1' and vidon = '1') else '0';			-- Pinta la pantalla del color formado
    grn_o <= '1' when (grn_i = '1' and vidon = '1') else '0';			-- por la combinación de las entradas
    blu_o <= '1' when (blu_i = '1' and vidon = '1') else '0';			-- red_i, grn_i y blu_i (switches)

end vga_ctrl_arq;