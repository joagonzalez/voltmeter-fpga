------------------------------------------------------------
-- Module: v_ACD
-- Description: Analog to Digital Converter
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity v_ADC is
	port(
		clk_ADC: in std_logic; 		-- Clock del sistema
		rst_ADC: in std_logic;		-- Reset del sistema
		ena_ADC: in std_logic;		-- Enable del sistema
		vpositive: in std_logic;	-- Voltaje postivo de entrada al m�dulo
		vnegative: out std_logic;	-- Voltaje negativo de salida del m�dulo
		Q_ADC: out std_logic		-- Salida del m�dulo
	);

end v_ADC;

architecture ADC_arch of ADC is

component ffd
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D: in std_logic;
		Q: out std_logic
	);
end component;

signal Qo: std_logic; 				-- Cable para conectar la salida del
									-- flipflop a las salidas

begin
	ffd_1: ffd
		port map(
			clk => clk_ADC,
			rst => rst_ADC,
			ena => ena_ADC,
			D => vpositive,
			Q => Qo
		);

	vnegative <= not Qo;			-- Conecto la salida negativa
	Q_ADC <= Qo;					-- Conecto la salida positiva del m�dulo

end;
