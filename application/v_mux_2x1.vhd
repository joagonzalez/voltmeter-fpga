------------------------------------------------------------
-- Module: v_mux_2x1
-- Description: 2 to 1 generic multiplexer
-- Authors: David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity v_mux_2x1 is
    port(
        mux_x, mux_y, mux_sel: in std_logic;
        mux_out: out std_logic
    );
end entity;

architecture v_mux_2x1_a of v_mux_2x1 is

begin
    mux_out <=  ((mux_x and (not mux_sel)) or (mux_y and mux_sel));
end architecture;