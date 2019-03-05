------------------------------------------------------------
-- Module: v_div_frec
-- Description: frecuency divisor
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity v_div_frec is
  port (
    clk: in std_logic;
    clk_out: out std_logic;
    rst: in std_logic;
    ena: in std_logic
  );
end v_div_frec;

architecture v_div_frec_a of v_div_frec is

    signal Q_aux: std_logic;
    signal D_aux: std_logic;

    component v_ffd
        port(
            clk: in std_logic;
            rst: in std_logic;
            ena: in std_logic;
            D: in std_logic;
            Q: out std_logic;
            Qn: out std_logic
        );
    end component;

begin

    D_aux <= not Q_aux;
    clk_out <= Q_aux;

    v_ffd_block: v_ffd
        port map(
            clk => clk,
            rst => rst,
            ena => ena,
            D => D_aux,
            Q => Q_aux
        );
      
end;