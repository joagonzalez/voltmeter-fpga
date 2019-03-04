------------------------------------------------------------
-- Module: Voltimetro
-- Description: Voltimeter implementation
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;       
use work.matrix_type.all;

entity voltimetro is
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
end voltimetro;

architecture voltimetro_a of voltimetro is

    signal clk_aux: std_logic;
    signal ena_aux: std_logic;
    signal rst_aux: std_logic;

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

    


    component v_div_frec
        port(
            clk: in std_logic;
            clk_out: out std_logic;
            rst: in std_logic;
            ena: in std_logic
        );
    end component;

    component v_ADC
        port(
            clk_ADC: in std_logic; 		-- Clock del sistema
            rst_ADC: in std_logic;		-- Reset del sistema
            ena_ADC: in std_logic;		-- Enable del sistema
            D_ADC: in std_logic;		-- Voltaje postivo de entrada al modulo
            Qn_ADC: out std_logic;		-- Voltaje negativo de salida del modulo
            Q_ADC: out std_logic		-- Salida del modulo
        );
    end component;

    signal D_ADC_aux: std_logic;
    signal Q_ADC_aux: std_logic;
    signal Qn_ADC_aux: std_logic;
    
    component v_cont_33000
        port(
            clk: in std_logic;		-- Clock del sistema
            rst: in std_logic;		-- Reset del sistema
            ena: in std_logic;		-- Enable del sistema
            Q_ENA: out std_logic;	-- Aviso a 8	
            Q_RST: out std_logic;	-- Aviso a 9 = 1001
            Q: out std_logic_vector(15 downto 0)  --    ¿SACAR?
        );
    end component;

    signal Q_ENA_aux: std_logic;
    signal Q_RST_aux: std_logic;

    component v_cont_BCD
        port(
            clk: in std_logic;		-- Clock del sistema
            rst: in std_logic;		-- Reset del sistema
            ena: in std_logic;		-- Enable del sistema. Se toma como entrada salida del ADC para habilitar circuito 
            Q: out matrix           -- Salida de tipo matrix para digitos de 4 bits cada uno
        );
    end component;

    signal rst_cont: std_logic;
    signal Q_cont_aux: matrix;

    component v_reg
        port(
            clk: in std_logic;
            rst: in std_logic;
            ena: in std_logic;
            D_reg: in matrix;
            D1: out std_logic_vector(3 downto 0);	-- Salida codificada constante del primer digito
            D2: out std_logic_vector(3 downto 0);	-- Salida codificada constante del segundo digito
            D3: out std_logic_vector(3 downto 0);	-- Salida codificada constante del tercer digito
            point: out std_logic_vector(3 downto 0);	-- Salida codificada constante del punto decimal
            V: out std_logic_vector(3 downto 0)			-- Salida codificada constante de la "V"
        );
    end component;

    signal D1_aux: std_logic_vector(3 downto 0);
    signal D2_aux: std_logic_vector(3 downto 0);
    signal D3_aux: std_logic_vector(3 downto 0);
    signal point_aux: std_logic_vector(3 downto 0);
    signal V_aux: std_logic_vector(3 downto 0);

    component v_MUX
        port(
            D1: in std_logic_vector(3 downto 0);			-- Entrada codificada en BCD variable del digito_in mas siginificativo
            punto: in std_logic_vector(3 downto 0);		-- Entrada codificada constante del punto decimal
            D2: in std_logic_vector(3 downto 0);			-- Entrada codificada en BCD variable del segundo digito_in mas siginificativo 
            D3: in std_logic_vector(3 downto 0);			-- Entrada codificada en BCD variable del tercer digito_in mas siginificativo
            V: in std_logic_vector(3 downto 0);			-- Entrada codificada constante del punto decimal
            h_pos: in std_logic_vector(9 downto 0);		-- Posicion horizontal del pixel 
            MUX_out: out std_logic_vector(3 downto 0)	-- Salida seleccionada
        );
    end component;

    signal MUX_out_aux: std_logic_vector(3 downto 0);

    component v_CGA
        port(
            char: in std_logic_vector(3 downto 0);
            font_x, font_y: in std_logic_vector(9 downto 0);
            rom_out: out std_logic
        );
    end component;

    signal pos_h_aux: std_logic_vector(9 downto 0);
    signal pos_v_aux: std_logic_vector(9 downto 0);
    signal rom_out_aux: std_logic;

    component v_control_VGA
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
            pos_h: out std_logic_vector(9 downto 0);	--	posicion horizontal del pixel en la pantalla
            pos_v: out std_logic_vector(9 downto 0)	--	posicion vertical del pixel en la pantalla
        );
    end component;

    signal red_aux: std_logic;
    signal grn_aux: std_logic;
    signal blu_aux: std_logic;

 
begin

    rst_aux <= rst_volti;
    ena_aux <= ena_volti;
    D_ADC_aux <= vpositive_i;
    vnegative_i <= Qn_ADC_aux;

    v_div_frec_block: v_div_frec
        port map(
            clk => clk,
            clk_out => clk_aux,
            rst => rst_aux,
            ena =>ena_aux
        );

    v_ADC_block: v_ADC
        port map(
            clk_ADC => clk_aux,
            rst_ADC => rst_aux,
            ena_ADC => ena_aux,
            D_ADC => D_ADC_aux,
            Qn_ADC => Qn_ADC_aux,
            Q_ADC => Q_ADC_aux
        );

    v_cont_33000_block: v_cont_33000
        port map(
            clk => clk_aux,
            rst => rst_aux,
            ena => ena_aux,
            Q_ENA => Q_ENA_aux,
            Q_RST => Q_RST_aux
        );

    -- Mapeo del reset del contador BCD, se puede utilizar el reset general o cuando el cont_33000 termina.
    rst_cont <= rst_aux or Q_RST_aux;

    v_cont_BCD_block: v_cont_BCD
        port map(
            clk => clk_aux,
            rst => rst_cont,
            ena => Q_ADC_aux,
            Q => Q_cont_aux
        );

    v_reg_block: v_reg
        port map(
            clk => clk_aux,
            rst => rst_aux,
            ena => Q_ENA_aux,
            D_reg => Q_cont_aux,
            D1 => D1_aux,
            D2 => D2_aux,
            D3 => D3_aux,
            point => point_aux,
            V  => V_aux
        );

    v_MUX_bloc: v_MUX
        port map(
            D1 => D1_aux,
            punto => point_aux,
            D2 => D2_aux,
            D3 => D3_aux,
            V => V_aux,
            h_pos => pos_h_aux,
            MUX_out => MUX_out_aux
        );

    v_CGA_block: v_cga
        port map(
            char => MUX_out_aux,
            font_x => pos_h_aux,
            font_y => pos_v_aux,
            rom_out => rom_out_aux
        );

    -- Seleccion de color
    red_aux <= rom_out_aux and '1';
    grn_aux <= rom_out_aux and '1';
    blu_aux <= rom_out_aux and '1';

    v_control_VGA_block: v_control_VGA
        port map(
            clk => clk_aux,
            red_i => red_aux,
            grn_i => grn_aux,
            blu_i => blu_aux,
            hs => hs_VGA,
            vs => vs_VGA,
            red_o => red_VGA,
            grn_o => grn_VGA,
            blu_o => blu_VGA,
            pos_h => pos_h_aux,
            pos_v => pos_v_aux
        );

end voltimetro_a ;