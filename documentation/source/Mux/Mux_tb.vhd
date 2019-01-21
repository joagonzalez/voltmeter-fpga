library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mux_tb is 

end;

architecture mux_tb_arq of mux_tb is

	signal enable : std_logic_vector (4 downto 0);
	signal selector: std_logic_vector (5 downto 0);
   signal A0: std_logic_vector (3 downto 0);    		--1 digito BCD
   signal A1: std_logic_vector (3 downto 0);    		--Caracter "punto"
   signal A2: std_logic_vector (3 downto 0);    		--2 digito BCD
   signal A3: std_logic_vector (3 downto 0);    		--3 digito BCD
   signal A4: std_logic_vector (3 downto 0);    		--4 digito BCD
   signal A5: std_logic_vector (3 downto 0);    		--Letra "V"
   signal A6: std_logic_vector (3 downto 0);    		--Blank
   signal Output: std_logic_vector (3 downto 0); 
   
begin 

	inst : entity work.Mux port map (enable, selector, A0, A1, A2, A3, A4, A5, A6, Output);
	A0 <= "0000"; -- Valores arbitrarios
	A1 <= "0001";
	A2 <= "0010";
	A3 <= "0111";
	A4 <= "1100";
	A5 <= "1101";
	A6 <= "1010";
	enable <= "11110";
	selector <= "101010"; -- 101001 Unidad de mil (A0)
					      -- 100110 Punto (A1)
						  -- 100111 Centena (A2)
	                      -- 101000 Decena (A3)
	                      -- 101001 Unidad (A4)
						  -- 101010 Caracter (A5)
						  -- 000000 Blanck (A6)
end;
