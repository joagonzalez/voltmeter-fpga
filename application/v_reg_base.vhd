------------------------------------------------------------
-- Module: v_reg_base
-- Description: Digit register module
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;

use work.matrix_type.all;

entity v_reg_base is
    port(
        clk: in std_logic;
        rst: in std_logic;
        ena: in std_logic;
        D_reg_base: in std_logic_vector(3 downto 0);
        Q_reg_base: out std_logic_vector(3 downto 0)
    );
end;

architecture v_reg_base_a of v_reg_base is

    component v_ffd is
        port(
            clk, rst, ena: in std_logic;
            D: in std_logic;
            Q: out std_logic
        );
    end component;

begin

    reg_block: for i in 0 to 3 generate
    ffd_vec: v_ffd
        port map(
            clk => clk,
            rst => rst,
            ena => ena,
            D => D_reg_base(i),
            Q => Q_reg_base(i)
        );
    end generate reg_block;

end;
    