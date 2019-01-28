library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.utils.all;
-- Definicion entradas y salidas del Registro--

entity registro is
	port(
		clk, ena: in std_logic;
		D: in std_logic_vector(15 downto 0);
		Q: out std_logic_vector(15 downto 0)
      );
    
end;

-- Arquitectura del Registro--

architecture registro_arq of registro is
	signal qaux, daux: std_logic_vector(15 downto 0);
begin
	ffd0: entity work.ffd port map(clk, '0' , '0' , ena, daux(0), qaux(0));
	ffd1: entity work.ffd port map(clk, '0' , '0' , ena, daux(1), qaux(1));
	ffd2: entity work.ffd port map(clk, '0' , '0' , ena, daux(2), qaux(2));
	ffd3: entity work.ffd port map(clk, '0' , '0' , ena, daux(3), qaux(3));
	ffd4: entity work.ffd port map(clk, '0' , '0' , ena, daux(4), qaux(4));
	ffd5: entity work.ffd port map(clk, '0' , '0' , ena, daux(5), qaux(5));
	ffd6: entity work.ffd port map(clk, '0' , '0' , ena, daux(6), qaux(6));
	ffd7: entity work.ffd port map(clk, '0' , '0' , ena, daux(7), qaux(7));
	ffd8: entity work.ffd port map(clk, '0' , '0' , ena, daux(8), qaux(8));
	ffd9: entity work.ffd port map(clk, '0' , '0' , ena, daux(9), qaux(9));
	ffd10: entity work.ffd port map(clk, '0' , '0' , ena, daux(10), qaux(10));
	ffd11: entity work.ffd port map(clk, '0' , '0' , ena, daux(11), qaux(11));
	ffd12: entity work.ffd port map(clk, '0' , '0' , ena, daux(12), qaux(12));
	ffd13: entity work.ffd port map(clk, '0' , '0' , ena, daux(13), qaux(13));
	ffd14: entity work.ffd port map(clk, '0' , '0' , ena, daux(14), qaux(14));
	ffd15: entity work.ffd port map(clk, '0' , '0' , ena, daux(15), qaux(15));
	
	daux<= D;
	Q	<= qaux;

	
end;
