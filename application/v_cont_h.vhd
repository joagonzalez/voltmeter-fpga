------------------------------------------------------------
-- Module: v_cont_h
-- Description: horizontal counter
-- Authors: David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity v_cont_h is
	port(
		clk: in std_logic;		-- Clock del sistema
		ena: in std_logic;		-- Enable del sistema
		Q_ENA: out std_logic;	-- Aviso a 800	
		Q: out std_logic_vector(9 downto 0)
	);
end v_cont_h;

architecture v_cont_h_a of v_cont_h is
	
component v_ffd
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D: in std_logic;
		Q: out std_logic
	);	
end component;

component v_cont_bin_base
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D: in std_logic;
		Q: out std_logic;
		ACU: out std_logic
	);	
end component;

signal Di_vec, Qi_vec, ACU_vec: std_logic_vector(9 downto 0); -- Conexiones vectoriales para la implementacion del contador hasta 800 y 801

signal rst_end: std_logic;	-- Conexion de reset al finalizar de contar 801

-- signal Q_end: std_logic_vector(3 downto 0);

begin
   
   
   ffd0: v_ffd
       port map(
          clk => clk,	    -- Clock del v_ffd
          rst => rst_end,	-- Reset del v_ffd
          ena => ena,    	-- Enable del sistema
          D => Di_vec(0),	  
          Q => Qi_vec(0)
      );
      
   Di_vec(0) <= not Qi_vec(0);
   ACU_vec(0) <= Qi_vec(0);
   
   v_cont_bin_base_block: for i in 1 to 9 generate -- Generamos todos los bloques requeridos por el contador
	   v_cont_bin_base_i: v_cont_bin_base
	      port map(
	          clk => clk,
	          rst => rst_end,
	          ena => ena,
	          D => Di_vec(i),
	          Q => Qi_vec(i),
	          ACU => ACU_vec(i)
	       );
        Di_vec(i) <= ACU_vec(i-1);
	end generate v_cont_bin_base_block;

--	801		=	 ‭1100100001‬ 
    rst_end <= Qi_vec(9) and Qi_vec(8) and (not Qi_vec(7)) and (not Qi_vec(6)) and Qi_vec(5) and (not Qi_vec(4)) and (not Qi_vec(3)) and (not Qi_vec(2))  and (not Qi_vec(1)) and Qi_vec(0);   


--	800		=	 1100100000
	Q_ENA <= Qi_vec(9) and Qi_vec(8) and (not Qi_vec(7)) and (not Qi_vec(6)) and Qi_vec(5) and (not Qi_vec(4)) and (not Qi_vec(3)) and (not Qi_vec(2)) and (not Qi_vec(1)) and (not Qi_vec(0));   

    Q <= Qi_vec;

end;