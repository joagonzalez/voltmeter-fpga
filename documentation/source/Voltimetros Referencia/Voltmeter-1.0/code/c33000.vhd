-- Contador con aviso en 33001 y 33000 cuentas (c33300):	--
-- 33001 = 0x80E9 = 0b 1000 0000 1110 1001 					--
-- 33000 = 0x80E8 = 0b 1000 0000 1110 1000 					--
-- Artista: Calcagno, Misael Dominique. Legajo: CyT-6322	--

library IEEE;
use IEEE.std_logic_1164.all;

entity c33000 is
	port(
		clk: in std_logic;		-- Clock del sistema
		rst: in std_logic;		-- Reset del sistema
		ena: in std_logic;		-- Enable del sistema
		Q_ENA: out std_logic;	-- Aviso a 33000	
		Q_RST: out std_logic;	-- Aviso a 33001
		Q: out std_logic_vector(15 downto 0)	-- salida
	);
end c33000;

architecture c33000_a of c33000 is
	
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

signal D_i, Q_i, C_i: std_logic_vector(15 downto 0); -- Cables vectoriales para indexaci�n del contador

signal rst_end: std_logic;	-- Cable auxiliar para la l�gica del reset de fin de cuenta
signal rst_x: std_logic;	-- Cable auxiliar de reset

signal Q_x: std_logic_vector(3 downto 0);

begin
   
   rst_x <= rst or rst_end; -- Se resetea por fin de cuenta o por sistema
   
   ffd0: ffd
       port map(
          clk => clk,	-- Clock del m�dulo
          rst => rst_x,	-- Reset del m�dulo
          ena => ena,  	-- Enable del sistema
          D => D_i(0),	  
          Q => Q_i(0)
	  );
   D_i(0) <= not Q_i(0);
   C_i(0) <= Q_i(0);
   
   c_bu_block: for i in 1 to 15 generate
	   c_bui: c_bu
	      port map(
	          clk => clk,
	          rst => rst_x,
	          ena => ena,
	          D => D_i(i),
	          Q => Q_i(i),
	          C => C_i(i)
	       );
	   D_i(i) <= C_i(i-1);
	 end generate c_bu_block;
--	1		=	1					0					0					0	 
	Q_x(3) <= Q_i(15) and (not (Q_i(14))) and (not (Q_i(13))) and (not (Q_i(12)));

--	1		=		  0					  0						0				  0
	Q_x(2) <= (not (Q_i(11))) and (not (Q_i(10))) and (not (Q_i( 9))) and (not (Q_i( 8))); 

--	1		=	1			  1			  1				0
    Q_x(1) <= Q_i( 7) and Q_i( 6) and Q_i( 5) and (not (Q_i( 4)));

--	1		=	1		   1		  1	
    Q_x(0) <= Q_x(3) and Q_x(2) and Q_x(1);

--	1		=	1			1				0					0		  1    
    rst_end <= Q_x(0) and Q_i(3) and (not Q_i(2)) and (not (Q_i(1))) and Q_i(0);

    Q_RST <= rst_end;

--	1		= 1			 1				0					0				0
    Q_ENA <= Q_x(0) and Q_i(3) and (not Q_i(2)) and (not (Q_i(1))) and (not Q_i(0));
	
	Q(15) <= Q_i(15);
	Q(14) <= Q_i(14);
	Q(13) <= Q_i(13);
	Q(12) <= Q_i(12);
	Q(11) <= Q_i(11);
	Q(10) <= Q_i(10);	
	Q(9) <= Q_i(9);
	Q(8) <= Q_i(8);
	Q(7) <= Q_i(7);
	Q(6) <= Q_i(6);
	Q(5) <= Q_i(5);
	Q(4) <= Q_i(4);
	Q(3) <= Q_i(3);
	Q(2) <= Q_i(2);
	Q(1) <= Q_i(1);
	Q(0) <= Q_i(0);

end;