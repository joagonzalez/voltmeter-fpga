------------------------------------------------------------
-- Module: Binary Counter 4b Module
-- Description: Basic module of a binary counter that counts up to 4 bits
-- Authors: Franco Rota y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity v_cont_4b is
	port(
		clk: in std_logic;		-- Clock del sistema
		rst: in std_logic;		-- Reset del sistema
		ena: in std_logic;		-- Enable del sistema
		Q_ENA: out std_logic;	-- Aviso a 8	
 		Q_RST: out std_logic	-- Aviso a 9 = 1001
	);
end v_cont_4b;

architecture v_cont_4b_a of v_cont_4b is
	
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

signal Di_vec, Qi_vec, ACU_vec: std_logic_vector(3 downto 0); -- Conexiones vectoriales para la implementacion del contador

signal rst_end: std_logic;	-- Conexion de reset al finalizar de contar (9 = 1001)
signal rst_cont: std_logic;	-- Conexion de reset salida del OR

-- signal Q_end: std_logic_vector(3 downto 0);

begin
   
    rst_cont <= rst or rst_end; -- Se resetea por fin de cuenta o por sistema
   
   ffd0: v_ffd
       port map(
          clk => clk,	-- Clock del v_ffd
          rst => rst_x,	-- Reset del v_ffd
          ena => ena,  	-- Enable del sistema
          D => Di_vec(0),	  
          Q => Qi_vec(0)
	  );
   Di_vec(0) <= not Qi_vec(0);
   ACU_vec(0) <= Qi_vec(0);
   
   v_cont_bin_base_block: for i in 1 to 3 generate -- Generamos todos los bloques requeridos por el contador
	   v_cont_bin_base_i: v_cont_bin_base
	      port map(
	          clk => clk,
	          rst => rst_x,
	          ena => ena,
	          D => Di_vec(i),
	          Q => Qi_vec(i),
	          ACU => ACU_vec(i)
	       );
        Di_vec(i) <= ACU_vec(i-1);
	end generate v_cont_bin_base_block;

--	9		=	  1			      0				     0					1    
    rst_end <= Qi_vec(3) and (not Qi_vec(2)) and (not Qi_vec(1)) and Qi_vec(0);

    Q_RST <= rst_end; -- Aviso fuera del modulo que contamos hasta 9 = 1001

--	8		=	  1			      0				     0					0    
    Q_ENA <= Qi_vec(3) and (not Qi_vec(2)) and (not Qi_vec(1)) and (not Qi_vec(0));
    
end;