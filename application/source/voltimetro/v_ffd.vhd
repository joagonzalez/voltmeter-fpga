------------------------------------------------------------
-- Module: v_ffd
-- Description: Flip-Flop D module
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- Flip-Flop D structure
entity v_ffd is
    port(
        clk, rst, ena: in std_logic;
        D: in std_logic;
        Q: out std_logic
    );
end;

architecture v_ffd_a of v_ffd is
    begin
        -- logical behavior (sequential code execution given by process)
        process(clk, rst) -- sensitivity list, trigger process execution
        begin
            if rst = '1' then
                Q <= '0';
           -- elsif set = '1' then
           --     Q <= '1';
            elsif rising_edge(clk) then
                if ena = '1' then
                    Q <= D;
                end if;
            end if;
        end process;
    end;