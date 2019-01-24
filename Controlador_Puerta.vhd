
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.textio.all;
use IEEE.std_logic_textio.all;
library UNISIM;
use UNISIM.VComponents.all;


Entity controlador_puerta is 

	Port (
		motor_puerta: IN std_logic_vector(1 downto 0);
		sensor_presencia, clk, reset: IN std_logic;
		sensor_puerta: OUT std_logic;
		puerta_display: OUT std_logic_vector (3 downto 0) --Manda al display el estado de la puerta a cada segundo
		);
End entity;	


Architecture Behavioral of controlador_puerta is 

Begin 

	Process (clk, sensor_presencia, reset) 

		Variable cont: natural := 0; 
		Begin 
			if (reset ='0') then 
				puerta_display <= "0011"; --Puerta cerrada, estado de inicio
				sensor_puerta <= '1'; 
				--esta parte no creo que est� del todo bien ya que deber�a ir antes la se�al de reloj para que el contador incrementase sus valores
--			elsif (sensor_presencia ='1') then -- Problema: si el las puertas estan abriendose y pulsamos sensor presencia se iniciaria este bucle. 
--				if (cont > 0) then 
--					cont := cont -1; 
--					if (cont = 2) then -- Valoro los diferentes valores de la cuenta y saco el estado de la puerta que corresponda
--						puerta_display <= "0010"; 
--					elsif (cont = 1) then 
--						puerta_display <= "0001";
--					elsif (cont =0) then 
--						puerta_display <= "0000";
--					end if;
--				else 
--					sensor_puerta <= '0'; -- Puerta abierta 
--					cont := 0;-- entonces,�cuando se incrementa el valor del contador? 
--					puerta_display <= "0000"; --No se si deberia ponerlo para mantener el display
--				end if; 

			elsif (rising_edge(clk)) then 
				if (motor_puerta = "10") then --Puertas cerr�ndose 
				    if (sensor_presencia ='1') then -- Problema: si el las puertas estan abriendose y pulsamos sensor presencia se iniciaria este bucle. 
                                if (cont > 0) then 
                                    cont := cont -1; 
                                    if (cont = 2) then -- Valoro los diferentes valores de la cuenta y saco el estado de la puerta que corresponda
                                        puerta_display <= "0010"; 
                                    elsif (cont = 1) then 
                                        puerta_display <= "0001";
                                    elsif (cont =0) then 
                                        puerta_display <= "0000";
                                    end if;
                                else 
                                    sensor_puerta <= '0'; -- Puerta abierta 
                                    cont := 0;-- entonces,�cuando se incrementa el valor del contador? 
                                    puerta_display <= "0000"; --No se si deberia ponerlo para mantener el display
                                end if; 
					 elsif (cont /= 4) then -- Tardar�n tres seg. en cerrarse las puertas en caso de que el clk sea de 1Hz			
						if (cont =0) then 
							puerta_display <= "0000";
						elsif (cont = 1) then 
							puerta_display <= "0001";
						elsif (cont = 2) then
							puerta_display <= "0010";
						elsif (cont = 3) then 
							puerta_display <= "0011";
						end if;
						cont := cont +1;
								
					else 
						cont := 0; 
						sensor_puerta <= '1'; -- Puerta cerrada 
						puerta_display <=  "0011"; --No se si deberia ponerlo aqu� para mantener el valor en el display
					end if; 
				 

				elsif (motor_puerta ="01") then --Puertas abri�ndose 
					if (cont /= 4) then 
						if (cont =0) then 
							puerta_display <= "0011";
						elsif (cont = 1) then 
							puerta_display <= "0010";
						elsif (cont = 2) then
							puerta_display <= "0001";
						elsif (cont = 3) then 
							puerta_display <= "0000";
						end if;
						cont := cont +1;
					else 
						cont := 0; 
						sensor_puerta <= '0'; --Puerta abierta 
						puerta_display <= "0000"; --No se si deberia ponerla para mantener el valor del display
					end if; 

				elsif (motor_puerta ="11") then -- Motor parado con puertas cerradas 
					sensor_puerta <= '1'; --Puerta cerrada 
					puerta_display <= "0011";
				
				else -- Unico estado que queda: motor parado con puertas abiertas 
					sensor_puerta <= '0'; -- Puerta abierta
					puerta_display <= "0000";
				end if;

			end if;

	end process;
end Behavioral;
