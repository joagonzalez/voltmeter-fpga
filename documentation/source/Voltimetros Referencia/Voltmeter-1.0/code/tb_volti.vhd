--	Testbench para el voltímetro (tb_volti):						--
--	Módulo para testbenchear, lo simulás en modelsim y te tira un   --
--	un archivo C:\Modeltech_6.1e\examples\write.txt o donde tengas  --
--	instalado el modelsim. Cuando tengas al guacho lo cazás y lo	--
--  subís acá: https://ericeastwood.com/lab/vga-simulator/			--
-- 	mandale frula con el submit y te genera los frames que deberían	--
--	verse en un monitor. La única macana es que el vga_ctrl mío no	--
-- 	tiene reset interno, por lo que en la simulación de modelsim 	--
--	vas a tener que buscarlo y mandarle un reset manual.			--
-- 	Artista: Calcagno, Misael Dominique. Legajo: CyT-6322 			--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity tb_volti is

end tb_volti;

architecture tb_volti_a of tb_volti is

component volti is
	port(
		clk: in std_logic;			-- Clock del sistema
		rst_volti: in std_logic;	-- Reset del sistema
		ena_volti: in std_logic;	-- Enable del sistema
		vpositive_i: in std_logic;	-- Entrada de voltaje positivo al sistema
		vnegative_i: out std_logic;	-- Salida de voltaje negativo del sistema
		hs_VGA: out std_logic;		-- Pulso de sincronismo horizontal
     	vs_VGA: out std_logic;		-- Pulso de sincronismo vertical
     	red_VGA: out std_logic;		-- Salida binaria al rojo
     	grn_VGA: out std_logic;		-- Salida binaria al verde
     	blu_VGA: out std_logic		-- Salida binaria al azul
	);
end component;

-- Signal del CLK
signal clk : std_logic := '0';
constant clk_period : time := 20 ns;

-- RST
signal rst_x : std_logic := '1';

-- ENA
signal ena_x : std_logic := '1';

-- Colors & Sinc
signal hs_x, vs_x, r_x, g_x, b_x : std_logic_vector(0 downto 0);
signal hs, vs, r, g, b: integer range 0 to 1;

begin

	clk_process :process
		begin
        	clk <= '0';
        	wait for clk_period/2;  --for 0.5 ns signal is '0'.
        	clk <= '1';
   		   wait for clk_period/2;  --for next 0.5 ns signal is '1'.
	end process;
    
   rst_x <= '0' after 0.5 ms;
	
   volti1: volti
      port map(
         clk => clk,
		   rst_volti => rst_x,
		   ena_volti => ena_x,
		   vpositive_i => '0',
	  	   vnegative_i => open,
		   hs_VGA => hs_x(0),
     	   vs_VGA => vs_x(0),
     	   red_VGA => r_x(0),
     	   grn_VGA => g_x(0),
     	   blu_VGA => b_x(0)
      );

   hs <= to_integer (unsigned(hs_x));
   vs <= to_integer (unsigned(vs_x));
   r  <= to_integer (unsigned(r_x));
   g  <= to_integer (unsigned(g_x));
   b  <= to_integer (unsigned(b_x));   
      
   process (clk)
      file file_pointer: text is out "write.txt";
      variable line_el: line;
   begin

    if rising_edge(clk) then

        -- Write the time
        write(line_el, now); 
        write(line_el, ':');

        -- Write the hsync
        write(line_el, ' ');
        write(line_el, hs); 

        -- Write the vsync
        write(line_el, ' ');
        write(line_el, vs); 

        -- Write the red
        write(line_el, ' ');
        write(line_el, 0); 
        write(line_el, r);
        write(line_el, 0);
        
        -- Write the green
        write(line_el, ' ');
        write(line_el, 0); 
        write(line_el, g); 
        write(line_el, 0); 
        
        -- Write the blue
        write(line_el, ' ');
        write(line_el, 0); 
        write(line_el, b); 

        writeline(file_pointer, line_el);

       end if;
   end process;
end;