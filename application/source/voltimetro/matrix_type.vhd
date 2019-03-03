library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package matrix_type is
    type matrix is array (4 downto 0) of std_logic_vector(3 downto 0);
    
    type matrix_ROM is array (0 to 7) of std_logic_vector(0 to 7);	-- Creacion del tipo matriz 2 dimensiones 8x8
    type matrix3D_ROM is array (0 to 11) of matrix_ROM;				-- Creacion del tipo matriz 3 dimensiones 12x8x8
end package matrix_type;