Proyecto Final Electrónica Digital 1 - UNSAM
============================================

## Voltímetro digital con salida VGA

### Objetivo:

El objetivo del presente Trabajo Práctico consiste en especificar, diseñar, describir una
arquitectura, simular, sintetizar e implementar en FPGA un sistema digital para un voltímetro
digital con salida VGA. 

### Especificaciones:

Implementar en lenguaje descriptor de hardware VHDL un voltímetro conformado por
un conversor A/D Sigma-Delta con salida VGA.

-  Sintetizar con la herramienta ISE la descripción de hardware para la FPGA:
    - Fabricante: Xilinx
    - Familia: Spartan 3E
    - Modelo: XC3S500E
    - Encapsulado: FG320
    - Speed: -4
- Implementar la descripción en el kit de desarrollo Spartan-3E Starter Board de la
empresa Digilent.
    - Generar un informe (no más de 10 hojas, sin contar el código) que incluya:
    - Diagrama en bloques, entradas y salidas de cada bloque.
    - Simulaciones (incluyendo algunas capturas de pantalla).
    - Tabla de resumen de síntesis, detallando slices, Flip-Flops y LUTs utilizadas (con
    indicación de porcentajes de utilización del dispositivo).
    - Código fuente VHDL. 

### Desarrollo:

El diagrama en bloques de la arquitectura propuesta se puede observar en la Figura 1. La idea de este trabajo es implementar un conversor A/D Sigma-Delta utilizando uno de los flip-flops presentes en los bloques lógicos de la FPGA, seguido de un contador que dará cuenta de la cantidad de unos a la salida del dicho flip-flop, en un determinado tiempo (cantidad dada de ciclos de reloj).
El valor obtenido se mostrará en un monitor a través de la interfaz VGA
existente en el kit de desarrollo. 

![Figura 1](https://github.com/joagonzalez/unsam_digitales_1/blob/master/documentation/images/diagrama_bloques_arquitectura_voltimetro.png)

![Figura 2](https://github.com/joagonzalez/unsam_digitales_1/blob/master/documentation/images/diagrama_procesamiento_control.png)

Los componentes básicos de la arquitectura son:
- Flip-Flop: Se utilizará un flip-flop de uno de los bloques lógicos de la FPGA (la
implementación en VHDL se deberá realizar por comportamiento)
- Bloque de procesamiento de datos y control: este bloque es el encargado de procesar los datos obtenidos de la salida Q del flip-flop D de entrada (la implementación en VHDL se deberá realizar de manera estructural). Estará conformado por un contador por décadas, un contador binario, un registro, una ROM de caracteres (para almacenar los caracteres ‘0’, …, ‘9’, ‘.’, ‘V’ y ‘ ’), un controlador de VGA y un bloque de lógica encargado del control general. 

### Entregables: 

- Código VHDL
- Informe conteniendo:
- Breve explicación de lo desarrollado en el trabajo
- Diagrama en bloques (detallando entradas y salidas)
- Explicación de la funcionalidad de cada bloque
- Resumen de utilización de recursos y tiempos (datos entregados por la herramienta ISE) 

### Material de consulta

- Contador Binario: https://www.youtube.com/watch?v=_o6NkZKH0yg
- Flip-Flop T: https://www.youtube.com/watch?v=wK5qJGI8qBA
- Flip-Flop D: https://www.youtube.com/watch?v=kQ9WICIFWnU
- Multiplexor: https://www.youtube.com/watch?v=oRIKoCm1eA8
- Lista de reproduccion: https://www.youtube.com/watch?v=vsoYlH1_hbc&list=PLWPirh4EWFpHk70zwYoHu87uVsCC8E2S-