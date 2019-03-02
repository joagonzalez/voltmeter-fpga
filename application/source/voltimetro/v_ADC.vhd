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
		D_ADC: in std_logic;		-- Voltaje postivo de entrada al modulo
		Qn_ADC: out std_logic;		-- Voltaje negativo de salida del modulo
		Q_ADC: out std_logic		-- Salida del modulo
	);

end v_ADC;

architecture v_ADC_a of v_ADC is

component v_ffd
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D: in std_logic;
		Q: out std_logic;
		Qn: out std_logic
	);
end component;

-- No se definen señales ya que el mapeo de entradas y salidas del modulo ADC y el ffd es directo
begin
	v_ffd0: v_ffd
		port map(
			clk => clk_ADC,
			rst => rst_ADC,
			ena => ena_ADC,
			D => D_ADC,
			Q => Q_ADC,
			Qn => Qn_ADC
		);
end;
