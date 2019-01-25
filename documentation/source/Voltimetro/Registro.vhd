library IEEE;
use IEEE.std_logic_1164.all;

--SE DEFINE LA ENTIDAD DEL CONTADOR BINARIO
entity registro is
  -- SE DEFINE LAS ENTRADAS Y SALIDAS DEL CONTADOR BINARIO
  port(
    -- ENTRADAS: 
    -- EN: ENABLE
    -- CLK: CLOCK
    -- RST: RESET
    EN, CLK, RST : in std_logic;
    RA, RB, RC, RD, RE, RF, RG, RH, RI, RJ, RK, RL, RM, RN, RO, RP : in std_logic;
    
    --SALIDAS:
    
    O_RA, O_RB, O_RC, O_RD, O_RE, O_RF, O_RG, O_RH, O_RI, O_RJ, O_RK, O_RL, O_RM, O_RN, O_RO, O_RP : out std_logic); 
 -- O_RH significa OUT_RH  
end registro;

architecture regis of registro is 
  component flip_flop_D is 
    port(
      EN, CLR, CLK, D : in std_logic;
      Q : out std_logic);
  end component;

-- SEÒALES DE ENTRADAS
signal cEN, cCLK, cRST : std_logic := '0';
-- SEÒALES DE SALIDA
signal cD, cC, cB, cA, cCo : std_logic := '0';
-- SEÒALES AUXILIARES
signal cDA, cDB, cDC, cDD, cDE, cDF, cDG, cDH, cDI, cDJ, cDK, cDL,  cDM, cDN, cDO, cDP  : std_logic :='0'; -- seÒales que entrarn a cada flip_flop
signal cQA, cQB, cQC, cQD, cQE, cQF, cQG, cQH, cQI, cQJ, cQK, cQL, cQM, cQN, cQO, cQP : std_logic :='0'; -- seÒales que salen de cada flip_flop


begin

  cEN <= EN; -- asigno el pin EN del registro a la seÒal cEN
  cCLK <= CLK; -- asigno el pin CLK del registro a la seÒal cCLK
  cRST <= RST; -- asigno el pin RST del registro a la seÒal cRST

--ENTRADAS DEL RESGISTRO RA RB RC RD .... RP
  cDA <= RA; -- asigno la seÒal cDA que sale del flip flop D al pin de entrada RA del registro
  cDB <= RB;
  cDC <= RC; 
  cDD <= RD;
 
  cDE <= RE;
  cDF <= RF; 
  cDG <= RG;
  cDH <= RG; 
 
  cDI <= RI;
  cDJ <= RJ;
  cDK <= RK; 
  cDL <= RL;
 
  cDM <= RM; 
  cDN <= RN;
  cDO <= RO;
  cDP <= RP;

--SALIDAS DEL REGISTRO: O_RA... O_RP
-- asigno la seÒal cQ'x' que sale del flip flop D al pin de salida O_R'x' del registro.
 
  O_RA <= cQA; -- asigno la seÒal cQA que sale del flip flop D al pin de salida O_RA del registro
  O_RB <= cQB;
  O_RC <= cQC; 
  O_RD <= cQD;
 
  O_RE <= cQE;
  O_RF <= cQF;
  O_RG <= cQG;
  O_RH <= cQH;
 
  O_RI <= cQI;
  O_RJ <= cQJ;
  O_RK <= cQK;
  O_RL <= cQL;
 
  O_RM <= cQM;
  O_RN <= cQN;
  O_RO <= cQO;
  O_RP <= cQP;


-- port map (en, rst, clk, d, q);
  FFA: flip_flop_D port map(cEN, cRST, cCLK, cDA, cQA);
  FFB: flip_flop_D port map(cEN, cRST, cCLK, cDB, cQB);
  FFC: flip_flop_D port map(cEN, cRST, cCLK, cDC, cQC);
  FFD: flip_flop_D port map(cEN, cRST, cCLK, cDD, cQD);
  
  FFE: flip_flop_D port map(cEN, cRST, cCLK, cDE, cQE); 
  FFF: flip_flop_D port map(cEN, cRST, cCLK, cDF, cQF);
  FFG: flip_flop_D port map(cEN, cRST, cCLK, cDG, cQG);
  FFH: flip_flop_D port map(cEN, cRST, cCLK, cDH, cQH);
  
  FFI: flip_flop_D port map(cEN, cRST, cCLK, cDI, cQI);
  FFJ: flip_flop_D port map(cEN, cRST, cCLK, cDJ, cQJ);
  FFK: flip_flop_D port map(cEN, cRST, cCLK, cDK, cQK);
  FFL: flip_flop_D port map(cEN, cRST, cCLK, cDL, cQL);
  
  FFM: flip_flop_D port map(cEN, cRST, cCLK, cDM, cQM);
  FFN: flip_flop_D port map(cEN, cRST, cCLK, cDN, cQN);
  FFO: flip_flop_D port map(cEN, cRST, cCLK, cDO, cQO);
  FFP: flip_flop_D port map(cEN, cRST, cCLK, cDP, cQP);

end;


----Test bench---
library IEEE;
use IEEE.std_logic_1164.all;       

entity test is
end;

architecture test_registro of test is
  component registro is
    port(
        EN, CLK, RST : in std_logic;
        RA, RB, RC, RD, RE, RF, RG, RH, RI, RJ, RK, RL, RM, RN, RO, RP : in std_logic;
        O_RA, O_RB, O_RC, O_RD, O_RE, O_RF, O_RG, O_RH : out std_logic; 
        O_RI, O_RJ, O_RK, O_RL, O_RM, O_RN, O_RO, O_RP : out std_logic); 
  end component;
 
--seÒal de entrada
signal en_t, clk_t, rst_t, 
       dA_t, dB_t, dC_t, dD_t, dE_t, dF_t, dG_t, dH_t, 
       dI_t, dJ_t, dK_t, dL_t, dM_t, dN_t, dO_t, dP_t : std_logic:='0';

--seÒal de salida
signal qA_t, qB_t, qC_t, qD_t, qE_t, qF_t, qG_t, qH_t, 
       qI_t, qJ_t, qK_t, qL_t, qM_t, qN_t, qO_t, qP_t : std_logic:='0';

begin
   en_t  <= '0', '1' after 25 ns;
   rst_t <= '1', '0' after 15 ns;
   clk_t <= not clk_t after 100 ns;
 
   dA_t <= '0';
   dB_t <= '1', '0' after 150 ns; 
   dC_t <= '0';
   dD_t <= '0';
   
   dE_t <= '0';
   dF_t <= '1',  '0' after 150 ns;
   dG_t <= '0';
   dH_t <= '0';
   
   dI_t <= '0';
   dJ_t <= '0';
   dK_t <= '1', '0' after 150 ns;
   dL_t <= '0';
   
   dM_t <= '0';
   dN_t <= '0';
   dO_t <= '0';
   dP_t <= '0';

   REGISTRO16: registro port map(en_t, clk_t, rst_t, 
                              dA_t, dB_t, dC_t, dD_t, dE_t, dF_t, dG_t, dH_t, 
                              dI_t, dJ_t, dK_t, dL_t, dM_t, dN_t, dO_t, dP_t,
                              qA_t, qB_t, qC_t, qD_t, qE_t, qF_t, qG_t, qH_t, 
                              qI_t, qJ_t, qK_t, qL_t, qM_t, qN_t, qO_t, qP_t); 
end;
     

 