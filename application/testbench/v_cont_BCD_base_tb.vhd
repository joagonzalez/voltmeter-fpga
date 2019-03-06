------------------------------------------------------------
-- Module: v_cont_BCD__base_tb
-- Description: Binary Counter 4b Module testbench
-- Authors: David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;       

entity v_cont_BCD_base_tb is
end;

architecture v_cont_BCD_base_tb_a of v_cont_BCD_base_tb is

    -- Entradas (se inicializan)
    signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '1';
    signal ena_tb : std_logic := '1';
    -- Salidas
    signal Q_tb : std_logic_vector(3 downto 0);
    signal ACU_tb : std_logic;
	
begin 
 	clk_tb <= not clk_tb after 10 ns;
	ena_tb <= '1' after 100 ns;
	rst_tb <= '0' after 100 ns;

    block_instance : entity work.v_cont_BCD_base port map (
            clk => clk_tb,
            rst => rst_tb,
            ena => ena_tb,
            Q => Q_tb,
            ACU => ACU_tb
        );
end;