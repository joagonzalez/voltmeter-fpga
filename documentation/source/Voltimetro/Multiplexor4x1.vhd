library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--                  + - - - - - +
--        IN_0 ---- |           | ---- OUT_MUX
--             ---- |           |
--             ---- |   MUX     |
--       IN_3  ---- |           | 
--                  |           |
--                  + - - - - - +
--                       |
--                       |
--                      SEL



entity multiplexor is 
  port ( 
         EN , CLK, RST : in std_logic;		
	 SEL : in std_logic_vector(1 downto 0); -- entradas de seleccion --
	 
         IN_0: in std_logic_vector (3 downto 0); -- entrada al multiplexor--
         IN_1: in std_logic_vector (3 downto 0); -- entrada al multiplexor--
         IN_2: in std_logic_vector (3 downto 0); -- entrada al multiplexor--
         IN_3: in std_logic_vector (3 downto 0); -- entrada al multiplexor--
	 
         OUT_MUX : out std_logic_vector (3 downto 0)); -- salidas del multiplexor --
end multiplexor ;


architecture behavior of multiplexor is
  begin
    with  SEL select
      OUT_MUX <= IN_0 when "00",
                 IN_1 when "01",
                 IN_2 when "10",
                 IN_3 when others;
end behavior;


----Test bench---
library IEEE;
use IEEE.std_logic_1164.all;       

entity test is
end;

architecture test_multiplexor4 of test is
  component multiplexor is
    port(
        EN, CLK, RST : in std_logic;
        SEL : in std_logic_vector(1 downto 0); -- entradas de seleccion --
	 
        
         IN_0: in std_logic_vector (3 downto 0); -- entrada al multiplexor--
         IN_1: in std_logic_vector (3 downto 0); -- entrada al multiplexor--
         IN_2: in std_logic_vector (3 downto 0); -- entrada al multiplexor--
         IN_3: in std_logic_vector (3 downto 0); -- entrada al multiplexor--
	 
         OUT_MUX : out std_logic_vector (3 downto 0)); -- salidas del multiplexor --
  end component;

-- señal de entrada
signal  en_t, clk_t, rst_t :std_logic := '0';

signal  in_0_t , in_1_t, in_2_t , in_3_t : std_logic_vector (3 downto 0):="0000";

-- señal de salida
signal out_MUX_t : std_logic_vector (3 downto 0):="0000";

-- señal de seleccion
signal sel_t : std_logic_vector (1 downto 0):="00";
 
begin  
  MULTIPLEXOR16: multiplexor port map( en_t, clk_t, rst_t, sel_t, in_0_t , in_1_t, in_2_t , in_3_t, out_MUX_t);

  process

  begin
    en_t  <= '0', '1' after 25 ns;
    rst_t <= '1', '0' after 15 ns;
    clk_t <= not clk_t after 100 ns;
            
    in_0_t <= "0000";
    in_1_t <= "0110";
    in_2_t <= "0101";
    in_3_t <= "1110";

    wait for 200 ns;
    sel_t <= "00";
    wait for 200 ns;
    sel_t <= "01";
    wait for 200 ns;
    sel_t <= "10";
    wait for 200 ns;
    sel_t <= "11";
    wait for 200 ns;

    end process;
end;
