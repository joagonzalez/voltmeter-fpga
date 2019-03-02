------------------------------------------------------------
-- Module: v_reg
-- Description: Digit register module
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
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
        Q_reg: out matrix
    );
end;

architecture v_reg_a of v_reg is
	
	component v_reg_base is
		port(
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			D_reg: in std_logic_vector(3 downto 0);
			Q_reg: out std_logic_vector(3 downto 0)
		);
	end component;
	
begin
	reg_block: for i in 0 to 4 generate
	reg_vec: v_reg_base
		port map(
			clk => clk,
			rst => rst,
			ena => ena,
			D_reg => D_reg(i),
			Q_reg => Q_reg(i)
		);
	end generate reg_block;
	
end;