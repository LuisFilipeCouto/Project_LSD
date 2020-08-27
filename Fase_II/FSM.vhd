library IEEE;
use     IEEE.STD_LOGIC_1164.all;
use 	  IEEE.NUMERIC_STD.all;



entity FSM is

		port( pagamento     : in std_logic_vector(13 downto 0);
				produto       : in std_logic_vector(3 downto 0);
				clk_50        : in std_logic;
				clk           : in std_logic;
				reset         : in std_logic;
				reset_acc     : out std_logic;						   -- Apos o levantamento do produto, dar reset ao acumulador
				reset_timer   : out std_logic;							-- Dar reset ao timer
				reset_freq    : out std_logic;
				enable_freq   : out std_logic;
				euro          : out std_logic_vector(13 downto 0);
				centimo       : out std_logic_vector(13 downto 0);
				led           : out std_logic;                     -- Acender um LED verde caso o switch nao esteja para baixo
				blink_led     : out std_logic  		    			   -- Acender um LED verde caso o switch esteja para baixo antes do processo acabar 
				 );
				
end FSM;


architecture Behavioral of FSM is


	type stateType is (INIT,FREEZE,LONGO,CURTO,CHOC,CAPPU,PAY,LEVANTAMENTO); -- Declarar quais os estados que existem
	
	signal	s_currentState     : stateType;
	signal	s_nextState        : stateType;
	signal   s_led              : std_logic := '0';
	signal   s_reset            : std_logic := '0';
	signal 	s_display_euro     : signed(13 downto 0) := "00000000000000";
	signal   s_display_centimos : signed(13 downto 0) := "00000000000000";
	signal   s_pagamento        : signed(13 downto 0);
	
	signal   s_cafe_curto       : std_logic := '0';
	signal   s_cafe_longo       : std_logic := '0';
	signal   s_choc_quente      : std_logic := '0';
	signal   s_cappuccino       : std_logic := '0';
	signal   s_produto          : std_logic := '0';
	
	signal   s_timer            : std_logic := '0';
	signal   s_reset_timer      : std_logic := '0';
	
	signal   s_reset_freq       : std_logic := '0';
	signal   s_enable_freq      : std_logic := '0';
		
	constant c_preco_curto      : signed(13 downto 0) := "00000000011110"; -- Preco de um café curto       ==> 30 centimos
	constant c_preco_longo      : signed(13 downto 0) := "00000000011110"; -- Preco de um café longo       ==> 30 centimos
	constant c_preco_choc       : signed(13 downto 0) := "00000000110010"; -- Preco de um chocolate quente ==> 50 centimos
	constant c_preco_cappu      : signed(13 downto 0) := "00000000101101"; -- Preco de um cappuccino       ==> 45 centimos
	
	
	begin
	
		s_pagamento <= signed(pagamento);
	
		sync_proc : process(clk_50)
		
			begin
			
				if (rising_edge(clk_50)) then
					
						s_currentState <= s_nextState;
						
					end if;
				
			end process;


		comb_proc : process(s_currentState, produto, s_pagamento,s_cafe_curto,s_cafe_longo,s_choc_quente,s_cappuccino,reset,s_produto,clk,s_display_euro)
	
			begin
				
				if(reset = '1') then -- Da reset total á máquina e aos blocos auxiliares
				
					s_display_centimos <= "00000001111110";
					s_display_euro     <= "00000001111110";
					s_led              <='0';
				   s_cafe_curto       <='0';
					s_cafe_longo       <='0';
					s_choc_quente      <='0';
					s_cappuccino       <='0';
					s_timer            <='0';
					s_reset_timer      <='1';
					s_reset            <='1';
					s_produto          <='0';
					s_reset_freq       <='1';
					s_enable_freq      <='0';
					s_nextState        <= INIT;
					
				else 
				
					case (s_currentState) is
						
						when INIT =>   -- Estado inicial em que o utilizador ainda não escolheu produto
						
								s_display_centimos <= "00000001111110";
								s_display_euro     <= "00000001111110";
								s_led              <='0';
								s_cafe_curto       <='0';
								s_cafe_longo       <='0';
								s_choc_quente      <='0';
								s_cappuccino       <='0';
								s_timer            <='0';
								s_reset_timer      <='0';
								s_produto          <='0';
								s_reset_freq       <='1';
								s_enable_freq      <='0';
								
								if(s_pagamento = 0) then
									
									s_reset <='0';
									
									if (produto = "0001") then
									
										s_nextState <= CURTO;
									
									elsif (produto = "0010") then 
										
										s_nextState <= LONGO;
								
									elsif (produto = "0100") then 
														
										s_nextState <= CHOC;
						
									elsif (produto = "1000") then 
																	  
										s_nextState <= CAPPU;
							
									elsif (produto = "0000") then
								
										s_nextState <= INIT;
									
									else
								
										s_nextState <= FREEZE;
									
									end if;
									
								 else 
								 
									s_reset <='1';
									s_nextState <= INIT;
									
								 end if;	
						
						
						when CURTO =>  -- Estado que mostra o preço do café curto e espera pela inserção de moedas ou troca de produto
						
								s_display_centimos <= c_preco_curto;
								s_display_euro     <= "00000000000000";
								s_reset            <='0';
								s_led              <='0';
								s_cafe_longo       <='0';
								s_choc_quente      <='0';
								s_cappuccino       <='0';
								s_timer            <='0';
								s_reset_timer      <='1';
								s_produto          <='0';
								s_reset_freq       <='1';
								s_enable_freq      <='0';
								
								if(s_pagamento = 0) then
									
									s_cafe_curto <='0';	
									
									if (produto = "0001") then
								
										s_nextState <= CURTO;
									
									elsif (produto = "0010") then 
										
										s_nextState <= LONGO;
								
									elsif (produto = "0100") then 
															
										s_nextState <= CHOC;
						
									elsif (produto = "1000") then 
																								  
										s_nextState <= CAPPU;
							
									elsif (produto = "0000") then
								
										s_nextState <= INIT;
						
									else
								
										s_nextState <= FREEZE;

									end if;	
								
								else
									
									s_cafe_curto <='1';
									s_nextState <= PAY;
								
								end if;
						
						
						when LONGO =>  -- Estado que mostra o preço do café longo e espera pela inserção de moedas ou troca de produto
							
								s_display_centimos <= c_preco_longo;
								s_display_euro     <= "00000000000000";
								s_reset            <='0';
								s_led              <='0';
								s_cafe_curto       <='0';
								s_choc_quente      <='0';
								s_cappuccino       <='0';
								s_timer            <='0';
								s_reset_timer      <='1';
								s_produto          <='0';
								s_reset_freq       <='1';
								s_enable_freq      <='0';
								
								if(s_pagamento = 0) then
										
									s_cafe_longo <='0';	
										
									if (produto = "0001") then
								
										s_nextState <= CURTO;
									
									elsif (produto = "0010") then 
										
										s_nextState <= LONGO;
								
									elsif (produto = "0100") then 
															
										s_nextState <= CHOC;
						
									elsif (produto = "1000") then 
																								  
										s_nextState <= CAPPU;
							
									elsif (produto = "0000") then
								
										s_nextState <= INIT;
						
									else
								
										s_nextState <= FREEZE;

									end if;	
								
								else
									
									s_cafe_longo<='1';
									s_nextState <= PAY;
								
								end if;
		
						
						
						when CHOC => -- Estado que mostra o preço do chocolate quente e espera pela inserção de moedas ou troca de produto
								
								s_display_centimos <= c_preco_choc;
								s_display_euro     <= "00000000000000";
								s_reset            <='0';
								s_led              <='0';
								s_cafe_curto       <='0';
								s_cafe_longo       <='0';
								s_cappuccino       <='0';
								s_timer            <='0';
								s_reset_timer      <='1';
								s_produto          <='0';
								s_reset_freq       <='1';
								s_enable_freq      <='0';
								
								if(s_pagamento = 0) then
										
									s_choc_quente <='0';
									
									if (produto = "0001") then
								
										s_nextState <= CURTO;
									
									elsif (produto = "0010") then 
										
										s_nextState <= LONGO;
								
									elsif (produto = "0100") then 
															
										s_nextState <= CHOC;
						
									elsif (produto = "1000") then 
																								  
										s_nextState <= CAPPU;
							
									elsif (produto = "0000") then
								
										s_nextState <= INIT;
						
									else
								
										s_nextState <= FREEZE;

									end if;	
								
								else
									
									s_choc_quente <='1';
									s_nextState <= PAY;
								
								end if;
		
						
						when CAPPU => -- Estado que mostra o preço do cappuccino e espera pela inserção de moedas ou troca de produto
								
								s_display_centimos <= c_preco_cappu;
								s_display_euro     <= "00000000000000";
								s_reset            <='0';	
								s_led              <='0';
								s_cafe_curto       <='0';
								s_cafe_longo       <='0';
								s_choc_quente      <='0';
								s_timer            <='0';
								s_reset_timer      <='1';
								s_produto          <='0';
								s_reset_freq       <='1';
								s_enable_freq      <='0';
								
								if(s_pagamento = 0) then
									
									s_cappuccino <='0';
									
									if (produto = "0001") then
								
										s_nextState <= CURTO;
									
									elsif (produto = "0010") then 
										
										s_nextState <= LONGO;
								
									elsif (produto = "0100") then 
															
										s_nextState <= CHOC;
						
									elsif (produto = "1000") then 
																								  
										s_nextState <= CAPPU;
							
									elsif (produto = "0000") then
								
										s_nextState <= INIT;
						
									else
								
										s_nextState <= FREEZE;

									end if;	
								
								else
									
									s_cappuccino<='1';
									s_nextState <= PAY;
								
								end if;
						
						
						when FREEZE => -- Estado que acontece quando o utilizador escolhe 2 ou mais produtos ao mesmo tempo
							
								s_display_centimos <= "11111111111111"; -- Valor de controlo para usarmos no BIN2BCD
								s_display_euro     <= "11111111111111"; -- Valor de controlo para usarmos no BIN2BCD
								s_led              <='0';
								s_cafe_curto       <='0';
								s_cafe_longo       <='0';
								s_choc_quente      <='0';
								s_cappuccino       <='0';
								s_timer            <='0';
								s_reset_timer      <='1';
								s_produto          <='0';
								s_reset_freq       <='1';
								s_enable_freq      <='0';
								
								if(s_pagamento = 0) then
										
									s_reset <='0';
									
									if (produto = "0001") then
								
										s_nextState <= CURTO;
									
									elsif (produto = "0010") then 
										
										s_nextState <= LONGO;
								
									elsif (produto = "0100") then 
															
										s_nextState <= CHOC;
						
									elsif (produto = "1000") then 
																								  
										s_nextState <= CAPPU;
							
									elsif (produto = "0000") then
								
										s_nextState <= INIT;
						
									else
								
										s_nextState <= FREEZE;

									end if;	
								
								else
									
									s_reset <='1';
									s_nextState <= FREEZE;
								
								end if;
								
						
						
						when PAY => -- Estado de pagamento dos produtos
								
								s_led          <='0';
								s_timer        <='0';
								s_reset_timer  <='1';
								s_produto      <='0';
								s_reset_freq   <='1';
								s_enable_freq  <='0';
								
								if(produto = "0001" or s_cafe_curto = '1') then
									
									s_cafe_curto  <='1';
									s_cafe_longo  <='0';
									s_choc_quente <='0';
									s_cappuccino  <='0';
									
									
									if((c_preco_curto - s_pagamento)>"00000000000000") then
										
										s_reset        	 <='0';
										s_display_centimos <= (c_preco_curto - s_pagamento);
										s_display_euro     <= "00000000000000";
										s_nextState        <= PAY;
									
									
									else
										
										s_reset            <='0';
										s_display_centimos <= "00000000000000";
										s_display_euro     <= "00000000000000"; 
										s_nextState        <= LEVANTAMENTO;
									
									end if;
									
									
								elsif(produto = "0010" or s_cafe_longo = '1') then
									
									s_cafe_curto  <='0';
									s_cafe_longo  <='1';
									s_choc_quente <='0';
									s_cappuccino  <='0';

									if((c_preco_longo - s_pagamento)>"00000000000000") then
										
										s_reset            <='0';
										s_display_centimos <= (c_preco_longo - s_pagamento);
										s_display_euro     <= "00000000000000";
										s_nextState        <= PAY;
									
									else
										
										s_reset            <='0';
										s_display_centimos <= "00000000000000";
										s_display_euro     <= "00000000000000";
										s_nextState        <= LEVANTAMENTO;
									
									end if;
							
							
								elsif(produto = "0100" or s_choc_quente = '1') then
									
									s_cafe_curto  <='0';
									s_cafe_longo  <='0';
									s_choc_quente <='1';
									s_cappuccino  <='0';
									
									
									if((c_preco_choc - s_pagamento)>"00000000000000") then
										
										s_reset            <='0';
										s_display_centimos <= (c_preco_choc - s_pagamento);
										s_display_euro     <= "00000000000000";
										s_nextState        <= PAY;
										
				
									else
										s_reset            <='0';
										s_display_centimos <= "00000000000000";
										s_display_euro     <= "00000000000000";
										s_nextState        <= LEVANTAMENTO;
									
									end if;
									
									
								elsif(produto = "1000" or s_cappuccino = '1') then 
									
									s_cafe_curto  <='0';
									s_cafe_longo  <='0';
									s_choc_quente <='0';
									s_cappuccino  <='1';
									
									
									if((c_preco_cappu - s_pagamento)>"00000000000000") then
										
										s_reset            <='0';
										s_display_centimos <= (c_preco_cappu - s_pagamento);
										s_display_euro     <= "00000000000000";
										s_nextState        <= PAY;
									
							
									else
										
										s_reset        	 <='0';
										s_display_centimos <= "00000000000000";
										s_display_euro     <= "00000000000000";
										s_nextState        <= LEVANTAMENTO;
									
									end if;
								
								
								else	
								
									s_reset        	 <='0';
									s_cafe_curto       <='0';
									s_cafe_longo       <='0';
									s_choc_quente      <='0';
									s_cappuccino       <='0';
									s_nextState        <= LEVANTAMENTO;
									s_display_centimos <= "00000001111110";
									s_display_euro     <= "00000001111110";							
								end if;
								
								
						when LEVANTAMENTO => -- Estado em que calculamos o troco e levantamos o produto e o troco
									
									s_reset_freq       <='0';
									s_enable_freq      <='1';										s_cafe_curto       <='0';
									s_cafe_longo       <='0';
									s_choc_quente      <='0';
									s_cappuccino       <='0';
										
										
									if(produto = "0001") and (s_produto ='1') then
														
										if(s_pagamento >= 100) then
											
											s_display_centimos <= (s_pagamento-c_preco_curto) rem 100;
											s_display_euro     <= (s_pagamento-c_preco_curto) / 100;
											
											s_produto     		 <='1';	
											s_reset_timer      <='1';
											s_timer            <='0';
											s_led              <='1';
											s_reset            <='0';
											s_nextState        <= LEVANTAMENTO;
										
										
										else
											
											s_display_centimos <= (s_pagamento - c_preco_curto);
											
											s_display_euro     <= "00000000000000";
											
											s_produto     		 <='1';	
											s_reset_timer      <='1';
											s_timer            <='0';
											s_led              <='1';
											s_reset            <='0';
											s_nextState        <= LEVANTAMENTO;
										
										end if;
									
									
									elsif(produto = "0010") and (s_produto ='1') then
														
										if(s_pagamento >= 100) then
											
											s_display_centimos <= (s_pagamento-c_preco_longo) rem 100;
											s_display_euro     <= (s_pagamento-c_preco_longo) / 100;
											
											s_produto     		 <='1';	
											s_reset_timer      <='1';
											s_timer            <='0';
											s_led              <='1';
											s_reset            <='0';
											s_nextState        <= LEVANTAMENTO;
										
										
										else
											
											s_display_centimos <= (s_pagamento - c_preco_longo);
											
											s_display_euro     <= "00000000000000";
											
											s_produto     		 <='1';	
											s_reset_timer      <='1';
											s_timer            <='0';
											s_led              <='1';
											s_reset            <='0';
											s_nextState        <= LEVANTAMENTO;
										
										end if;
									
									
									elsif(produto = "0100") and (s_produto ='1') then
														
										if(s_pagamento >= 100) then
											
											s_display_centimos <= (s_pagamento-c_preco_choc) rem 100;
											s_display_euro     <= (s_pagamento-c_preco_choc) / 100;
											
											s_produto     		 <='1';	
											s_reset_timer      <='1';
											s_timer            <='0';
											s_led              <='1';
											s_reset            <='0';
											s_nextState        <= LEVANTAMENTO;
										
										
										else
											
											s_display_centimos <= (s_pagamento - c_preco_choc);
											
											s_display_euro     <= "00000000000000";
											
											s_produto     		 <='1';	
											s_reset_timer      <='1';
											s_timer            <='0';
											s_led              <='1';
											s_reset            <='0';
											s_nextState        <= LEVANTAMENTO;
										
										end if;
									
									
									elsif(produto = "1000") and (s_produto ='1') then
														
										if(s_pagamento >= 100) then
											
											s_display_centimos <= (s_pagamento-c_preco_cappu) rem 100;
											s_display_euro     <= (s_pagamento-c_preco_cappu) / 100;
											
											s_produto     		 <='1';	
											s_reset_timer      <='1';
											s_timer            <='0';
											s_led              <='1';
											s_reset            <='0';
											s_nextState        <= LEVANTAMENTO;
										
										
										else
											
											s_display_centimos <= (s_pagamento - c_preco_cappu);
											
											s_display_euro     <= "00000000000000";
											
											s_produto     		 <='1';	
											s_reset_timer      <='1';
											s_timer            <='0';
											s_led              <='1';
											s_reset            <='0';
											s_nextState        <= LEVANTAMENTO;
										
										end if;
									
									
									elsif((produto = "0000") and (s_produto ='0')) then
										
										s_produto     		 <='0';	
										s_reset_timer 		 <='0';
										s_timer       		 <='1';
										s_led              <='0';
										s_reset            <='1';
										s_display_centimos <= "00000000000000";
										s_display_euro     <= "00000000000000";
										s_nextState  		 <= INIT;

									
									else
										
										s_produto     		 <='1';
										s_reset_timer 		 <='1';
										s_timer            <='1';
										s_led              <='0';
										s_reset            <='1';										s_display_centimos <= "00000000000000";
										s_display_euro     <= "00000000000000";
										s_nextState        <= INIT;
											end if;  
					end case;
				
				end if;					
		
			end process;

			
euro        <= std_logic_vector(s_display_euro);
centimo     <= std_logic_vector(s_display_centimos);
reset_acc   <= s_reset;
reset_timer <= s_reset_timer;
reset_freq  <= s_reset_freq;
enable_freq <= s_enable_freq;
led         <=	s_led;
blink_led   <= s_timer;

end Behavioral;
	