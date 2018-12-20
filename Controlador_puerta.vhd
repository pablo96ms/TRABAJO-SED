use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;


Entity controlador_puerta is 

	Port (
		motor_puerta: IN std_logic_vector(1 downto 0);
		sensor_presencia, clk: IN std_logic;
		sensor_puerta: OUT std_logic;
		puerta_display: OUT std_logic_vector (1 downto 0) --Manda al display el estado de la puerta a cada segundo
		);
End entity;	


Architecture Behavioral of controlador_puerta is 

Begin 

	Process (clk, sensor_presencia) 

		Variable cont: natural := 0; 
		Begin 
			if (sensor_presencia ='1') then -- Problema: si el las puertas estan abriendose y pulsamos sensor presencia se iniciaria este bucle. 
				if (cont /= 0) then 
					cont := cont -1; 
					if (cont = 2) then -- Valoro los diferentes valores de la cuenta y saco el estado de la puerta que corresponda
						puerta_display <= "10"; 
					elsif (cont = 1) then 
						puerta_display <= "01";
					elsif (cont =0) then 
						puerta_display <= "00";
					end if;
				else 
					sensor_puerta <= '0'; -- Puerta abierta 
					cont := 0; 
					--puerta_display <= "00"; No se si deberia ponerlo para mantener el display
				end if; 

			elsif (rising_edge(clk)) then 
				if (motor_puerta = "10") then --Puertas cerrándose 
					if (cont /= 4) then -- Tardarán tres seg. en cerrarse las puertas en caso de que el clk sea de 1Hz			
						if (cont =0) then 
							puerta_display <= "00";
						elsif (cont = 1) then 
							puerta_display <= "01";
						elsif (cont = 2) then
							puerta_display <= "10";
						elsif (cont = 3) then 
							puerta_display <= "11";
						end if;
						cont := cont +1;
								
					else 
						cont := 0; 
						sensor_puerta <= '1'; -- Puerta cerrada 
						--puerta_display <= "11"; No se si deberia ponerlo aquí para mantener el valor en el display
					end if; 
				 

				elsif (motor_puerta ="01") then --Puertas abriéndose 
					if (cont /= 4) then 
						if (cont =0) then 
							puerta_display <= "11";
						elsif (cont = 1) then 
							puerta_display <= "10";
						elsif (cont = 2) then
							puerta_display <= "01";
						elsif (cont = 3) then 
							puerta_display <= "00";
						end if;
						cont := cont +1;
					else 
						cont := 0; 
						sensor_puerta <= '0'; --Puerta abierta 
						--puerta_display <= "00"; No se si deberia ponerla para mantener el valor del display
					end if; 

				elsif (motor_puerta ="11") then -- Motor parado con puertas cerradas 
					sensor_puerta <= '1'; --Puerta cerrada 
					puerta_display <= "11";
				
				else -- Unico estado que queda: motor parado con puertas abiertas 
					sensor_puerta <= '0'; -- Puerta abierta
					puerta_display <= "00";
				end if;

			end if;

	End process;




