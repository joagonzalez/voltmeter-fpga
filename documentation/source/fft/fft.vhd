--------------------------------------------------------------------------
-- Flip-flop T
--
-- Descripción: Flip-flop T, diparado con flanco ascendente, con entrada
-- 				de habilitación y set y reset asincrónicos
--
-- Autor:Leandro Carmona.
-- Fecha: 
--------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
 
 
entity fft is
   port( 
		clk, rst, set, ena: in std_logic;
        T : in  std_logic;
		Q : out std_logic
        );
end fft;
 
architecture fft_arq of fft is
   signal q_aux: std_logic:='0';
   signal d_aux: std_logic:='0';

begin
   process (clk, rst) 
   begin
      if rst = '1' then
        q_aux <= '0';
      elsif rising_edge(clk) then
            if ena = '1' then
               q_aux <= d_aux;
            end if;
      end if;
   end process;
   
   d_aux <= q_aux xor T;
   Q <= q_aux;
   
end ;