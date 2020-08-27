library	IEEE;
use		IEEE.STD_LOGIC_1164.all;
use		IEEE.NUMERIC_STD.all;


entity BIN2BCD is 
	
	port	(	euro	      : in	std_logic_vector(13 downto 0);
				centimo	   : in	std_logic_vector(13 downto 0);
				euroD       : out std_logic_vector(13 downto 0);
				euroU	      : out std_logic_vector(13 downto 0); 
				centimoD	   : out std_logic_vector(13 downto 0);
				centimoU	   : out std_logic_vector(13 downto 0)
			);

end Bin2BCD;

architecture Behavioral of BIN2BCD is

signal s_euroD     : std_logic_vector(13 downto 0);
signal s_euroU     : std_logic_vector(13 downto 0);
signal s_centimoD  : std_logic_vector(13 downto 0);
signal s_centimoU  : std_logic_vector(13 downto 0);


begin

	process(euro,centimo,s_euroD,s_euroU,s_centimoD,s_centimoU)
			
		begin	
	
			if(euro = "11111111111111" and centimo = "11111111111111") then -- Para quando estamos no estado FREEZE
			
				s_euroD 	   <= "11111111111111";
				s_euroU 	   <= "11111111111111";
				s_centimoD 	<= "11111111111111";
				s_centimoU 	<= "11111111111111";
		
				euroD		   <= s_euroD;
				euroU		   <= s_euroU;
				centimoD		<= s_centimoD;
				centimoU		<= s_CentimoU;
		
		
			elsif(euro = "00000001111110" and centimo = "00000001111110") then -- Para quando estamos no estado INIT e ainda não escolhemos um produto
				
				s_euroD 	   <= "00000001111000";
				s_euroU 	   <= "00000001111110";
				s_centimoD 	<= "00000001111100";
				s_centimoU 	<= "00000001111000";
				
				euroD       <= s_euroD;
				euroU       <= s_euroU;
				centimoD    <= s_centimoD;
				centimoU    <= s_centimoU;
			
			
			else
				s_euroD 	   <= std_logic_vector(unsigned(euro)/10);
				s_euroU 	   <= std_logic_vector(unsigned(euro) rem 10);
				s_centimoD 	<= std_logic_vector(unsigned(centimo)/10);
				s_centimoU 	<= std_logic_vector(unsigned(centimo) rem 10);		
	
				euroD		   <= s_euroD;
				euroU		   <= s_euroU;
				centimoD		<= s_centimoD;
				centimoU		<= s_centimoU;
		
			end if;
		
	end process;

end Behavioral;