library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package matrix_type is
    type matrix is array (4 downto 0) of std_logic_vector(3 downto 0);
end package matrix_type;