
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;

Entity decoder_motor_led is 


	Port (

		motor_ascensor : IN std_logic_vector(1 downto 0);
		Led : OUT std_logic_vector(6 downto 0)

		);

End entity; 

Architecture dataflow of decoder_motor_led is 

Begin 
	
With motor_ascensor select 
			
			Led <= "1111111" when "10", -- Hacia arriba
				   "0001111" when "01",-- Hacia abajo 
				   "0010010" when others; --Parado


End architecture;
