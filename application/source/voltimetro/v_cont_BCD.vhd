------------------------------------------------------------
-- Module: v_cont_BCD
-- Description: BCD Counter with 4 modules
-- Authors: Franco Rota, David Wolovelsky y Joaquin Gonzalez
-- ED1 - UNSAM
-- 2019
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

use work.matrix_type.all;

entity v_cont_BCD is
	port(
		clk: in std_logic;		-- Clock del sistema
		rst: in std_logic;		-- Reset del sistema
        ena: in std_logic;		-- Enable del sistema. Se toma como entrada salida del ADC para habilitar circuito 
        --type matrix is array (4 downto 0) of std_logic_vector(3 downto 0); -- Creacion del tipo matriz 5x4
        Q: out matrix           -- Salida de tipo matrix para digitos de 4 bits cada uno
	);
end v_cont_BCD;

architecture v_cont_BCD_a of v_cont_BCD is

    component v_cont_BCD_base is
        port(
            clk: in std_logic;		-- Clock del sistema
            rst: in std_logic;		-- Reset del sistema
            ena: in std_logic;		-- Enable del sistema
            ACU: out std_logic;		-- Habilito siguiente decada para continuar conteo
            Q: out std_logic_vector(3 downto 0)
        );
    end component;

-- Cables de conexion interna del modulo
signal rst_cont: std_logic;
signal rst_end: std_logic;
signal ENA_vec: std_logic_vector(4 downto 0); 
signal ACU_vec: std_logic_vector(4 downto 0);
signal Qi_aux: std_logic_vector(4 downto 0);

type matrix is array (4 downto 0) of std_logic_vector(3 downto 0); -- Creacion del tipo matriz 5x4
signal Qi_vec: matrix;

rst_cont <= rst or rst_end;

ENA_vec(0) <= ena;
ENA_vec(1) <= ena and ACU_vec(0);
        
cont_block: for i in 0 to 4 generate
  v_cont_BCD_vec: v_cont_BCD
      port map(
          clk => clk,
          rst => rst_cont,
          ena => ENA_vec(i),
          ACU => ACU_vec(i),
          Q => Qi_vec(i)
      );

    condicion: if i>1 generate	    
       ENA_vec(i) <= ena and ENA_vec(i-1) and ACU_vec(i-1);     
    end generate condicion;

