library IEEE;
use IEEE.std_logic_1164.all;

--SE DEFINE LA ENTIDAD DEL CONTADOR BINARIO
entity cont_BCD is
  -- SE DEFINE LAS ENTRADAS Y SALIDAS DEL CONTADOR BINARIO
  port(
    -- ENTRADAS: 
    -- EN: ENABLE
    -- CLK: CLOCK
    -- RST: RESET
    EN, CLK, RST : in std_logic;
    --SALIDAS:
    -- QA: BIT MAS SIGNIFICATIVO (MSB)
    -- QB
    -- QC
    -- QD: BIT MENOS SIGNIFICATIVO (LSB)
    -- Co: CARRY OUT
    A, B, C, D, Co: out std_logic);
end cont_BCD;

architecture cont of cont_BCD is 
  component flip_flop_D is 
    port(
      EN, CLR, CLK, D : in std_logic;
      Q : out std_logic);
  end component;

-- SEÒALES DE ENTRADAS
signal cEN, cRST: std_logic := '0'; -- cambie cCLK por CLK y lo saque sino tiraba error
-- SEÒALES DE SALIDA
signal cD, cC, cB, cA, cCo: std_logic := '0';
-- SEÒALES AUXILIARES
signal cDA, cDB, cDC, cDD: std_logic :='0'; -- seÒales que entrarn a cada flip_flop
signal cQA, cQB, cQC, cQD: std_logic :='0'; -- seÒales que salen de cada flip_flop

begin
  
  cEN <= EN; -- asigno el pin EN del contador binario a la seÒal cEN
--solo usar el CLK, lo coneccto a los flip flop
--  cCLK <= CLK; -- asigno el pin CLK del contador binario a la seÒal cCLK
  cRST <= RST; -- asigno el pin RST del contador binario a la seÒal cRST

  D <= cQD; -- asigno la seÒal cQD a el pin de salida D
  C <= cQC; -- asigno la seÒal cQC a el pin de salida C
  B <= cQB; -- asigno la seÒal cQB a el pin de salida B
  A <= cQA; -- asigno la seÒal cQA a el pin de salida A

  cDD <= (not cQA and not cQD) or (not cQB and not cQC and not cQD);
  cDc <= (not cQA and not cQC and cQD) or ( not cQA and cQC and not cQD);
  cDB <= (not cQA and cQB and not cQC) or (not cQA and cQB and not cQD) or ( not cQA and not cQB and cQC and cQD);
  cDA <= (cQA and not cQB and not cQC and not cQD) or ( not cQA and cQB and cQC and cQD);

  cCo <= (cQA and not cQB and not cQC and cQD);
  Co <= cCo;

  

  FFD: flip_flop_D port map(cEN, cRST, CLK, cDD, cQD); -- solo uso CLK, no hace falta asignarle una seÒal,es igual para todos
  FFC: flip_flop_D port map(cEN, cRST, CLK, cDC, cQC);
  FFB: flip_flop_D port map(cEN, cRST, CLK, cDB, cQB);
  FFA: flip_flop_D port map(cEN, cRST, CLK, cDA, cQA);
end; 


----Test bench---
library IEEE;
use IEEE.std_logic_1164.all;       

entity test is
end;

architecture test_cont_BCD of test is
  component cont_BCD is
    port(
      EN, CLK, RST : in std_logic;
      A, B, C, D, Co : out std_logic);
  end component;
  
signal en_t, clk_t, rst_t, A_t, B_t, C_t, D_t, Co_t: std_logic:='0';
  
begin
  en_t  <= '0', '1' after 25 ns;
  rst_t <= '1', '0' after 15 ns;
  clk_t <= not clk_t after 10 ns;
  
  CONTADOR: cont_BCD port map(en_t, clk_t, rst_t, A_t, B_t, C_t, D_t, Co_t);
end;
     
