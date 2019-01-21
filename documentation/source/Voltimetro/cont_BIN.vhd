library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- Definicion entradas y salidas del contador BIN-

entity cont_BIN is
	port(
		clk: in std_logic;
		--Q    : out std_logic_vector(15 downto 0);
		out1, out2: out std_logic
		);   
end;

-- Arquitectura del contador BIN--

architecture cont_BIN_arq of cont_BIN is
	signal qaux, taux: std_logic_vector(15 downto 0);
	signal rst: std_logic;
begin
	fft0: entity work.fft port map(clk, rst, '0', '1', taux(0), qaux(0));
	fft1: entity work.fft port map(clk, rst, '0', '1', taux(1), qaux(1));
	fft2: entity work.fft port map(clk, rst, '0', '1', taux(2), qaux(2));
	fft3: entity work.fft port map(clk, rst, '0', '1', taux(3), qaux(3));
	fft4: entity work.fft port map(clk, rst, '0', '1', taux(4), qaux(4));
	fft5: entity work.fft port map(clk, rst, '0', '1', taux(5), qaux(5));
	fft6: entity work.fft port map(clk,  rst, '0', '1', taux(6), qaux(6));
	fft7: entity work.fft port map(clk,  rst, '0', '1', taux(7), qaux(7));
	fft8: entity work.fft port map(clk,  rst, '0', '1', taux(8), qaux(8));
	fft9: entity work.fft port map(clk,  rst, '0', '1', taux(9), qaux(9));
	fft10: entity work.fft port map(clk, rst, '0', '1', taux(10), qaux(10));
	fft11: entity work.fft port map(clk, rst, '0', '1', taux(11), qaux(11));
	fft12: entity work.fft port map(clk, rst, '0', '1', taux(12), qaux(12));
	fft13: entity work.fft port map(clk, rst, '0', '1', taux(13), qaux(13));
	fft14: entity work.fft port map(clk, rst, '0', '1', taux(14), qaux(14));
	fft15: entity work.fft port map(clk, rst, '0', '1', taux(15), qaux(15));

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
    taux(10)<=taux(9) and qaux(9);
    taux(11)<=taux(10)and qaux(10);
    taux(12)<=taux(11)and qaux(11);
    taux(13)<=taux(12)and qaux(12);
    taux(14)<=taux(13)and qaux(13);
    taux(15)<=taux(14)and qaux(14);
	
	rst <=(qaux(0) and qaux(3) and qaux(5) and qaux(6) and qaux(7) and qaux(15)); -- 33001
    out1 <=(qaux(3) and qaux(5) and qaux(6) and qaux(7) and qaux(15)); 			-- 33000
    out2 <=(qaux(0) and qaux(3) and qaux(5) and qaux(6) and qaux(7) and qaux(15)); -- 33001
	
	--Q<=qaux;
end;
