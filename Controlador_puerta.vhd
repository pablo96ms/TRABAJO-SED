use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;


Entity controlador_puerta is 

	Port (
		motor_puerta: IN std_logic_vector(1 downto 0);
		sensor_presencia, clk: IN std_logic;
		sensor_puerta: OUT std_logic
		);
End entity;	


Architecture Behavioral of controlador_puerta is 

Begin 

	Process (clk, sensor_presencia) 

		Variable cont: natural := 0; 
		Begin 
			if (sensor_presencia ='1') then 
				if (cont /= 0) then 
					cont := cont -1; 
				else 
					sensor_puerta <= '0'; -- Puerta abierta 
					cont := 0; 
				end if; 

			elsif (rising_edge(clk)) then 
				if (motor_puerta = "10") then --Puertas cerrándose 
					if (cont /= 1) then -- Tardarán dos seg. en cerrarse las puertas en caso de que el clk sea de 1Hz ya que la puerta se cerrara 
					-- en el siguiente golpe de reloj respecto a cuando cont = 1. 
						cont := cont +1; 
					else 
						cont := 0; 
						sensor_puerta <= '1'; -- Puerta cerrada 
					end if; 
				 

				elsif (motor_puerta ="01") then --Puertas abriéndose 
					if (cont /= 1) then 
						cont := cont +1;
					else 
						cont := 0; 
						sensor_puerta <= '0'; --Puerta abierta 
					end if; 

				elsif (motor_puerta ="11") then -- Motor parado con puertas cerradas 
					sensor_puerta <= '1'; --Puerta cerrada 
				
				else -- Unico estado que queda: motor parado con puertas abiertas 
					sensor_puerta <= '0'; -- Puerta abierta

				end if;

			end if;

	End process;




