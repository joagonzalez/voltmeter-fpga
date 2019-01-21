library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.utils.all;


-- Definicion entradas y salidas del voltimetro--
entity volt is
	port(
	   pinD5 : out std_logic;
		pinD6 : in std_logic;
		reset : in std_logic ;
		clk   : in std_logic ;
		hs: out std_logic;		-- sincronismo horizontal
        vs: out std_logic;		-- sincronismo vertical
        red_o: out std_logic;	-- salida de color rojo	
        grn_o: out std_logic;	-- salida de color verde
        blu_o: out std_logic	-- salida de color azul		
      );
    
	attribute LOC: string;
	
	attribute LOC of pinD5: signal is "B4";      --FOXIO9
	attribute LOC of pinD6: signal is "A4";      --FFOXIO10
	attribute LOC of reset: signal is "D18";     --Boton "Bin West"
	attribute LOC of clk: signal is "C9";
	attribute LOC of hs: signal is "F15";
	attribute LOC of vs: signal is "F14";
	attribute LOC of red_o: signal is "H14";
	attribute LOC of grn_o: signal is "H15";
	attribute LOC of blu_o: signal is "G15";

end;

architecture volt_arq of volt is
	signal bcd4_reg: std_logic_vector (15 downto 0);--conecta bcd4 a reg--
	signal ffd_bcd4: std_logic; --ADC con enable BCD4--
	signal nbits_bcd4: std_logic; -- out2 con reset BCD4 (señal que restea contbcd4)--
	signal nbits_reg: std_logic; -- out1 con enable a reg (cuando guarda los datos)--
	signal reg_mux:std_logic_vector (15 downto 0); -- salida de registro con multiplexor--
	signal mux_rom:std_logic_vector (3 downto 0); --salida del multiplexor, entrada del rom--
	signal rom_vga: std_logic; -- salida de rom a entrada vga--
	signal logica_mux_sel:std_logic_vector (5 downto 0);
	signal logica_mux_ena:std_logic_vector (4 downto 0);
	signal logica_rom_col:std_logic_vector (2 downto 0);
	signal logica_rom_row:std_logic_vector (2 downto 0);
	signal pixel_x:std_logic_vector (9 downto 0);
	signal pixel_y:std_logic_vector (9 downto 0);
	signal qaux0, qaux1, qaux2, qaux3:std_logic_vector (3 downto 0);
begin

-- ADC--
ffdNoQ: entity work.ffdNoQ port map(clk, reset, '0', '1', pinD6, ffd_bcd4, pinD5); --(clk, reset, set, enable, Q, not Q)--

--BCD 4 decadas--

BCD4: entity work.cont_BCD4 port map(clk, ffd_bcd4, nbits_bcd4,Q(0)=>qaux0,Q(1)=>qaux1,Q(2)=>qaux2,Q(3)=>qaux3); --(clk, enable, reset, Q)--

--Cont Nbits--

cont_bin: entity work.cont_BIN port map(clk, nbits_reg, nbits_bcd4); --(clk, out1, out2)--

--Registro--

registro: entity work.Registro port map(clk, nbits_reg, bcd4_reg, reg_mux); --(clk, ene, D, Q)--

--Multiplexor--

Mux: entity work.Mux port map(logica_mux_ena, logica_mux_sel,reg_mux(3 downto 0),"1011",reg_mux(7 downto 4),reg_mux(11 downto 8), "1111", "1010", "1111",mux_rom ); --

--Rom--

rom: entity work.Char_ROM port map(mux_rom, logica_rom_row, logica_rom_col, rom_vga); --char_address--

-- Controlador VGA--

vga: entity work.controlador_vga port map(clk, rom_vga, rom_vga, '1', hs, vs, red_o, grn_o, blu_o, pixel_x, pixel_y); 


-- Concateno Arrays

bcd4_reg <= qaux0 & qaux1 & qaux2 & qaux3;

--Logica--

logica_mux_sel   <= pixel_y(8 downto 3);
logica_rom_col   <= pixel_y(2 downto 0);
logica_mux_ena   <= pixel_x(7 downto 3);
logica_rom_row   <= pixel_x(2 downto 0);

end;
