library IEEE;
use IEEE.std_logic_1164.all;

use work.matrix_type.all;

entity a2d is
	port(
	clk: in std_logic;
	rst: in std_logic;
	ena: in std_logic;
	entrada: in std_logic;
	D1: out std_logic_vector(3 downto 0);	-- Salida codificada constante del primer digito
	D2: out std_logic_vector(3 downto 0);	-- Salida codificada constante del segundo digito
	D3: out std_logic_vector(3 downto 0);	-- Salida codificada constante del tercer digito
	point: out std_logic_vector(3 downto 0);	-- Salida codificada constante del punto decimal
    V: out std_logic_vector(3 downto 0);			-- Salida codificada constante de la "V"
    Q_33000: out std_logic_vector(15 downto 0);
    bcd: out matrix
);
end;

architecture a2d_a of a2d is

	signal clk_aux: std_logic;
    signal ena_aux: std_logic;
    signal rst_aux: std_logic;

	component v_ADC
        port(
            clk_ADC: in std_logic; 		-- Clock del sistema
            rst_ADC: in std_logic;		-- Reset del sistema
            ena_ADC: in std_logic;		-- Enable del sistema
            D_ADC: in std_logic;		-- Voltaje postivo de entrada al modulo
            Qn_ADC: out std_logic;		-- Voltaje negativo de salida del modulo
            Q_ADC: out std_logic		-- Salida del modulo
        );
    end component;

    --signal D_ADC_aux: std_logic;
    signal Q_ADC_aux: std_logic;
    --signal Qn_ADC_aux: std_logic;
    
    component v_cont_33000
        port(
            clk: in std_logic;		-- Clock del sistema
            rst: in std_logic;		-- Reset del sistema
            ena: in std_logic;		-- Enable del sistema
            Q_ENA: out std_logic;	-- Aviso a 8	
            Q_RST: out std_logic;	-- Aviso a 9 = 1001
            Q: out std_logic_vector(15 downto 0)  --    ¿SACAR?
        );
    end component;

    signal Q_ENA_aux: std_logic;
    signal Q_RST_aux: std_logic;

    component v_cont_BCD
        port(
            clk: in std_logic;		-- Clock del sistema
            rst: in std_logic;		-- Reset del sistema
            ena: in std_logic;		-- Enable del sistema. Se toma como entrada salida del ADC para habilitar circuito 
            Q: out matrix           -- Salida de tipo matrix para digitos de 4 bits cada uno
        );
    end component;

    signal rst_cont: std_logic;
    signal Q_33000_aux: std_logic_vector(15 downto 0);
    signal Q_cont_aux: matrix;

    component v_reg
        port(
            clk: in std_logic;
            rst: in std_logic;
            ena: in std_logic;
            D_reg: in matrix;
            D1: out std_logic_vector(3 downto 0);	-- Salida codificada constante del primer digito
            D2: out std_logic_vector(3 downto 0);	-- Salida codificada constante del segundo digito
            D3: out std_logic_vector(3 downto 0);	-- Salida codificada constante del tercer digito
            point: out std_logic_vector(3 downto 0);	-- Salida codificada constante del punto decimal
            V: out std_logic_vector(3 downto 0)			-- Salida codificada constante de la "V"
        );
    end component;


begin
	
	rst_aux <= rst;
    ena_aux <= ena;
    clk_aux <= clk;
	
	v_ADC_block: v_ADC
        port map(
            clk_ADC => clk_aux,
            rst_ADC => rst_aux,
            ena_ADC => '1',
            D_ADC => entrada,
           -- Qn_ADC => Qn_ADC_aux,
            Q_ADC => Q_ADC_aux
        );
		
	v_cont_33000_block: v_cont_33000
        port map(
            clk => clk_aux,
            rst => rst_aux,
            ena => ena_aux,
            Q_ENA => Q_ENA_aux,
            Q_RST => Q_RST_aux,
            Q => Q_33000_aux
        );
		
	-- Mapeo del reset del contador BCD, se puede utilizar el reset general o cuando el cont_33000 termina.
    rst_cont <= rst_aux or Q_RST_aux;

    v_cont_BCD_block: v_cont_BCD
        port map(
            clk => clk_aux,
            rst => rst_cont,
            ena => Q_ADC_aux,
            Q => Q_cont_aux
        );

    v_reg_block: v_reg
        port map(
            clk => clk_aux,
            rst => rst_aux,
            ena => Q_ENA_aux,
            D_reg => Q_cont_aux,
            D1 => D1,
            D2 => D2,
            D3 => D3,
            point => point,
            V  => V
        );

Q_33000(15) <= Q_33000_aux(15);
Q_33000(14) <= Q_33000_aux(14);
Q_33000(13) <= Q_33000_aux(13);
Q_33000(12) <= Q_33000_aux(12);
Q_33000(11) <= Q_33000_aux(11);
Q_33000(10) <= Q_33000_aux(10);
Q_33000(9) <= Q_33000_aux(9);
Q_33000(8) <= Q_33000_aux(8);
Q_33000(7) <= Q_33000_aux(7);
Q_33000(6) <= Q_33000_aux(6);
Q_33000(5) <= Q_33000_aux(5);
Q_33000(4) <= Q_33000_aux(4);
Q_33000(3) <= Q_33000_aux(3);
Q_33000(2) <= Q_33000_aux(2);
Q_33000(1) <= Q_33000_aux(1);
Q_33000(0) <= Q_33000_aux(0);

bcd(0) <= Q_cont_aux(0);
bcd(1) <= Q_cont_aux(1);
bcd(2) <= Q_cont_aux(2);
bcd(3) <= Q_cont_aux(3);
bcd(4) <= Q_cont_aux(4);
end;
