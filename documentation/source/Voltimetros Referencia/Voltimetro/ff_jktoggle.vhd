library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--                  + - - - - - +
--         EN  ---- |         Q | ---- 
--             ---- |J          |
--            |     |   FF JK   |
--             ---- |K          | 
--         CLK ---- |>        Qn| ----
--                  + - - - - - +
--                       |
--                       |
--                      CLR
-- NOTA: al unir las entradas de control de un biestable JK, unión que se corresponde a la entrada T.
--T cambia de estado ("toggle" en inglés) cada vez que la entrada de sincronismo o de reloj se dispara mientras la entrada
-- T está a nivel alto. Si la entrada T está a nivel bajo, el biestable retiene el valor anterior.

-- SE DEFINE LA ENTIDAD FLIP-FLOP D
entity flip_flop_JK_T is
port( 
     EN,CLK, CLR, J, K : in std_logic;
     Q, QN: out std_logic);
end;

architecture beh of flip_flop_JK_T is
begin
  process(EN, CLK, CLR, J, K)
  variable TMP: std_logic;
  begin
    if CLR = '1' then
      TMP := '0';     
    elsif rising_edge (CLK) and  EN = '1' then
      if J ='1' and K = '0' then 
        TMP := '1';
      end if;
      if J ='0' and K = '1' then 
        TMP := '0'; 
      end if;
      if J = '1' and K = '1' then
        TMP := not TMP;    
      end if;
    end if;
    
    Q <= TMP;
    QN <= not TMP;

  end process;
end beh;


----Test bench---
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 
entity test is
end;

architecture test_flip_flop_JK_T of test is
  component flip_flop_JK_T
    port(
      EN, CLK, CLR, J, K : in std_logic;
      Q, QN : out std_logic
    );
  end component;

  signal cEN : std_logic := '0'; 
  signal cRST : std_logic := '0';
  signal cCLK : std_logic := '0';
  signal cJ : std_logic := '0';
  signal cK : std_logic := '0';
  signal cQ : std_logic := '0';
  signal cQN : std_logic := '0';

begin
    flip_flop: flip_flop_JK_T port map(EN=>cEN, CLR=>cRST, CLK=>cCLK, J=>cJ, K=>cK, Q=>cQ, QN=>cQN);
    cRST <= not cRST after 1000 ns; 
    cEN <= not cEN after 500 ns;   
    cCLK <= not cCLK after 10 ns;
    cJ <= not cJ after 50 ns;
    cK <= not cK after 75 ns;
  
end test_flip_flop_JK_T;