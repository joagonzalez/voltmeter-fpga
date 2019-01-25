
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- Definicion entradas y salidas del contador BCD--

entity cont_BCD is
	port(
		clk, ena, rst: in std_logic;
		hab: out std_logic;
      Q: out std_logic_vector(3 downto 0)
      );
    
end;

-- Arquitectura del contador BCD--

architecture cont_BCD_arq of cont_BCD is
	signal qaux, daux: std_logic_vector(3 downto 0) := "0000";
begin
	ffd0: entity work.ffd port map(clk, rst , '0' , ena, daux(0), qaux(0));
	ffd1: entity work.ffd port map(clk, rst , '0' , ena, daux(1), qaux(1));
	ffd2: entity work.ffd port map(clk, rst , '0' , ena, daux(2), qaux(2));
	ffd3: entity work.ffd port map(clk, rst , '0' , ena, daux(3), qaux(3));

	daux(3) <= ( qaux(2) and qaux(1) and qaux(0)) or (qaux(3) and (not qaux(0)));
	daux(2) <= ((not qaux(2)) and  qaux(1) and qaux(0)) or (qaux(2) and (not qaux(1))) or (qaux(2) and (not qaux(0))) ;
	daux(1) <= ((not qaux(3)) and (not qaux(1)) and qaux(0)) or (qaux (1) and (not qaux(0)));
	daux(0) <= (not qaux(0));

	Q <= qaux;

	hab<= qaux (0) and qaux(3);
end;
