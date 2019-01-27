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
     