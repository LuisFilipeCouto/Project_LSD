library	IEEE;
use		IEEE.STD_LOGIC_1164.all;
use		IEEE.NUMERIC_STD.all;


entity TrocoCounter is 
	
		port	(	moeda_5  : in std_logic;
					moeda_10 : in std_logic;
					moeda_20 : in std_logic;
					moeda_50 : in std_logic;
					enable   : in std_logic;
					reset    : in std_logic;
					clk      : in std_logic;
					freeze   : out std_logic;
					trocoOut : out std_logic_vector(9 downto 0)
				);

end TrocoCounter;  


architecture Behavioral of TrocoCounter is


signal s_leds 		: std_logic_vector( 9 downto 0) := "1111111111";	
signal s_freeze   : std_logic := '0';

	
begin	
		
	process(clk,moeda_5,moeda_10,moeda_20,moeda_50,reset)
		
		begin
		
			if(reset = '1') then
				
				s_leds <= "1111111111";
		
			elsif(rising_edge(clk)) then
				
				if (enable = '1') then
					
					if(moeda_5 = '1' and moeda_10 = '0' and moeda_20 = '0' and moeda_50 = '0') then 
						
						s_freeze <='0';
						s_leds <= '0' & s_leds(9 downto 1); 
					
					elsif(moeda_5 = '0' and moeda_10 = '1' and moeda_20 = '0' and moeda_50 = '0') then
						
						s_freeze <='0';
						s_leds <= '0' & s_leds(9 downto 1); 
					
					elsif(moeda_5 = '0' and moeda_10 = '0' and moeda_20 = '1' and moeda_50 = '0') then
						
						s_freeze <='0';
						s_leds <= '0' & s_leds(9 downto 1); 
						
					elsif(moeda_5 = '0' and moeda_10 = '0' and moeda_20 = '0' and moeda_50 = '1') then
						
						s_freeze <='0';
						s_leds <= '0' & s_leds(9 downto 1); 
					
					elsif(s_leds = "0000000000") then
						
						s_leds   <= "0000000000";
						s_freeze <='1';					
					
					else
						s_freeze <= '0';
						s_leds   <= s_leds; --Não é introduzido qualquer valor
					
					end if;
				
				end if;
			
			end if;
			
		end process;

		
trocoOut <= s_leds;
freeze   <= s_freeze;

end Behavioral;