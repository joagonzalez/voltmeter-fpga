--	Voltímnetro Digital (volti):							--
--	Módulo para convertir un voltaje analógico de 0 a 3.33V	--
--	al mundo digital y su salida a un cable VGA				--
--	Artista: Calcagno, Misael Dominique. Legajo: CyT-6322 	--

library IEEE;
use IEEE.std_logic_1164.all;	
use IEEE.numeric_std.all;

entity volti is
	port(
		clk: in std_logic;			-- Clock del sistema
		rst_volti: in std_logic;	-- Reset del sistema
		ena_volti: in std_logic;	-- Enable del sistema
		vpositive_i: in std_logic;	-- Entrada de voltaje positivo al sistema
		vnegative_i: out std_logic;	-- Salida de voltaje negativo del sistema
		hs_VGA: out std_logic;		-- Pulso de sincronismo horizontal
     	vs_VGA: out std_logic;		-- Pulso de sincronismo vertical
     	red_VGA: out std_logic;		-- Salida binaria al rojo
     	grn_VGA: out std_logic;		-- Salida binaria al verde
     	blu_VGA: out std_logic		-- Salida binaria al azul
	);
end volti;

architecture volti_arch of volti is

component ADC is
	port(
		clk_ADC: in std_logic;		-- Clock del sistema
		rst_ADC: in std_logic;		-- Reset del sistema
		ena_ADC: in std_logic;		-- Enable del sistema
		vpositive: in std_logic;	-- Salida positiva a fuera del sistema
		vnegative: out std_logic;	-- Salida negativa a fuera del sistema
		Q_ADC: out std_logic		-- Salida que codifica el nivel de voltaje en pulsos
	);
end component;

component D2Num is
	port(
		clk: in std_logic;							-- Clock del sistema
		ena: in std_logic;							-- Enable del sistema
		rst: in std_logic;							-- Reset del sistema
		O_ADC: in std_logic; 						-- La salida del ADC entra acá
		D1: out std_logic_vector(3 downto 0);		-- Salida codificada en BCD variable del Dígito más siginificativo
		point: out std_logic_vector(3 downto 0);	-- Salida codificada constante del punto decimal (1010)
		D2: out std_logic_vector(3 downto 0);		-- Salida codificada en BCD variable del segundo Dígito más siginificativo
		D3: out std_logic_vector(3 downto 0);		-- Salida codificada en BCD variable del tercer Dígito más siginificativo
		V: out std_logic_vector(3 downto 0)			-- Salida codificada constante de la "V" (1011)
	 );
end component;

component CGA is
	port(
		char: in std_logic_vector(3 downto 0);		-- Entran los bits que seleccionan el caracter a imprimir
		pixel_x: in std_logic_vector(9 downto 0);	-- Entra la posición horizontal actual en pantalla
		pixel_y: in std_logic_vector(9 downto 0);	-- Entra la posición vertical actual en pantalla 
		Wo: out std_logic							-- Salida binaria de si hay que imprimir o no en pantalla
	);
end component;

component mux is
	port(
		D1: in std_logic_vector(3 downto 0);
		point: in std_logic_vector(3 downto 0);	
		D2: in std_logic_vector(3 downto 0);
		D3: in std_logic_vector(3 downto 0);
		V: in std_logic_vector(3 downto 0);		
		charb: in std_logic_vector(9 downto 0); -- Posición horizontal en pantalla
		mux_o: out std_logic_vector(3 downto 0)	-- Salida con el valor del caracter
	);
end component;

component muxColor is
	port(
		D1_color: in std_logic_vector(3 downto 0);
		R_c: out std_logic;	-- Salida binaria indicativa de color
		G_c: out std_logic;	-- Salida binaria indicativa de color
		B_c: out std_logic	-- Salida binaria indicativa de color
	);
end component;

component vga_ctrl is
	port(
	  clk: in std_logic;	-- Reloj del sistema
   	  red_i: in std_logic;
      grn_i: in std_logic;
      blu_i: in std_logic;
      hs: out std_logic;	-- Sincronismo horizontal
      vs: out std_logic;	-- Sincronismo vertical
      red_o: out std_logic;	-- Salida de color rojo	
      grn_o: out std_logic;	-- Salida de color verde
      blu_o: out std_logic;	-- Salida de color azul
	  pixel_x: out std_logic_vector(9 downto 0);	-- Posición horizontal del pixel en la pantalla
	  pixel_y: out std_logic_vector(9 downto 0)		-- Posición vertical del pixel en la pantalla
	);
end component;

signal clk_aux: std_logic;	-- Cable auxiliar para referir al clock del sistema
signal rst_aux: std_logic;	-- Cable auxiliar para referir al reset del sistema
signal ena_aux: std_logic;	-- Cable auxiliar para referir al enable del sistema
signal vp_aux: std_logic;	-- Cable auxiliar para referir a la entrada de voltaje postivo al sistema
signal vn_aux: std_logic;	-- Cable auxiliar para referir a la salida de voltaje negativo del sistema

signal ADC_2_BCDs: std_logic;	-- Cable auxiliar para conectar la salida del módulo ADC a la entrada del módulo D2Num

signal D1_aux: std_logic_vector(3 downto 0); 	-- Cable auxiliar para la salida del módulo D2Num correspondiente
signal point_aux: std_logic_vector(3 downto 0); -- Cable auxiliar para la salida del módulo D2Num correspondiente
signal D2_aux: std_logic_vector(3 downto 0); 	-- Cable auxiliar para la salida del módulo D2Num correspondiente
signal D3_aux: std_logic_vector(3 downto 0); 	-- Cable auxiliar para la salida del módulo D2Num correspondiente
signal V_aux: std_logic_vector(3 downto 0);		-- Cable auxiliar para la salida del módulo D2Num correspondiente

signal pixel_x_aux: std_logic_vector(9 downto 0); 	-- Cable auxiliar de la posición horizontal del pixel
signal char_aux: std_logic_vector(3 downto 0);		-- Cable auxiliar del caracter seleccionado según la franja actual

signal pixel_y_aux: std_logic_vector(9 downto 0);	-- Cable auxiliar de la posición vertical del pixel

signal W_aux: std_logic;	-- Cable auxiliar de estado binario para determinar la impresión o no en pantalla

signal R_caux: std_logic; -- Cable auxiliar de estado binario para determinar la impresión o no del color rojo
signal G_caux: std_logic; -- Cable auxiliar de estado binario para determinar la impresión o no del color verde
signal B_caux: std_logic; -- Cable auxiliar de estado binario para determinar la impresión o no del color azul

signal cR_aux: std_logic; -- Cable auxiliar de estado binario para determinar la impresión o no en pantalla con o sin el color rojo
signal cG_aux: std_logic; -- Cable auxiliar de estado binario para determinar la impresión o no en pantalla con o sin el color verde
signal cB_aux: std_logic; -- Cable auxiliar de estado binario para determinar la impresión o no en pantalla con o sin el color azul


	attribute loc: string;			-- Localidad del puerto
	attribute iostandard: string;	-- Standard a utilizar

	attribute iostandard of vpositive_i: signal is "LVCMOS33";	
	attribute loc of vpositive_i: signal is "A4";
	attribute iostandard of vnegative_i: signal is "LVCMOS33";	
	attribute loc of vnegative_i: signal is "B4";

	attribute loc of clk: signal is "C9";	-- Localidad del Clock de sistema (50 MHz)
	
	attribute loc of rst_aux: signal is "L14";	-- Localidad del reset de sistema (Switch SW1)
	attribute loc of ena_aux: signal is "L13";	-- Localidad del enable de sistema (Switch SW0)

	attribute loc of hs_VGA: signal is "F15";	-- Localidad del pulso de salida de sistema (Pin HS)
	attribute loc of vs_VGA: signal is "F14";	-- Localidad del pulso de salida de sistema (Pin VS)
	attribute loc of red_VGA: signal is "H14";	-- Localidad del color rojo de salida de sistema (Pin RED)
	attribute loc of grn_VGA: signal is "H15";	-- Localidad del color verde de salida de sistema (Pin GRN)
	attribute loc of blu_VGA: signal is "G15";	-- Localidad del color azul de salida de sistema (Pin BLUE)

begin

	clk_aux <= clk;			-- Conexión del Clock a su referencia en sistema
	rst_aux <= rst_volti;	-- Conexión del reset a su referencia en sistema
	ena_aux <= ena_volti;	-- Conexión del enable a su referencia en sistema
	vp_aux <= vpositive_i;	-- Conexión de la entrada de voltaje positivo a su referencia en sistema
	vnegative_i <= vn_aux;	-- Conexión de la salida de voltaje negativo a su referencia en sistema
	
	ADC1: ADC
		port map(
			clk_ADC => clk_aux,		-- Le entra el clock del sistema
			rst_ADC => rst_aux,		-- Se resetea por sistema
			ena_ADC => ena_aux,		-- Habilitado por sistema
			vpositive => vp_aux,	-- Entrada de voltaje positivo al módulo
			vnegative => vn_aux,	-- Salida de voltaje positivo del módulo
			Q_ADC => ADC_2_BCDs		-- Salida de pulsos digitales del módulo
		);
	D2Num1: D2Num
	   port map(
		   clk => clk_aux,			-- Clock del módulo
		   ena => ena_aux,			-- Enable del sistema
		   rst => rst_aux,			-- Reset del sistema
		   O_ADC => ADC_2_BCDs, 	-- La salida del ADC entra acá
		   D1 => D1_aux,			-- Salida codificada en BCD variable del Dígito más siginificativo
		   point => point_aux, 		-- Salida codificada constante del punto decimal
		   D2 => D2_aux,			-- Salida codificada en BCD variable del segundo Dígito más siginificativo
		   D3 => D3_aux,			-- Salida codificada en BCD variable del tercer Dígito más siginificativo
		   V => V_aux				-- Salida codificada constante de la "V"
	    );
	mux1: mux
		port map(
			D1 => D1_aux,			-- Le entra la salida del dígito más significativo del módulo BCDs
			point => point_aux,		-- Le entra la salida del punto decimal del módulo BCDs
			D2 => D2_aux,			-- Le entra la salida del segundo dígito más significativo del módulo BCDs
			D3 => D3_aux,			-- Le entra la salida del tercer dígito más significativo del módulo BCDs
			V => V_aux,				-- Le entra la salida de la "V" del módulo BCDs
			charb => pixel_x_aux,	-- Le entra la salida de la posición horizontal del pixel del módulo VGActrl 
			mux_o => char_aux		-- Salida codificada del número de caracter seleccionado según su división en pantalla
		);
	CGA1: CGA
		port map(
			char => char_aux,		-- Le entra el caracter seleccionado en el módulo mux
			pixel_x => pixel_x_aux,	-- Le entra la salida de la posición horizontal del pixel del módulo VGActrl 
			pixel_y => pixel_y_aux,	-- Le entra la salida de la posición vertical del pixel del módulo VGActrl
			Wo => W_aux				-- Salida de si debe imprimir en pantalla o no
		);
	muxColor1: muxcolor
		port map(
			D1_color => D1_aux,		-- Le entra la salida del dígito más significativo del módulo BCDs
			R_c => R_caux,			-- Sale si debe imprimir el color rojo o no
			G_c => G_caux,			-- Sale si debe imprimir el color verde o no
			B_c => B_caux			-- Sale si debe imprimir el color azul o no
		);

	cR_aux <= R_caux and W_aux; -- Vale "1" solo cuando haya que imprimir en pantalla y también haya que imprimir el color rojo
	cG_aux <= G_caux and W_aux; -- Vale "1" solo cuando haya que imprimir en pantalla y también haya que imprimir el color verde
	cB_aux <= B_caux and W_aux; -- Vale "1" solo cuando haya que imprimir en pantalla y también haya que imprimir el color azul

	VGActrl1: vga_ctrl
		port map(
				clk => clk_aux,		 -- Le entra el clock del sistema
 	      		red_i => cR_aux,	 -- Le entra si hay que imprimir en pantalla y si el color rojo también
 		       	grn_i => cG_aux,	 -- Le entra si hay que imprimir en pantalla y si el color verde también
    		    blu_i => cB_aux, 	 -- Le entra si hay que imprimir en pantalla y si el color azul también
 		       	hs => hs_VGA,		 -- Salida del pulso de sincronismo horizontal al sistema
  		      	vs => vs_VGA,		 -- Salida del pulso de sincronismo vertical al sistema
   		     	red_o => red_VGA,	 -- Salida binaria al pin rojo
        		grn_o => grn_VGA,	 -- Salida binaria al pin verde
        		blu_o => blu_VGA,	 -- Salida binaria al pin azul
			pixel_x => pixel_x_aux,	 -- Salida de la posición horizontal del pixel
			pixel_y	=> pixel_y_aux	 -- Salida de la posición vertical del pixel
		);
end;