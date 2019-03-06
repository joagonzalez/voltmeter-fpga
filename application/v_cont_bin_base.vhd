------------------------------------------------------------
-- Module: v_cont_bin_base
-- Description: Binary counter base module
-- Authors: David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity v_cont_bin_base is
	port(
		clk: in std_logic;	-- Clock de entrada
		rst: in std_logic;	-- Reset del contador
		ena: in std_logic;	-- Enable del contador
		D: in std_logic;    -- Entrada del contador con realimentacion
		Q: out std_logic;   -- Salida del contador
		ACU: out std_logic    -- Salida acumuladora de estados anteriores
	);
end;

architecture v_cont_bin_base_a of v_cont_bin_base is

component v_ffd
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D: in std_logic;
		Q: out std_logic
	);	
end component;

signal Di: std_logic;		-- Conexion interna entrada modulo y AND
signal Di_ff: std_logic;		-- Conexion interna entre XOR y Flip-Flop
signal Qi: std_logic;		-- Conexion interna salida Flip-Flop y salida del modulo

begin
    ffd: v_ffd
       port map(
          clk => clk,		-- Clock del sistema
          rst => rst,		-- Rest de v_ffd
          ena => ena,		-- Enable del v_ffd
          D => Di_ff,
          Q => Qi
	  );
    ACU <= Di and Qi;
    Di_ff <= Di xor Qi;
    Di <= D;
    Q <= Qi;
end;