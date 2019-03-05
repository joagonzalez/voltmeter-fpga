------------------------------------------------------------
-- Module: v_MUX
-- Description: 5 to 1 multiplexer
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.matrix_type.all;

entity v_MUX is
    port(
       D1: in std_logic_vector(3 downto 0);			-- Entrada codificada en BCD variable del digito_in mas siginificativo
       punto: in std_logic_vector(3 downto 0);		-- Entrada codificada constante del punto decimal
       D2: in std_logic_vector(3 downto 0);			-- Entrada codificada en BCD variable del segundo digito_in mas siginificativo 
       D3: in std_logic_vector(3 downto 0);			-- Entrada codificada en BCD variable del tercer digito_in mas siginificativo
       V: in std_logic_vector(3 downto 0);			-- Entrada codificada constante del punto decimal
       h_pos: in std_logic_vector(9 downto 0);		-- Posicion horizontal del pixel
       v_pos: in std_logic_vector(9 downto 0);		-- Posicion vertical del pixel
       MUX_out: out std_logic_vector(3 downto 0)	-- Salida seleccionada
    );
end v_MUX;

architecture v_MUX_a of v_MUX is

signal selector: std_logic_vector(4 downto 0);
signal digito_in, digito_out: matrix;

begin

--	1		=		0			0			0					Franja de pantalla 1/5  y fijando franja vertical 001
selector(0) <= (not (h_pos(9) or h_pos(8) or h_pos(7))) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));

--	1		=		0					0			  1			Franja de pantalla 2/5 y fijando franja vertical 001
selector(1) <= ((not h_pos(9)) and (not h_pos(8)) and h_pos(7)) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));

--	1		=		0				1				0			Franja de pantalla 3/5 y fijando franja vertical 001
selector(2) <= ((not h_pos(9)) and h_pos(8) and (not h_pos(7))) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));

--	1		=		0				1			1				Franja de pantalla 4/5 y fijando franja vertical 001
selector(3) <= ((not h_pos(9)) and h_pos(8) and h_pos(7)) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));

--	1		=	1				  0					0			Franja de pantalla 5/5 y fijando franja vertical 001
selector(4) <= (h_pos(9) and (not h_pos(8)) and (not h_pos(7))) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));
	
	digito_in(0) <= D1;
	digito_in(1) <= punto;
	digito_in(2) <= D2;
	digito_in(3) <= D3;
	digito_in(4) <= V;
	
	digito_out_block : for i in 0 to 4 generate
	   digito_out(i) <= (digito_in(i)(3)and selector(i))&(digito_in(i)(2)and selector(i))&(digito_in(i)(1)and selector(i))&(digito_in(i)(0)and selector(i));
	end generate digito_out_block;
	
	MUX_out <= digito_out(4) or digito_out(3) or digito_out(2) or digito_out(1) or digito_out(0);
	
end;