library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--                  -------------
--             ---- |D        Q | ---- 
--                  |           |
--                  |   FFD     |
--         EN  ---- |           | 
--         CLK ---- |>        Qn| ----
--                  -------------
--                       |
--                       |
--                      CLR


-- SE DEFINE LA ENTIDAD FLIP-FLOP D
entity flip_flop_D is
--SE DEFINEN LAS ENTRADAS Y SALIDAS DE LA ENTIDAD FLIP-FLOP D
port( 
  -- ENTRADAS:
  -- EN: ENABLE 
  -- CLR: CLEAR
  -- CLK: CLOCK
  -- D: DATA  
  EN, CLR, CLK, D: in std_logic;
  -- SALIDAS:
  -- Q: SALIDA SIN NEGAR
  -- QN: SALIDA NEGADA
  Q, QN: out std_logic
);
end;


-- SE DEFINE EL BEHAVIORAL (compartamiento del flip-flpo D)
architecture beh of flip_flop_D is
begin
  process(CLK, CLR, EN)
  begin
    -- SI CLR = 1 ENTONCES PONGO A 0 LA SALIDA Q Y A 1 SU COMPLEMENTO
    if CLR = '1' then 
      Q <= '0' ;
      QN <= '1';
    -- SI CLR = 0 Y FLANCO ASCENDENTE DE CLOCK Y ENABLE = 1 ENTONCES 
    -- COPIO D A LA SALIDA Q Y SU COMPLEMENTO EN QN
    elsif rising_edge(CLK) and EN = '1' then 
      Q <= D ;
      QN <= not D;
    end if;
  end process;
end beh;

----Test bench---
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- 
entity ff_D is
end ff_D;

architecture test_flip_flop_D of ff_D is
  component flip_flop_D
    port(
      EN, CLR, CLK, D: in std_logic;
      Q, QN : out std_logic
    );
  end component;

  signal cEN : std_logic := '0'; 
  signal cCLR : std_logic := '0';
  signal cCLK : std_logic := '0';
  signal cD : std_logic := '0';
  signal cQ : std_logic := '0';
  signal cQN : std_logic := '0';

begin
    flip_flop: flip_flop_D port map(EN=>cEN, CLR=>cCLR, CLK=>cCLK, D=>cD, Q=>cQ, QN=>cQN);
    cCLR <= not cCLR after 1000 ns; 
    cEN <= not cEN after 500 ns;   
    cCLK <= not cCLK after 10 ns;
    cD <= not cD after 50 ns;
end test_flip_flop_D;
