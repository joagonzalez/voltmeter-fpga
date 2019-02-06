------------------------------------------------------------
-- Module: v_cont_BCD
-- Description: BCD Counter with 4 modules testbench
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;       

type matrix is array (4 downto 0) of std_logic_vector(3 downto 0); -- Creacion del tipo matriz 5x4

entity v_cont_BCD_tb is
end;

architecture v_cont_BCD_tb_a of v_cont_BCD_tb is
    -- Entradas (se inicializan)
    signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '1';
    signal ena_tb : std_logic := '0';
    -- Salidas
    signal Q_tb : matrix;
    signal ACU_tb : std_logic;
	
begin 
 	clk_tb <= not clk_tb after 10 ns;
	ena_tb <= '1' after 100 ns;
	rst_tb <= '0' after 100 ns;

    ena_tb <= '0' after 200 ns;
    ena_tb <= '1' after 250 ns;
    ena_tb <= '0' after 280 ns;

    block_instance : entity work.v_cont_BCD port map (
            clk => clk_tb,
            rst => rst_tb,
            ena => ena_tb,
            Q => Q_tb
        );
end;