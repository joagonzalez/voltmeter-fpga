------------------------------------------------------------
-- Module: v_div_frec_tb
-- Description: frecuency divisor testbench
-- Authors: David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity v_div_frec_tb is
end v_div_frec_tb;

architecture v_div_frec_tb_a of v_div_frec_tb is

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '1';
    signal ena_tb : std_logic := '0';
    signal clk_out_tb: std_logic;

begin

    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0' after 10 ns;
    ena_tb <= '1' after 10 ns;

    block_instance : entity work.v_div_frec port map (
        clk => clk_tb,
        clk_out => clk_out_tb,
        rst => rst_tb,
        ena => ena_tb
    );

end v_div_frec_tb_a ; -- v_div_frec_tb_a