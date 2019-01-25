library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- Definicion entradas y salidas del contador Vertical VGA-

entity contadorV_vga is
	port(
		clk, ena: in std_logic;
		Q  : out std_logic_vector(9 downto 0)
		);   
end;

-- Arquitectura del contador Vertical VGA---

architecture contadorV_vga_arq of contadorV_vga is
	signal qaux  : std_logic_vector(9 downto 0):="0000000000";
	signal taux: std_logic_vector(9 downto 0):="0000000000";
	signal rst: std_logic;
begin
	fft0: entity work.fft port map(clk, rst, '0', ena, taux(0), qaux(0));
	fft1: entity work.fft port map(clk, rst, '0', ena, taux(1), qaux(1));
	fft2: entity work.fft port map(clk, rst, '0', ena, taux(2), qaux(2));
	fft3: entity work.fft port map(clk, rst, '0', ena, taux(3), qaux(3));
	fft4: entity work.fft port map(clk, rst, '0', ena, taux(4), qaux(4));
	fft5: entity work.fft port map(clk, rst, '0', ena, taux(5), qaux(5));
	fft6: entity work.fft port map(clk, rst, '0', ena, taux(6), qaux(6));
	fft7: entity work.fft port map(clk, rst, '0', ena, taux(7), qaux(7));
	fft8: entity work.fft port map(clk, rst, '0', ena, taux(8), qaux(8));
	fft9: entity work.fft port map(clk, rst, '0', ena, taux(9), qaux(9));
	
	taux(0) <= '1';      
    taux(1) <=qaux(0);
    taux(2) <=taux(1) and qaux(1);
    taux(3) <=taux(2) and qaux(2);
    taux(4) <=taux(3) and qaux(3); 
    taux(5) <=taux(4) and qaux(4);
    taux(6) <=taux(5) and qaux(5);
    taux(7) <=taux(6) and qaux(6); 
    taux(8) <=taux(7) and qaux(7);
    taux(9) <=taux(8) and qaux(8);
    
	rst<=(qaux(9) and (not(qaux(8))) and (not (qaux(7))) and (not(qaux(6))) and (not(qaux(5))) and (not(qaux(4))) and (qaux(3)) and (not(qaux(2))) and (not(qaux(1))) and (qaux(0)));
	Q<=qaux;
	
end;