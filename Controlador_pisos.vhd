
------ CONTROLADOR DE LOS PISOS ------

use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;

Entity controlador_pisos is 

	Generic (N: natural := 4); --Número de pisos 
	Port (
		clk, reset: IN std_logic;
		motor_ascensor: IN std_logic_vector(1 downto 0);
		piso_actual: OUT std_logic_vector(N-1 downto 0)
		);
End entity;



Architecture Behavioral of controlador_pisos is 

Signal piso_actual_internal: unsigned (N-1 downto 0);

Begin
	
	Process (clk,reset) --clk de 1Hz
		Begin 
			piso_actual_internal <= to_unsigned (piso_actual);

			if (reset = '1') then 
				piso_actual_internal <= "001";

			elsif (rising_edge(clk)) then -- clk de 1Hz, sube un piso por segundo

				if (motor_ascensor = "10") then 
					piso_actual_internal <= piso_actual_internal +1;

				elsif (motor_ascensor = "01") then --Bajando a 1 segundo por planta  
					piso_actual_internal <= piso_actual_internal -1;

				else -- Parado 
					piso_actual_internal <= piso_actual_internal; -- ¿Unaffected? 
					
				end if;
			end if; 

	End process; 
	piso_actual <= to_std_logic_vector (piso_actual_internal);

End architecture;

