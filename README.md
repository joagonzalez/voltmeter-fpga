## Voltímetro digital con salida VGA

![Figura 1](https://github.com/joagonzalez/voltimetro/blob/develop/documentation/images/voltimetro.png)

### Objetivo:

El objetivo de este trabajo es implementar, en lenguaje descriptor de hardware VHDL, un voltimetro digital conformado por un conversor analógico-digital Sigma-Delta a la entrada para realizar el muestreo y la conversión de la señal a medir. Al la salida del sistema, la medición realizada será enviada al módulo VGA de la placa Spartan-3E. 

Los tres módulos principales del voltímetro se identifican de la siguiente manera:
- Bloque que se encarga de digitalizar el voltaje de entrada que se desea medir
- Bloque controlador VGA que se encarga de producir la señal de sincronismo e indicar en qué posición (horizontal y vertical) de la pantalla se encuentra el barrido en ese momento.
- Bloque que se encarga de encender los píxeles correspondientes a los caracteres que se desea proyectar en la pantalla (ROM)

### Esquema de conexión física

![Figura 2](https://github.com/joagonzalez/voltimetro/blob/develop/documentation/images/Conexion_Spartan.png)


### Especificaciones:
- Fabricante: Xilinx
- Familia: Spartan 3E
- Modelo: XC3S500E
- Encapsulado: FG320
- Speed: -4
- Clock: 50MHz
- Clock VGA: 25MHz (utilizando bloque divisor de frecuencia)

### Base de caracteres ROM:

![Figura 3](https://github.com/joagonzalez/voltimetro/blob/develop/documentation/images/v_CGA.png)

![Figura 4](https://github.com/joagonzalez/voltimetro/blob/develop/documentation/images/sincronismo_VGA.png)

Flag que habilita señal de salida del módulo v_CGA en base a la celda vertical en la que se encuentra el barrido. 

```vhdl
    pos_h <= font_x(6)&font_x(5)&font_x(4); -- Determinacion del pixel horizontal
    pos_v <= font_y(6)&font_y(5)&font_y(4); -- Determinacion del pixel vertical

-- Determinacion del subondice para el caracter seleccionado
    digito <= to_integer(unsigned(char)); 
  
-- Determinacion del subindice para el pixel horizontal
    h <= to_integer(unsigned(pos_h));   
-- Determinacion del subindice para el pixel vertical
    v <= to_integer(unsigned(pos_v));   

    -- Condicion para habilitar salida (001)
    v_cond <= (not font_y(9)) and (not font_y(8)) and font_y(7);
    -- Caracter seleccionado
    char_out <= ROM(digito)(v)(h);

    mux_selector: v_mux_2x1
        port map(
            mux_x => '0',
            mux_y => char_out,
            mux_sel => v_cond,
            mux_out => rom_out
        );
```

### Lógica de selección de caracter con multiplexor 5x1
En base a las señales de barrido horizonal y vertical generamos la mascara binaria selectora del dígito correspondiente

![Figura 5](https://github.com/joagonzalez/voltimetro/blob/develop/documentation/images/v_MUX.png)

A este bloque se le agrega una mejora adicional para poder identificar posicion en base a señal de sincronismo vertical. Esto mismo termina de realizarse en el bloque v_CGA.

```vhdl
--	1		=		000    Franja de pantalla 1/5  y fijando franja vertical 001
selector(0) <= (not (h_pos(9) or h_pos(8) or h_pos(7))) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));

--	1		=		001    Franja de pantalla 2/5 y fijando franja vertical 001
selector(1) <= ((not h_pos(9)) and (not h_pos(8)) and h_pos(7)) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));

--	1		=		010    Franja de pantalla 3/5 y fijando franja vertical 001
selector(2) <= ((not h_pos(9)) and h_pos(8) and (not h_pos(7))) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));

--	1		=		011    Franja de pantalla 4/5 y fijando franja vertical 001
selector(3) <= ((not h_pos(9)) and h_pos(8) and h_pos(7)) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));

--	1		=	    100    Franja de pantalla 5/5 y fijando franja vertical 001
selector(4) <= (h_pos(9) and (not h_pos(8)) and (not h_pos(7))) and ((not v_pos(9)) and (not v_pos(8)) and v_pos(7));
	
	digito_in(0) <= D1;
	digito_in(1) <= punto;
	digito_in(2) <= D2;
	digito_in(3) <= D3;
	digito_in(4) <= V;
	
	digito_out_block : for i in 0 to 4 generate
	   digito_out(i) <= (digito_in(i)(3)and selector(i))&(digito_in(i)(2)and selector(i))&(digito_in(i)(1)and selector(i))&(digito_in(i)(0)and selector(i));
	end generate digito_out_block;
	
	MUX_out <= digito_out(4) or digito_out(3) or digito_out(2) or digito_out(1) or digito_out(0);
```

### Programación de kit Spartan-3E con Xilinx ISE:

https://www.useloom.com/share/d45cef04821c4ec081f3bdbafc6b1c5d


### Material de consulta
- Contador Binario: https://www.youtube.com/watch?v=_o6NkZKH0yg
- Flip-Flop T: https://www.youtube.com/watch?v=wK5qJGI8qBA
- Flip-Flop D: https://www.youtube.com/watch?v=kQ9WICIFWnU
- Multiplexor: https://www.youtube.com/watch?v=oRIKoCm1eA8
- Lista de reproduccion: https://www.youtube.com/watch?v=vsoYlH1_hbc&list=PLWPirh4EWFpHk70zwYoHu87uVsCC8E2S-
- Contador binario 4 bits Flip-Flop D: https://www.vlsifacts.com/circuit-design-4-bit-binary-counter-using-d-flip-flops/
- ADC Sigma-Delta description: https://www.hardwaresecrets.com/how-analog-to-digital-converter-adc-works/9/
- 1 bit DAC converter FFd: https://www.youtube.com/watch?v=DTCtx9eNHXE

### Simulador de circuitos
- https://www.falstad.com/circuit/

### VHDL tutorial plus example
- https://www.seas.upenn.edu/~ese171/vhdl/vhdl_primer.html#Fourbitadder#Fourbitadder
- http://www.srmuniv.ac.in/ramapuram/sites/ramapuram/files/EC308.pdf