library IEEE;
use     IEEE.STD_LOGIC_1164.all;
use     IEEE.NUMERIC_STD.all;


entity Acc is 
		
		generic(N: positive := 14);
		
		port( moeda_5  : in std_logic;
		      moeda_10 : in std_logic;
				moeda_20 : in std_logic;
				moeda_50 : in std_logic;
				enable   : in std_logic;
				reset    : in std_logic;
				clk      : in std_logic;
				dataOut  : out std_logic_vector(N-1 downto 0)
				);
end Acc;


architecture Structural of Acc is

	signal s_adder  : std_logic_vector(N-1 downto 0);
	signal s_reg    : std_logic_vector(N-1 downto 0);
	signal s_valor  : std_logic_vector(N-1 downto 0);
	
	
begin	
		process(clk,moeda_5,moeda_10,moeda_20,moeda_50)
		
		begin
		
			if(rising_edge(clk)) then
				
				if (enable = '1') then
					
					if(moeda_5 = '1' and moeda_10 = '0' and moeda_20 = '0' and moeda_50 = '0') then 
						
						s_valor <= "00000000000101"; --5 centimos em binário com 14 bits
					
					elsif(moeda_5 = '0' and moeda_10 = '1' and moeda_20 = '0' and moeda_50 = '0') then
						
						s_valor <= "00000000001010"; --10 centimos em binário com 14 bits
					
					elsif(moeda_5 = '0' and moeda_10 = '0' and moeda_20 = '1' and moeda_50 = '0') then
						
						s_valor <= "00000000010100"; --20 centimos em binário com 14 bits
						
					elsif(moeda_5 = '0' and moeda_10 = '0' and moeda_20 = '0' and moeda_50 = '1') then
						
						s_valor <= "00000000110010"; --50 centimos em binário com 14 bits 
					
					else
						s_valor <= "00000000000000"; --Não é introduzido qualquer valor
					
					end if;
				
				end if;
			
			end if;
			
		end process;
		
		
		Adder_N  : entity work.Adder(Behavioral)
	
								generic map(N => N)
							
								port map( valor0    => s_valor,
											 valor1    => s_reg,
											 resultado => s_adder);
	
	
	
		Registo_N : entity work.Registo(Behavioral)
							
								generic map(N => N)
				
								port map( dataIn => s_adder,
											 enable => enable,
											 reset  => reset,
											 clk	  => clk,
											 dataOut=> s_reg);
							
		dataOut <= s_reg;
	
end Structural;