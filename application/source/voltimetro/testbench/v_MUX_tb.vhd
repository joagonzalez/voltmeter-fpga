------------------------------------------------------------
-- Module: v_reg_base
-- Description: 5 to 1 multiplexer testebench
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;

use work.matrix_type.all;

entity v_MUX_tb is
end;

architecture v_MUX_tb_a of v_MUX_tb is

    signal D1_tb : std_logic_vector(3 downto 0) := "0011";
    signal punto_tb : std_logic_vector(3 downto 0) := "1111";
    signal D2_tb : std_logic_vector(3 downto 0) := "0001";
    signal D3_tb : std_logic_vector(3 downto 0) := "0010";
    signal V_tb : std_logic_vector(3 downto 0) := "1110";
    signal h_pos_tb : std_logic_vector(9 downto 0) := "0000000000";
    signal v_pos_tb : std_logic_vector(9 downto 0) := "0000000000";

    signal MUX_out_tb : std_logic_vector(3 downto 0);

begin
    h_pos_tb <= "0010000000" after 150 ns, "0100000000" after 250 ns, "0110000000" after 350 ns, "1000000000" after 450 ns;

    block_instance: entity work.v_MUX port map(
            D1 => D1_tb,
            punto => punto_tb,
            D2 => D2_tb,
            D3 => D3_tb,
            V => V_tb,
            h_pos => h_pos_tb,
            v_pos => v_pos_tb,
            MUX_out => MUX_out_tb       
            );

end v_MUX_tb_a ;