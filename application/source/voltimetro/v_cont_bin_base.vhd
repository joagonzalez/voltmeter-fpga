------------------------------------------------------------
-- Module: Binary Counter Module 
-- Description: Basic module of a binary counter that it is used to implement BCD and 16bits binary counter
-- Authors: Franco Rota y Joaquin Gonzalez
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

signal D_x: std_logic;		-- Cable auxiliar para conectar la entrada del m�dulo
signal D_ff: std_logic;		-- Cable auxiliar para conectar la entrada del flip-flop
signal Q_x: std_logic;		-- Cable auxiliar para conectar la salida del m�dulo

begin
    ffd1: ffd
       port map(
          clk => clk,		-- Clock del sistema
          rst => rst,		-- Reset del m�dulo
          ena => ena,		-- Enable del m�dulo
          D => D_ff,
          Q => Q_x
	  );
    ACU <= D_x and Q_x;
    D_ff <= D_x xor Q_x;
    D_x <= D;
    Q <= Q_x;
end;