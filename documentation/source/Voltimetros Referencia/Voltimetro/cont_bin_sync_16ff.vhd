library IEEE;
use IEEE.std_logic_1164.all;


--                  + - - - - - +
--             ---- | D         | ---- OUT_1
--         EN  ---- |           |
--                  | CONT BIN  | ---- OUT_2
--                  |   16 ff   | 
--         CLK ---- |>          |
--                  + - - - - - +
--                       |
--                       |
--                     RST

--SE DEFINE LA ENTIDAD DEL CONTADOR BINARIO
entity cont_bin_sync_16ff is
  -- SE DEFINE LAS ENTRADAS Y SALIDAS DEL CONTADOR BINARIO
  port(
    -- ENTRADAS: 
    -- EN: ENABLE
    -- CLK: CLOCK
    -- RST: RESET
    EN, CLK, RST : in std_logic;
    -- SALIDAS:
    -- QA: BIT MENOS SIGNIFICATIVO (LSB)
    -- QB
    -- QC
    -- QD: BIT MAS SIGNIFICATIVO (MSB)
    QA, QB, QC, QD : out std_logic;  -- salida de cada flip flop D (OJO CON EL PERENTESIS!!!!!)
    QE, QF, QG, QH : out std_logic; -- salida de cada flip flop D
    QI, QJ, QK, QL: out std_logic;  -- salida de cada flip flop D
    QM, QN, QO, QP: out std_logic;  -- salida de cada flip flop D
    OUT_1 : out std_logic;
    OUT_2 : out std_logic);
--  salida del contador binario de 16FF
end cont_bin_sync_16ff;

architecture cont of cont_bin_sync_16ff is 
  component flip_flop_D is 
    port(
      EN, CLR, CLK, D : in std_logic;
      Q, QN : out std_logic);
  end component;

-- SEÒALES DE ENTRADAS
signal cEN, cRST: std_logic := '0'; -- cambio cCLK por CLK

-- SEÒALES DE SALIDA
signal cQD, cQC, cQB, cQA: std_logic := '0';
signal cQE, cQF, cQG, cQH: std_logic := '0'; 
signal cQI, cQJ, cQK, cQL: std_logic :='0';
signal cQM, cQN, cQO, cQP: std_logic :='0';

-- SEÒALES AUXILIARES
signal cDA, cDB, cDC, cDD : std_logic :='0'; 
signal cDE, cDF, cDG, cDH: std_logic := '0'; 
signal cDI, cDJ, cDK, cDL: std_logic :='0';
signal cDM, cDN, cDO, cDP: std_logic :='0';

begin
  
  cEN <= EN; -- asigno el pin EN del contador binario a la seÒal cEN
  cRST <= RST;

  cDA <= cQA xor '1';
  cDB <= cQB xor ('1' and cQA);
  cDC <= cQC xor ( cQB and ('1' and cQA));
  cDD <= cQD xor ( cQC and ( cQB and ('1' and cQA)));

  cDE <= cQE xor ( cQD and ( cQC and ( cQB and ('1' and cQA))));
  cDF <= cQF xor ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA)))));
  cDG <= cQG xor ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA))))));
  cDH <= cQH xor ( cQG and ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA)))))));
  
  cDI <= cQI xor ( cQH and ( cQG and ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA))))))));
  cDJ <= cQJ xor ( cQI and ( cQH and ( cQG and ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA)))))))));
  cDK <= cQK xor ( cQJ and ( cQI and ( cQH and ( cQG and ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA))))))))));
  cDL <= cQL xor ( cQK and ( cQJ and ( cQI and ( cQH and ( cQG and ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA)))))))))));
  
  cDM <= cQM xor ( cQL and ( cQK and ( cQJ and ( cQI and ( cQH and ( cQG and ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA))))))))))));
  cDN <= cQN xor ( cQM and ( cQL and ( cQK and ( cQJ and ( cQI and ( cQH and ( cQG and ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA)))))))))))));
  cDO <= cQO xor ( cQN and ( cQM and ( cQL and ( cQK and ( cQJ and ( cQI and ( cQH and ( cQG and ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA))))))))))))));
  cDP <= cQP xor ( cQO and ( cQN and ( cQM and ( cQL and ( cQK and ( cQJ and ( cQI and ( cQH and ( cQG and ( cQF and ( cQE and ( cQD and ( cQC and ( cQB and ('1' and cQA)))))))))))))));


  QA <= cQA; -- al pin QA se le asigna la seÒal cQA
  QB <= cQB;
  QC <= cQC;
  QD <= cQD;
  
  QE <= cQE;
  QF <= cQF; 
  QG <= cQG;
  QH <= cQH;
  
  QI <= cQI;
  QJ <= cQJ;
  QK <= cQK; 
  QL <= cQL;
  
  QM <= cQM;
  QN <= cQN;
  QO <= cQO;
  QP <= cQP;

  OUT_1 <= (cQP and not cQO and  not cQN and not cQM and not cQL and not cQK and not cQJ and not cQI and cQH and cQG and cQF and not cQE and cQD and not cQC and not cQB and not cQA);
  OUT_2 <= (cQP and not cQO and  not cQN and not cQM and not cQL and not cQK and not cQJ and not cQI and cQH and cQG and cQF and not cQE and cQD and not cQC and not cQB and cQA);


  FFA: flip_flop_D port map(cEN, cRST, CLK, cDA, cQA );
  FFB: flip_flop_D port map(cEN, cRST, CLK, cDB, cQB );
  FFC: flip_flop_D port map(cEN, cRST, CLK, cDC, cQC );
  FFD: flip_flop_D port map(cEN, cRST, CLK, cDD, cQD );

  FFE: flip_flop_D port map(cEN, cRST, CLK, cDE, cQE );
  FFF: flip_flop_D port map(cEN, cRST, CLK, cDF, cQF );
  FFG: flip_flop_D port map(cEN, cRST, CLK, cDG, cQG );
  FFH: flip_flop_D port map(cEN, cRST, CLK, cDH, cQH );

  FFI: flip_flop_D port map(cEN, cRST, CLK, cDI, cQI );
  FFJ: flip_flop_D port map(cEN, cRST, CLK, cDJ, cQJ );
  FFK: flip_flop_D port map(cEN, cRST, CLK, cDK, cQK );
  FFL: flip_flop_D port map(cEN, cRST, CLK, cDL, cQL );

  FFM: flip_flop_D port map(cEN, cRST, CLK, cDM, cQM );
  FFN: flip_flop_D port map(cEN, cRST, CLK, cDN, cQN );
  FFO: flip_flop_D port map(cEN, cRST, CLK, cDO, cQO );
  FFP: flip_flop_D port map(cEN, cRST, CLK, cDP, cQP );
end;

----Test bench---
library IEEE;
use IEEE.std_logic_1164.all;       

entity test is
end;

architecture test_cont_bin_sync_16ff of test is
  component cont_bin_sync_16ff is
    port(
      EN, CLK, RST : in std_logic;
      QA, QB, QC, QD : out std_logic;   
      QE, QF, QG, QH: out std_logic;
      QI, QJ, QK, QL: out std_logic;
      QM, QN, QO, QP: out std_logic); 
  end component;
  
signal en_t, clk_t, rst_t,       
       qE_t, qF_t, qG_t, qH_t, 
       qI_t, qJ_t, qK_t, qL_t,
       qM_t, qN_t, qO_t, qP_t,
       qA_t, qB_t, qC_t, qD_t : std_logic:='0'; 
  
begin
  en_t  <= '0', '1' after 25 ns;
  rst_t <= '1', '0' after 15 ns;
  clk_t <= not clk_t after 10 ns;
  
  CONTADOR_BIN_16ff: cont_bin_sync_16ff port map(en_t, clk_t, rst_t, 
                                                 qE_t, qF_t, qG_t, qH_t, 
                                                 qI_t, qJ_t, qK_t, qL_t, 
                                                 qM_t, qN_t, qO_t, qP_t,
                                                 qA_t, qB_t, qC_t, qD_t); 
end;
     