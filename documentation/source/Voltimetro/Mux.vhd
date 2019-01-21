library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Mux is 
      port(
          enable : in  std_logic_vector (4 downto 0);    	--Fila donde se mostrará lectura      
          selector : in  std_logic_vector (5 downto 0);   	--Selector
          A0: in  std_logic_vector (3 downto 0);    		--1º digito BCD
          A1: in  std_logic_vector (3 downto 0);    		--Caracter "punto"
          A2: in  std_logic_vector (3 downto 0);    		--2º digito BCD
          A3: in  std_logic_vector (3 downto 0);    		--3º digito BCD
          A4: in  std_logic_vector (3 downto 0);    		--4º digito BCD
          A5: in  std_logic_vector (3 downto 0);    		--Letra "V"
          A6: in  std_logic_vector (3 downto 0);    		--Blank
          Output: out std_logic_vector (3 downto 0)     	--Salida a ROM/VGA
          );  
      end ;
   
architecture Mux_arq  of Mux is
     
    signal unidad, decena, centena, unimil, punto, caracter: std_logic_vector (3 downto 0);
    signal uni, dec, cent, blank, blk,  mil: std_logic_vector (3 downto 0);
    signal punt :std_logic_vector (3 downto 0);
    signal carac:std_logic_vector (3 downto 0);
    signal sel  :std_logic_vector (5 downto 0);
    signal ena   :std_logic;
    
    begin
     
         --Señales asociadas para seleccion
             
        unimil   	<= ( 3 downto 0 =>(sel(5) and (not (sel (4))) and (not (sel(3))) and       sel(2)   and (not (sel(1))) and       sel(0)  and ena));-- cuando entra el 0111 estoy en la col 8
		punto    	<= ( 3 downto 0 =>(sel(5) and (not (sel (4))) and (not (sel(3))) and       sel(2)   and       sel(1)   and (not (sel(0)))and ena));	-- 1000
        centena 	<= ( 3 downto 0 =>(sel(5) and (not (sel (4))) and (not (sel(3))) and       sel(2)   and       sel(1)   and       sel(0)  and ena));	-- 1001
        decena  	<= ( 3 downto 0 =>(sel(5) and (not (sel (4))) and       sel(3)   and (not (sel(2))) and (not (sel(1))) and (not sel(0))  and ena));	-- 1010
		unidad 		<= ( 3 downto 0 =>(sel(5) and (not (sel (4))) and       sel(3)   and (not (sel(2))) and (not (sel(1))) and      sel(0)   and ena));	-- 1011
		caracter 	<= ( 3 downto 0 =>(sel(5) and (not (sel (4))) and       sel(3)   and (not (sel(2))) and       sel(1)   and (not sel(0))  and ena));	-- 1100
       
        blank    <= not(( 3 downto 0 =>(sel(5) and (not (sel (4))) and (not (sel(3))) and       sel(2)   and (not (sel(1))) and       sel(0)  and ena))-- cuando entra el 0111 estoy en la col 8
		
		  or          ( 3 downto 0 =>(sel(5) and (not (sel (4))) and (not (sel(3))) and       sel(2)   and       sel(1)   and (not (sel(0)))and ena))    -- 1000
		  or          ( 3 downto 0 =>(sel(5) and (not (sel (4))) and (not (sel(3))) and       sel(2)   and       sel(1)   and       sel(0)  and ena))    -- 1001
          or          ( 3 downto 0 =>(sel(5) and (not (sel (4))) and       sel(3)   and (not (sel(2))) and (not (sel(1))) and (not sel(0))  and ena))    -- 1010
		  or          ( 3 downto 0 =>(sel(5) and (not (sel (4))) and       sel(3)   and (not (sel(2))) and (not (sel(1))) and      sel(0)   and ena))    -- 1011
		  or          ( 3 downto 0 =>(sel(5) and (not (sel (4))) and       sel(3)   and (not (sel(2))) and       sel(1)   and (not sel(0))  and ena)));  -- 1100
		
		--Salida del mux

        output <= (unidad and uni) or (unimil and mil) or (centena and cent) or (decena and dec) or (punto and punt) or (caracter and carac) or (blank and blk);
        sel     <= selector;
        ena      <= (enable (4) and enable(3) and enable(2) and enable(1) and (not enable(0)));
                
		 --Asociacion con el vector de entradas desde el BCD counter
                  
        mil  <= A0;		
        punt <= A1;		
        cent <= A2;		
        dec  <= A3;		
        uni  <= A4;		
        carac<= A5;		
        blk  <= A6;  
		
       
     
end;