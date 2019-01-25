library IEEE;
use IEEE.std_logic_1164.all;

--SE DEFINE LA ENTIDAD DEL CONTADOR BINARIO
entity cont_BCD_4digitos is
  -- SE DEFINE LAS ENTRADAS Y SALIDAS DEL CONTADOR BINARIO
  port(
    -- ENTRADAS: 
    -- EN: ENABLE
    -- CLK: CLOCK
    -- RST: RESET
    EN1, CLK1, RST1 : in std_logic;
    --SALIDAS:
    -- QA: BIT MAS SIGNIFICATIVO (MSB)
    -- QB
    -- QC
    -- QD: BIT MENOS SIGNIFICATIVO (LSB)
    -- Co: CARRY OUT
      Aa, Ba, Ca, Da, Ab, Bb, Cb, Db, Ac, Bc, Cc, Dc, Ad, Bd, Cd, Dd, Co: out std_logic);
end cont_BCD_4digitos;

architecture cont4 of cont_BCD_4digitos is 
  component cont_BCD is 
    port(
      EN, CLK, RST : in std_logic;
      A, B, C, D, Co : out std_logic);
  end component;

-- SEÒALES DE ENTRADAS
signal cEN1, cRST1 : std_logic := '0'; --cambie cCLK1 por CLK1, lo saque sino tira error

-- SEÒALES DE SALIDA
signal cAa, cBa, cCa, cDa, 
       cAb, cBb, cCb, cDb, 
       cAc, cBc, cCc, cDc, 
       cAd, cBd, cCd, cDd : std_logic := '0';

-- SEÒALES AUXILIARES
signal cCoa, cCob, cCoc, cCod : std_logic :='0'; -- seÒales que entran/salen a cada cont_BCD
signal cENb, cEnc, cENd : std_logic := '0';
begin
  
  cEN1 <= EN1; -- asigno el pin EN del contador binario a la seÒal cEN
--  cCLK1 <= CLK1; -- asigno el pin CLK del contador binario a la seÒal cCLK
  cRST1 <= RST1; -- asigno el pin RST del contador binario a la seÒal cRST

  Aa <= cAa; -- SeÒal de salida cAa del cont_bc_A  que se le asigna  al pin Aa
  Ba <= cBa; 
  Ca <= cCa; 
  Da <= cDa; 

  Ab <= cAb;
  Bb <= cBb;
  Cb <= cCb;
  Db <= cDb;

  Ac <= cAc;
  Bc <= cBc;
  Cc <= cCc;
  Dc <= cDc;

  Ad <= cAd;
  Bd <= cBd;
  Cd <= cCd;
  Dd <= cDd;-- SeÒal de salida cDd del cont_bcd_D  q se le asigna  al pin Dd

  cENb <= cCoa;
  cENc <= cCob and cCoa;
  cENd <= cCoc and cCob and cCoa;
  Co <= cCod and cCoc and cCob and cCoa;

 
  cont_BCD_A: cont_BCD port map (cEN1, CLK1, cRST1, cAa, cBa, cCa, cDa, cCoa);
  cont_BCD_B: cont_BCD port map (cENb, CLK1, cRST1, cAb, cBb, cCb, cDb, cCob);
  cont_BCD_C: cont_BCD port map (cENc, CLK1, cRST1, cAc, cBc, cCc, cDc, cCoc);
  cont_BCD_D: cont_BCD port map (cENd, CLK1, cRST1, cAd, cBd, cCd, cDd, cCod);
  
end; 


----Test bench---
library IEEE;
use IEEE.std_logic_1164.all;       

entity test is
end;

architecture test_cont_BCD_4digitos of test is
  component cont_BCD_4digitos is
    port(
      EN1, CLK1, RST1 : in std_logic;
      Aa, Ba, Ca, Da, 
      Ab, Bb, Cb, Db, 
      Ac, Bc, Cc, Dc, 
      Ad, Bd, Cd, Dd, Co : out std_logic);
  end component;
  
signal en1_t, clk1_t, rst1_t,  
       Aa_t, Ba_t, Ca_t, Da_t, 
       Ab_t, Bb_t, Cb_t, Db_t, 
       Ac_t, Bc_t, Cc_t, Dc_t, 
       Ad_t, Bd_t, Cd_t, Dd_t, Co_t : std_logic:='0';
  
     
begin
  en1_t  <= '0', '1' after 25 ns;
  rst1_t <= '1', '0' after 15 ns;
  clk1_t <= not clk1_t after 10 ns;
  
  CONTADOR4: cont_BCD_4digitos port map(en1_t, clk1_t, rst1_t, Aa_t, Ba_t, Ca_t, Da_t, 
        						    Ab_t, Bb_t, Cb_t, Db_t, 
     							    Ac_t, Bc_t, Cc_t, Dc_t, 
  						            Ad_t, Bd_t, Cd_t, Dd_t, Co_t );

end;
     
