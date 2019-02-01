--	Contador BCD (cont_BCD):									--
--	Módulo contador BCD de cuatro bits							--
--	Artista: Calcagno, Misael Dominique. Legajo: CyT-6322 		--

library IEEE;
use IEEE.std_logic_1164.all;

entity cont_BCD is
	port(
		clk: in std_logic;					-- Clock del sistema
		rst: in std_logic;					-- Reset del módulo
		ena: in std_logic;					-- Enable del módulo
		C: out std_logic;    				-- Carry
		Q: out std_logic_vector(3 downto 0)	-- Salida codificada del módulo
	);
end;

architecture cont_BCD_a of cont_BCD is

component ffd
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D: in std_logic;
		Q: out std_logic
	);	
end component;

component c_bu
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		D: in std_logic;
		Q: out std_logic;
		C: out std_logic
	);	
end component;

signal D_x: std_logic_vector(3 downto 0);	-- Cable vectorial de entradas
signal Q_x: std_logic_vector(3 downto 0);	-- Cable vectorial de dígitos
signal C_x: std_logic_vector(3 downto 0);	-- Cable vectorial de carries
signal rst_x: std_logic;					-- Cable auxiliar del Reset
signal rst_end: std_logic;					-- Cable de reset de fin de cuenta

begin
   
   rst_x <= rst or rst_end;	-- Se resetea por fin de cuenta o por sistema
   
   ffd0: ffd
       port map(
          clk => clk,	   -- Clock del módulo
          rst => rst_x,	   -- Reset del módulo
          ena => ena,      -- Enable del sistema
          D => D_x(0),	  
          Q => Q_x(0)
	  );
   D_x(0) <= not Q_x(0);
   C_x(0) <= Q_x(0);
   
   c_bu_block: for i in 1 to 3 generate
	   c_bui: c_bu
	      port map(
	          clk => clk,
	          rst => rst_x,
	          ena => ena,
	          D => D_x(i),
	          Q => Q_x(i),
	          C => C_x(i)
	       );
	   D_x(i) <= C_x(i-1);
	 end generate c_bu_block;

--	1		=		0			1				0			1
	rst_end <= (not Q_x(0)) and Q_x(1) and (not Q_x(2)) and Q_x(3); 

--	1	=	1				0				0			1
	C <= Q_x(0) and (not Q_x(1)) and (not Q_x(2)) and Q_x(3); 

	Q <= Q_x;
   
end;