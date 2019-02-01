library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity cont_BCD_tb is 

end;

architecture cont_BCD_tb_arq of cont_BCD_tb is
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal ena : std_logic := '1';
	signal Q : std_logic_vector (3 downto 0);
	signal hab : std_logic;
begin 
 	clk <= not clk after 10 ns;
	ena <= '1' after 50 ns;
	inst : entity work.cont_BCD port map (clk,ena,rst,hab,Q);
	rst <= '0' after 85 ns;
end;

---------------------

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
     