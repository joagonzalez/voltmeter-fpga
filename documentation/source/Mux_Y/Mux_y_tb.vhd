library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mux_y_tb is 

end;

architecture mux_y_tb_arq of mux_y_tb is

	signal in1: std_logic_vector (9 downto 0);
	signal in2: std_logic_vector (9 downto 0);
	signal output: std_logic_vector (9 downto 0);    
	signal selection: std_logic;
   
begin 

	inst : entity work.mux_y port map (selection, in1, in2, output);
	selection <= '0';
	in1 <= "1111111111";
	in2 <="1111111111";
	
end;
