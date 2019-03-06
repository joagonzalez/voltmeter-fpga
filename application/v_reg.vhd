------------------------------------------------------------
-- Module: v_reg
-- Description: Digit register module
-- Authors: David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;

use work.matrix_type.all;

entity v_reg is
	port(
		clk: in std_logic;
        rst: in std_logic;
        ena: in std_logic;
		D_reg: in matrix;
		--Q_reg: out matrix;
		D1: out std_logic_vector(3 downto 0);	-- Salida codificada constante del primer digito
		D2: out std_logic_vector(3 downto 0);	-- Salida codificada constante del segundo digito
		D3: out std_logic_vector(3 downto 0);	-- Salida codificada constante del tercer digito
		point: out std_logic_vector(3 downto 0);	-- Salida codificada constante del punto decimal
		V: out std_logic_vector(3 downto 0)			-- Salida codificada constante de la "V"
    );
end;

architecture v_reg_a of v_reg is
	
	component v_reg_base is
		port(
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			D_reg_base: in std_logic_vector(3 downto 0);
			Q_reg_base: out std_logic_vector(3 downto 0)
		);
	end component;
	
	-- A la salida tendremos las coordenadas ROM para los caracteres V y punto decimal
	constant ct_V: std_logic_vector(0 to 3):=('1','0','1','0');		-- Constante "V" codificada
	constant ct_point: std_logic_vector(0 to 3):=('1','0','1','1');	-- Constante punto decimal codificado
	signal   Q_reg_aux: matrix;

begin
	reg_block: for i in 0 to 4 generate
	reg_vec: v_reg_base
		port map(
			clk => clk,
			rst => rst,
			ena => ena,
			D_reg_base => D_reg(i),
			Q_reg_base => Q_reg_aux(i)
		);
	end generate reg_block;
	
	-- Salida de digitos del bloque v_reg
	point <= ct_point;
	V <= ct_V;
	D1 <= Q_reg_aux(4);
	D2 <= Q_reg_aux(3);
	D3 <= Q_reg_aux(2);
end;