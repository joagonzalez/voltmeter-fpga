------------------------------------------------------------
-- Module: v_control_VGA
-- Description: VGA controller
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity v_control_VGA is
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
end entity;

architecture v_control_VGA_a of v_control_VGA is

	constant hpixels: unsigned(9 downto 0) := to_unsigned(800, 10);	-- N�mero de pixeles en una linea horizontal (800, "1100100000")
	constant vlines: unsigned(9 downto 0) := to_unsigned(521, 10);	-- N�mero de lineas horizontales en el display (521, "1000001001")

	constant hpw: natural := 96; 									-- Ancho del pulso de sincronismo horizontal [pixeles]
	constant hbp: unsigned(7 downto 0) := to_unsigned(144, 8);		-- Back porch horizontal (144, "0010010000")
	constant hfp: unsigned(9 downto 0) := to_unsigned(784, 10);	 	-- Front porch horizontal (784, "1100010000")

	constant vpw: natural := 2; 									-- Ancho del pulso de sincronismo vertical [l�neas]
	constant vbp: unsigned(9 downto 0) := to_unsigned(31, 10);	 	-- Back porch vertical (31, "0000011111")
	constant vfp: unsigned(9 downto 0) := to_unsigned(511, 10);		-- Front porch vertical (511, "0111111111")

	signal hc, vc: std_logic_vector(9 downto 0);					-- Contadores (horizontal y vertical)

	signal vidon: std_logic;										-- Habilitar la visualizaci�n de datos

    signal enah, enav: std_logic;

    signal aux_pos_h, aux_pos_v: std_logic_vector(9 downto 0);

    component v_cont_h
        port(
            clk: in std_logic;		-- Clock del sistema
            ena: in std_logic;		-- Enable del sistema
            Q_ENA: out std_logic;	-- Aviso a 800	
            Q: out std_logic_vector(9 downto 0)
        );
    end component;

    component v_cont_v
        port(
            clk: in std_logic;		-- Clock del sistema
            ena: in std_logic;		-- Enable del sistema	
            Q: out std_logic_vector(9 downto 0)
        );
    end component;

    component v_mux_2x1
        port(
            mux_x, mux_y, mux_sel: in std_logic;
            mux_out: out std_logic
        );
    end component;

     
begin

    enah <= '1';
    
    -- Contadores horizontal y vertical.

    cont_h: v_cont_h
        port map(
            clk => clk,
            ena => enah,
            Q_ENA => enav,
            Q => hc
        );

    conv_v: v_cont_v
        port map(
            clk => clk,
            ena => enav,
            Q => vc
        );

    -- Sincronismo horizontal y vertical. Se envian señales a la salida del controlador cuando hs<97 y vs<3

    -- hs <= '1' when (unsigned(hc) <= hpw) else '0';
	hs <= not(hc(9) or hc(8) or hc(7) or (hc(6) and hc(5) and (hc(4) or hc(3) or hc(2) or hc(1) or hc(0))));
	-- vs <= '1' when (unsigned(vc) <= vpw) else '0';
	vs <= not(vc(9) or vc(8) or vc(7) or vc(6) or vc(5) or vc(4) or vc(3) or vc(2) or (vc(1) and vc(0)));

    -- Ubicacion dentro de la pantalla
	-- pos_h <= std_logic_vector(unsigned(hc) - hbp) when (vidon = '1') else hc;
	-- pos_v <= std_logic_vector(unsigned(vc) - vbp) when (vidon = '1') else vc;
	aux_pos_h <= std_logic_vector(unsigned(hc) - hbp);
	aux_pos_v <= std_logic_vector(unsigned(vc) - vbp);

    v_mux_2x1_block: for i in 0 to 9 generate
        
        mux_2x1_pos_h: v_mux_2x1
            port map(
                mux_x => hc(i),
                mux_y => aux_pos_h(i),
                mux_sel => vidon,
                mux_out => pos_h(i)
            );
            
        mux_2x1_pos_v: v_mux_2x1
            port map(
                mux_x => vc(i),
                mux_y => aux_pos_v(i),
                mux_sel => vidon,
                mux_out => pos_v(i)
            );
    end generate;

    -- Senial de habilitacion para la salida de datos por el display
	-- vidon <= '1' when (((hfp > unsigned(hc)) and (unsigned(hc) > hbp)) and ((vfp > unsigned(vc)) and (unsigned(vc) > vbp))) else '0';

	vidon <= ((hc(9) or hc(8) or (hc(7) and (hc(6) or hc(5) or (hc(4) and (hc(3) or hc(2) or hc(1) or hc(0))))))	-- hbp < hc
            and (not hc(9) or not hc(8) or (not hc(7) and not hc(6) and not hc(5) and not hc(4))))					-- hc < hfp
            and
            ((vc(9) or vc(8) or vc(7) or vc(6) or vc(5))	-- vbp < vc
            and (not vc(9) and not (vc(8) and vc(7) and vc(6) and vc(5) and vc(4) and vc(3) and vc(2) and vc(1) and vc(0))));	-- vc < vfp


    -- red_o <= '1' when (red_i = '1' and vidon = '1') else '0';
	red_o <= red_i and vidon;									-- Pinta la pantalla del color formado
	-- grn_o <= '1' when (grn_i = '1' and vidon = '1') else '0';
	grn_o <= grn_i and vidon;									-- por la combinaci�n de las entradas
	-- blu_o <= '1' when (blu_i = '1' and vidon = '1') else '0';
	blu_o <= blu_i and vidon;									-- red_i, grn_i y blu_i (switches)

end architecture;