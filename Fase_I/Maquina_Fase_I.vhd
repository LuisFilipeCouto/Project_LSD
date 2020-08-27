library work;
library IEEE;
use     IEEE.STD_LOGIC_1164.all;
use     IEEE.NUMERIC_STD.all;


entity Maquina_Fase_I is
		
		port( CLOCK_50 : in  std_logic; 
				KEY 		: in  std_logic_vector(3 downto 0); -- Para introduzir as moedas (5,10,20 ou 50)
				SW   		: in  std_logic_vector(4 downto 0); -- Para escolher o produto (curto,longo, chocolate quente ou cappuccino) ou dar reset á máquina (SW4)
				LEDG     : out std_logic_vector(1 downto 0); -- Vamos usar 2 LEDs
				HEX0		: out std_logic_vector(6 downto 0); -- Mostrar no display as unidades de cêntimos
				HEX1		: out std_logic_vector(6 downto 0); -- Mostrar no display as dezenas de cêntimos
				HEX2		: out std_logic_vector(6 downto 0); -- Mostrar no display as unidades de euros
				HEX3		: out std_logic_vector(6 downto 0)  -- Mostrar no display as dezenas de euros
				);
				
end Maquina_Fase_I;


architecture Structural of Maquina_Fase_I is 

	signal s_sw          : std_logic_vector(3 downto 0);  -- SW para escolher produtos   
	signal s_keydeb0     : std_logic;  							-- Moeda de 5 cêntimos
	signal s_keydeb1     : std_logic; 							-- Moeda de 10 cêntimos
	signal s_keydeb2     : std_logic; 							-- Moeda de 20 cêntimos
	signal s_keydeb3     : std_logic; 							-- Moeda de 50 cêntimos
	signal s_debsw       : std_logic;                     -- Sinal de reset (queremos que funcione como uma key por isso vamos usar debouncer)
	signal s_pagamento   : std_logic_vector(13 downto 0); -- Valor máximo que utilizador pode introduzir é 9999 cêntimos
	signal s_reset_acc   : std_logic; 							-- Sinal que sai da maquina de estados e da reset ao acumulador
	signal s_reset_timer : std_logic; 							-- Sinal que sai da maquina de estados e da reset ao timer
	signal s_valor_euro  : std_logic_vector(13 downto 0); -- Valor em euros que sai da maquina de estados	
	signal s_valor_cent  : std_logic_vector(13 downto 0); -- Valor em cêntimos que sai da maquina de estados
	signal s_euroU       : std_logic_vector(13 downto 0); -- Valor das unidades de euros que mostra no display
	signal s_euroD       : std_logic_vector(13 downto 0); -- Valor das dezenas de euros que mostra no display
	signal s_centimoU    : std_logic_vector(13 downto 0); -- Valor das unidades de centimos que mostra no display
	signal s_centimoD    : std_logic_vector(13 downto 0); -- Valor das dezenas de centimos que mostra no display 
	signal s_blink_led   : std_logic;                     -- LED que pisca durante 3s
	signal s_led         : std_logic;                     -- LED que esta ligado enquanto o switch nao esta para baixo
	
begin	

-------------------------------REGISTO DOS SW PARA ESCOLHER PRODUTOS-----------------------------------------------------------
	process(CLOCK_50)
	
	begin
		
		if (rising_edge(CLOCK_50)) then
			
			s_sw <= SW(3 downto 0);
		
		end if;
	
	end process; 
-------------------------------DEBOUNCERS--------------------------------------------------------------------------------------

	debkey0  :  entity work.DebounceUnit(Behavioral) -- Usamos o debouncer fornecido na pagina da disciplina
	
							 generic map	(  kHzClkFreq     => 50000, -- 5000Khz equivale a 50Mhz
													mSecMinInWidth => 100,
													inPolarity     => '0',
													outPolarity    => '1'
													)
									
							 port map ( refclk    => CLOCK_50,
											dirtyIn   => KEY(0),
											pulsedOut => s_keydeb0								  
											);
								
								
	debkey1  :  entity work.DebounceUnit(Behavioral) -- Usamos o debouncer fornecido na pagina da disciplina
	
	                   generic map	(  kHzClkFreq     => 50000, -- 5000Khz equivale a 50Mhz 
													mSecMinInWidth => 100,
													inPolarity     => '0',
													outPolarity    => '1'
													)
									
							 port map ( refclk    => CLOCK_50,
											dirtyIn   => KEY(1),
											pulsedOut => s_keydeb1								  
											);
								
								
								
	debkey2  :  entity work.DebounceUnit(Behavioral) -- Usamos o debouncer fornecido na pagina da disciplina
	
							 generic map	(  kHzClkFreq     => 50000, -- 5000Khz equivale a 50Mhz
													mSecMinInWidth => 100,   -- Equivale aos 100Hz
													inPolarity     => '0',
													outPolarity    => '1'
													)
									
							 port map ( refclk    => CLOCK_50,
											dirtyIn   => KEY(2),
											pulsedOut => s_keydeb2								  
											);							
								
								
	debkey3  :  entity work.DebounceUnit(Behavioral) -- Usamos o debouncer fornecido na pagina da disciplina
	
							 generic map( 		kHzClkFreq     => 50000, -- 5000Khz equivale a 50Mhz
													mSecMinInWidth => 100,   -- Equivale aos 100Hz
													inPolarity     => '0',
													outPolarity    => '1'
												)		
									
							 port map ( refclk    => CLOCK_50,
											dirtyIn   => KEY(3),
											pulsedOut => s_keydeb3								  
											);	
	
	
	debsw  :  entity work.DebounceUnit(Behavioral) -- Usamos o debouncer fornecido na pagina da disciplina
	
							 generic map( 		kHzClkFreq     => 50000, -- 5000Khz equivale a 50Mhz
													mSecMinInWidth => 100,   -- Equivale aos 100Hz
													inPolarity     => '0',
													outPolarity    => '1'
												)		
									
							 port map ( refclk    => CLOCK_50,
											dirtyIn   => SW(4),
											pulsedOut => s_debsw								  
											);								
								
------------------------------------FUNCIONAMENTO DO ACUMULADOR-------------------------------------------------------------------

	
	valorAcc  : entity work.Acc(Structural)
							
							 generic map ( N => 14)
							 
							 port map ( moeda_5  => s_keydeb0,
											moeda_10 => s_keydeb1,
											moeda_20 => s_keydeb2,
											moeda_50 => s_keydeb3,
											enable   => '1',
											reset    => s_reset_acc,
											clk      => CLOCK_50,
											dataOut  => s_pagamento
											);
											
------------------------------------FUNCIONAMENTO DA MÁQUINA DE ESTADOS E BLOCOS AUXILIARES---------------------------------------	
	
	fsm       : entity work.FSM(Behavioral)
					
					port map ( pagamento     => s_pagamento,
								  produto       => s_sw(3 downto 0),
								  clk           => CLOCK_50,
								  reset         => s_debsw,
								  reset_acc     => s_reset_acc,
								  reset_timer   => s_reset_timer,
								  euro          => s_valor_euro,
								  centimo       => s_valor_cent,
								  led           => LEDG(0),
								  blink_led     => s_blink_led
								  );
								   
	timerled     : entity work.timer(Behavioral)
					
					port map ( clk      => CLOCK_50,
								  start    => s_blink_led,
								  reset    => s_reset_timer,
								  timerOut => s_led
								  );
	
	LEDG(1) <= s_led;
	
----------------------------------------DISPLAY DE 7 SEGMENTOS-------------------------------------------------------------------		

	toBCD		: 	entity work.BIN2BCD(Behavioral)
	
					port map	(	euro	   =>	s_valor_euro,
								   centimo	=> s_valor_cent,
	                        euroU	   => s_euroU,
	                        euroD	   =>	s_euroD,
	                        centimoU	=> s_centimoU,
	                        centimoD	=> s_centimoD
								);

	HEXeuroD	:	entity work.Bin7SegDecoder(Behavioral)
	
					port map ( enable		=> '1',
								  binInput	=> s_euroD,
	                       decOut_n	=> HEX3
								);
								
	HEXeuroU	:	entity work.Bin7SegDecoder(Behavioral)
	
					port map ( enable		=> '1',
								  binInput	=> s_euroU,
	                       decOut_n	=> HEX2
								);
								
	HEXcentimoD	:	entity work.Bin7SegDecoder(Behavioral)
	
					port map ( enable		=> '1',
								  binInput	=> s_centimoD,
	                       decOut_n	=> HEX1
								);
								
	HEXcentimoU	:	entity work.Bin7SegDecoder(Behavioral)
	
					port map ( enable		=> '1',
								  binInput	=> s_centimoU,
	                       decOut_n	=> HEX0
								);	  
								  
end Structural;								