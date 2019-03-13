------------------------------------------------------------
-- Module: v_cont_33000
-- Description: 33000 binary counter
-- Authors: David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity v_cont_33000 is
	port(
		clk: in std_logic;		-- Clock del sistema
		rst: in std_logic;		-- Reset del sistema
		ena: in std_logic;		-- Enable del sistema
		Q_ENA: out std_logic;	-- Aviso a 8	
		Q_RST: out std_logic;	-- Aviso a 9 = 1001
		Q: out std_logic_vector(15 downto 0)
	);
end v_cont_33000;

architecture v_cont_33000_a of v_cont_33000 is
	
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

signal Di_vec, Qi_vec, ACU_vec: std_logic_vector(15 downto 0); -- Conexiones vectoriales para la implementacion del contador

signal rst_end: std_logic;	-- Conexion de reset al finalizar de contar (9 = 1001)
signal rst_cont: std_logic;	-- Conexion de reset salida del OR

-- signal Q_end: std_logic_vector(3 downto 0);

begin
   
    rst_cont <= rst or rst_end; -- Se resetea por fin de cuenta o por sistema
   
   ffd0: v_ffd
       port map(
          clk => clk,	    -- Clock del v_ffd
          rst => rst_cont,	-- Reset del v_ffd
          ena => ena,    	-- Enable del sistema
          D => Di_vec(0),	  
          Q => Qi_vec(0)
	  );
   Di_vec(0) <= not Qi_vec(0);
   ACU_vec(0) <= Qi_vec(0);
   
   v_cont_bin_base_block: for i in 1 to 15 generate -- Generamos todos los bloques requeridos por el contador
	   v_cont_bin_base_i: v_cont_bin_base
	      port map(
	          clk => clk,
	          rst => rst_cont,
	          ena => ena,
	          D => Di_vec(i),
	          Q => Qi_vec(i),
	          ACU => ACU_vec(i)
	       );
        Di_vec(i) <= ACU_vec(i-1);
	end generate v_cont_bin_base_block;

--	33001		=	  1			      0				     0					      0    					0					0						1				0				0				0			    			0			1				0					1					1			
    rst_end <= Qi_vec(15) and (not Qi_vec(14)) and (not Qi_vec(13)) and (not Qi_vec(12)) and (not Qi_vec(11)) and (not Qi_vec(10)) and (Qi_vec(9)) and (not Qi_vec(8)) and (not Qi_vec(7)) and (not Qi_vec(6)) and (not Qi_vec(5)) and (Qi_vec(4)) and (not Qi_vec(3)) and (Qi_vec(2)) and (not Qi_vec(1)) and (Qi_vec(0));

    Q_RST <= rst_end; -- Aviso fuera del modulo que contamos hasta 9 = 1001

--	33000		=	  1			      0				     0					      0    					0					0						0				0					1				1			1			0					1				0					0					0			
	Q_ENA <= Qi_vec(15) and (not Qi_vec(14)) and (not Qi_vec(13)) and (not Qi_vec(12)) and (not Qi_vec(11)) and (not Qi_vec(10)) and (Qi_vec(9)) and (not Qi_vec(8)) and (not Qi_vec(7)) and (not Qi_vec(6)) and (not Qi_vec(5)) and (Qi_vec(4)) and (not Qi_vec(3)) and (Qi_vec(2)) and (not Qi_vec(1)) and (not Qi_vec(0));
	
-- Salidas para test bench
	Q(15) <= Qi_vec(15);
	Q(14) <= Qi_vec(14);
	Q(13) <= Qi_vec(13);
	Q(12) <= Qi_vec(12);
	Q(11) <= Qi_vec(11);
	Q(10) <= Qi_vec(10);
	Q(9) <= Qi_vec(9);
	Q(8) <= Qi_vec(8);
	Q(7) <= Qi_vec(7);
	Q(6) <= Qi_vec(6);
	Q(5) <= Qi_vec(5);
	Q(4) <= Qi_vec(4);
	Q(3) <= Qi_vec(3);
	Q(2) <= Qi_vec(2);
	Q(1) <= Qi_vec(1);
	Q(0) <= Qi_vec(0);
end;