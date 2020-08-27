library IEEE;
use 	  IEEE.STD_LOGIC_1164.all;
use     IEEE.NUMERIC_STD.all;


entity Adder is

		generic( N : positive := 14); -- Valor máximo que pode ser introduzido é 99,99€ que são 9999 cêntimos
												-- Para representar 9999 precisamos de 14 bits 
												
		port( valor0    : in std_logic_vector (N-1 downto 0);
				valor1    : in std_logic_vector (N-1 downto 0);
				resultado : out std_logic_vector(N-1 downto 0));

end Adder;


architecture Behavioral of Adder is

begin

	resultado <= std_logic_vector(unsigned(valor0) + unsigned(valor1)); -- Somar os valores

end Behavioral;
