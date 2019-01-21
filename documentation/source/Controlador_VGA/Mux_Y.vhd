library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
 
entity mux_y is 
      port(
          selection : in  std_logic;    			 --Seleccionador
          in1: in  std_logic_vector (9 downto 0);    --vc-31
          in2: in  std_logic_vector (9 downto 0);    --vc
          output: out std_logic_vector (9 downto 0)  --Salida a pixel_y
          );  
      end ;
   
architecture mux_y_arq of mux_y is
    
    signal sel : std_logic;
    signal sal1, sal2, ent1, ent2, ent3: std_logic_vector (9 downto 0);
  
    
    begin
     
         --Señales asociadas para selection.
             
        sal1  <= (9 downto 0 => sel);
        sal2  <= (9 downto 0 =>(not sel));
          
		 --Asociacion con el vector de entradas.
        
        ent1 <= in1;
        ent2 <= in2;
        ent3 <= ent1 - 31;         
       
       --salida del multiplexor

        output <= (ent3 and sal1) or (ent2 and sal2);
            
        sel <= selection;
     
     
end ;
