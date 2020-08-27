library 	IEEE;
use 		IEEE.STD_LOGIC_1164.all;

entity Bin7SegDecoder is

port	(	enable		: in	std_logic;
			binInput    : in 	std_logic_vector(13 downto 0);
			decOut_n    : out std_logic_vector(6 downto 0)
		);
		
end Bin7SegDecoder;

architecture Behavioral of Bin7SegDecoder is

signal s_decOut : std_logic_vector(6 downto 0);

begin
	
	s_decOut <= "1111001" when (binInput = "00000000000001") else --1
					"0100100" when (binInput = "00000000000010") else --2
					"0110000" when (binInput = "00000000000011") else --3
					"0011001" when (binInput = "00000000000100") else --4
					"0010010" when (binInput = "00000000000101") else --5
					"0000010" when (binInput = "00000000000110") else --6
					"1111000" when (binInput = "00000000000111") else --7
					"0000000" when (binInput = "00000000001000") else --8
					"0010000" when (binInput = "00000000001001") else --9
					"0001000" when (binInput = "00000000001010") else --A
					"0000011" when (binInput = "00000000001011") else --b
					"1000110" when (binInput = "00000000001100") else --C
					"0100001" when (binInput = "00000000001101") else --D
					"0000110" when (binInput = "00000000001110") else --E
					"0001110" when (binInput = "00000000001111") else --F
	-----------------------------------------------------------------------------------------------------------------------------------------------				
					"0111111" when (binInput = "11111111111111") else -- Serve para o estado freeze, para apresentar em cada HEX o simbolo "-"
					
					"1000000" when (binInput = "00000001111110") else -- Serve para o estado init, para apresentar no HEX2 a letra "o"
					
					"0101011" when (binInput = "00000001111100") else -- Serve para o estado init, para apresentar no HEX1 a letra "n"
					
					"1111111" when (binInput = "00000001111000") else -- Serve para o estado init, para não apresentar qualquer simbolo nos HEX3 e HEX0
					
					"1000000"; 										    --0
					
	decOut_n <= s_decOut when (enable = '1') else "1111111";
					
end Behavioral;