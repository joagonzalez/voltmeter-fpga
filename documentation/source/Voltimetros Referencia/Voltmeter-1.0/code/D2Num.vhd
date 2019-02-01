--	Conversor digital a numérico BCD (D2Num):				--
--	Módulo para pasar de pulsos digitales a tres digitos	--
--	decimales codificados en BCD							--
--	Artista: Calcagno, Misael Dominique. Legajo: CyT-6322 	--

library IEEE;
use IEEE.std_logic_1164.all;

entity D2Num is
	port(
		clk: in std_logic;							-- Clock del módulo
		ena: in std_logic;							-- Enable del sistema
		rst: in std_logic;							-- Reset del sistema
		O_ADC: in std_logic; 						-- La salida del ADC entra acá
		D1: out std_logic_vector(3 downto 0);		-- Salida codificada en BCD variable del Dígito más siginificativo
		point: out std_logic_vector(3 downto 0);	-- Salida codificada constante del punto decimal
		D2: out std_logic_vector(3 downto 0);		-- Salida codificada en BCD variable del segundo Dígito más siginificativo
		D3: out std_logic_vector(3 downto 0);		-- Salida codificada en BCD variable del tercer Dígito más siginificativo
		V: out std_logic_vector(3 downto 0)			-- Salida codificada constante de la "V"
	 );
end;

architecture D2Num_a of D2Num is

component cont_BCD
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		C: out std_logic;
		Q: out std_logic_vector(3 downto 0)
	);	
end component;

component c33000
    port(
		clk: in std_logic;	-- Clock del sistema
		rst: in std_logic;	-- Reset del sistema
		ena: in std_logic;	-- Enable del sistema
		Q_ENA: out std_logic;		
 		Q_RST: out std_logic	
    );
end component;

component REG4
	port(
		clk: in std_logic;	-- Clock del módulo
		ena: in std_logic;	-- Enable del sistema
		rst: in std_logic;	-- Reset del sistema
		D_REG4: in std_logic_vector(3 downto 0);	-- Entrada vectorial al módulo
		Q_REG4: out std_logic_vector(3 downto 0)	-- Salida vectorial del módulo
	);
end component;

signal Q_ENA, Q_RST, rst_x: std_logic;
signal ena_i: std_logic_vector(4 downto 0); 
signal C_i: std_logic_vector(4 downto 0);

type matrix is array (4 downto 0) of std_logic_vector(3 downto 0); -- Creación del tipo matriz 5x4
signal Qm, Chm: matrix;

constant ct_V: std_logic_vector(0 to 3):=('1','0','1','1');		-- Constante "V" codificada
constant ct_point: std_logic_vector(0 to 3):=('1','0','1','0');	-- Constante punto decimal codificado

begin
    
   c33000_1: c33000
      port map(
      	  clk => clk,
		  ena => ena,
		  rst => rst,
		  Q_ENA => Q_ENA,
		  Q_RST => Q_RST
	);
	
	rst_x <= rst or Q_RST;
	
	ena_i(0) <= O_ADC;
	ena_i(1) <= O_ADC and C_i(0);
			
   cont_block: for i in 0 to 4 generate
      cont_BCD_i: cont_BCD
	      port map(
		      clk => clk,
		      rst => rst_x,
		      ena => ena_i(i),
	         C => C_i(i),
            Q => Qm(i)
	      );
	    chufa1: if i>1 generate	    
	       ena_i(i) <= O_ADC and ena_i(i-1) and C_i(i-1);
	       REG4_i: REG4
	          port map(
		         clk => clk,
	            ena => Q_ENA,
	           	rst => rst,
	            D_REG4 => Qm(i),
	            Q_REG4 => Chm(i)
	        );     
	    end generate chufa1;
	    
    end generate cont_block;
	 Chm(0) <= ct_V;
	 Chm(1) <= ct_point;
	 
	 D1 <= Chm(4);
	 point <= Chm(1);
	 D2 <= Chm(3);
	 D3 <= Chm(2);
	 V <= Chm(0);
end;