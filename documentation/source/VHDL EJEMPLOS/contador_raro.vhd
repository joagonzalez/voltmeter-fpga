--------------------------------------------------------------------------
-- Modulo: contador_raro
--
-- Descripción: Contador específico de la secuencia 5, 7, 2, 6, 3, con 
--				entrada de habilitación y reset
--
-- Puertos de entrada:
--		clk: reloj
--		rst: reset
--		ena: habilitación
--
-- Puertos de salida:
--		sal: salida de datos (3 bits)
--		flag: indicación de fin de cuenta
--
-- Autor: Nicolás Alvarez
--
-- Fecha: 28/05/14
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity contador_raro is
  port(
    clk: in std_logic;
    rst: in std_logic;    -- resetea la cuenta
    ena: in std_logic;    -- habilita la cuenta
    sal: out std_logic_vector(2 downto 0);
    flag: out std_logic   -- indica que se ha llegado al final de la cuenta
  );
end entity;

architecture contador_raro_arq of contador_raro is
	signal qaux, daux: std_logic_vector(2 downto 0) := "000";
begin
	ffd0: entity work.ffd port map(clk, rst, '0', ena, daux(0), qaux(0));
	ffd1: entity work.ffd port map(clk, rst, '0', ena, daux(1), qaux(1));
	ffd2: entity work.ffd port map(clk, rst, '0', ena, daux(2), qaux(2));

	daux(0) <= not qaux(1) or ((not qaux(0)) and qaux(2)) or (qaux(0) and (not qaux(2)));
	daux(1) <= (not qaux(0)) or (not qaux(1)) or qaux(2);
	daux(2) <= (not qaux(1)) or (not qaux(2));
	
	sal <= qaux;
	flag <= '1' when qaux = "011" else '0';
end;


--------------------------------------------------------------------------
-- Testbench
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity contador_raro_tb is
end;

architecture contador_raro_tb_arq of contador_raro_tb is

	component contador_raro is
		port(
			clk: in std_logic;
			rst: in std_logic;    -- resetea la cuenta
			ena: in std_logic;    -- habilita la cuenta
			sal: out std_logic_vector(2 downto 0);
			flag: out std_logic   -- indica que se ha llegado al final de la cuenta
		);
	end component;

	signal clk: std_logic:= '0';
	signal rst: std_logic:= '1';
	signal ena: std_logic:= '1';
	signal sal: std_logic_vector(2 downto 0);
	signal flag: std_logic:= '0';

begin
	clk <= not clk after 10 ns;
	rst <= '0' after 50 ns;
	dut: contador_raro port map(clk => clk, rst => rst, ena => ena, sal => sal, flag => flag);
end;