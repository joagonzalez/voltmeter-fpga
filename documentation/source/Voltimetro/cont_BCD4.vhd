library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.utils.all;
-- Definicion entradas y salidas del contador BCD 4 decadas--

entity cont_BCD4 is
	port(
		clk, ena, rst: in std_logic;
		Q: out vector(3 downto 0)
	   );
end;

-- Arquitectura del contador BCD 4 decadas--

architecture cont_BCD4_arq of cont_BCD4 is
	signal habaux ,enaux : std_logic_vector (5 downto 0);
	signal q_aux : vector (4 downto 0);
	
begin
    
	BCD0: entity work.cont_BCD port map(clk, enaux(0), rst, habaux(1), q_aux(0));
	BCD1: entity work.cont_BCD port map(clk, enaux(1), rst, habaux(2), q_aux(1));
	BCD2: entity work.cont_BCD port map(clk, enaux(2), rst, habaux(3), q_aux(2));
	BCD3: entity work.cont_BCD port map(clk, enaux(3), rst, habaux(4), q_aux(3));
	BCD4: entity work.cont_BCD port map(clk, enaux(4), rst, habaux(5), q_aux(4));
	

	enaux(0)<= ena and '1';
	enaux(1)<=habaux(1) and enaux(0);
	enaux(2)<=habaux(2) and enaux(1);
	enaux(3)<=habaux(3) and enaux(2);
	enaux(4)<=habaux(4) and enaux(3);
   enaux(5)<=habaux(5) and enaux(4);
	
	Q(0)<=q_aux(1);
	Q(1)<=q_aux(2);
	Q(2)<=q_aux(3);
	Q(3)<=q_aux(4);
	
	
end;