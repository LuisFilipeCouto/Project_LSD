library 	IEEE;
use		IEEE.STD_LOGIC_1164.all;
use		IEEE.NUMERIC_STD.all;

entity FreqDivider is
	
	generic	(	factor : unsigned(31 downto 0) := "00000000010011000100101101000000" -- Equivale a 5000000
				);
	
	port	(	clockIn 	      : in 	std_logic; -- CLOCK_50
				reset		      : in  std_logic; -- sinal de reset
				enable	 	   : in 	std_logic; -- sinal de enable
				clockOut 	   : out std_logic  -- saída a 100Hz
			);
			
end FreqDivider;

architecture Behavioral of FreqDivider is

	constant k		  : unsigned(31 downto 0) := factor; -- fator de divisão (50MHz/5000000 = 10Hz)

	signal s_counter : unsigned(31 downto 0);
	
	signal s_halfWay : unsigned(31 downto 0);
	
	begin
	
		s_halfWay <= (k/2);
		
		process(clockIn)
		
		begin
		
			if (rising_edge(clockIn)) then
			
				if (reset = '1') then 
				
					clockOut <= '0';
					s_counter <= (others => '0');
					
				else
		
					if (enable = '0') then
			
						clockOut  <= '0';
						s_counter <= s_counter;
						
					else
				
						s_counter <= s_counter + 1;
				
						if (s_counter = (k-1)) then
					
							s_counter <= (others => '0');
					
							clockOut <= '0';
						
						elsif (s_counter = s_halfWay - 1) then
						
							clockOut <= '1';
						
						end if;
				
					end if;
			
				end if;
				
			end if;
			
		end process;
		
end Behavioral;