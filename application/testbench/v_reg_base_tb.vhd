------------------------------------------------------------
-- Module: v_reg_base
-- Description: Digit register module testbench
-- Authors: David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;

use work.matrix_type.all;

entity v_reg_base_tb is
end;

architecture v_reg_base_tb_a of v_reg_base_tb is

    signal clk_tb: std_logic := '0';
    signal rst_tb: std_logic := '1';
    signal ena_tb: std_logic := '1';

    signal Q_tb : std_logic_vector(3 downto 0);
    signal D_tb : std_logic_vector(3 downto 0) := "0000";

begin
    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0' after 100 ns;
    ena_tb <= '1' after 100 ns, '0' after 200 ns, '1' after 350 ns;
    D_tb <= "1111" after 150 ns, "1010" after 250 ns, "0101" after 350 ns;

    block_instance: entity work.v_reg_base port map(
            clk => clk_tb,
            rst => rst_tb,
            ena => ena_tb,
            Q_reg_base => Q_tb,
            D_reg_base => D_tb
    );
end v_reg_base_tb_a ; -- v_reg_base_tb