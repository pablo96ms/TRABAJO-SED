use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;


Entity display_refresh is 

	Port (
		clk: IN std_logic; -- clk de más o menos 60 Hz o más 
		pta_display_1, pta_display_2, pta_display_3, pta_display_4: IN std_logic_vector(6 downto 0);
		destino_display: IN std_logic_vector(6 downto 0);
		Piso_actual_display: IN std_logic_vector(6 downto 0);
		display_selector: OUT std_logic_vector(5 downto 0);
		display_number: OUT std_logic_vector(6 downto 0)
		 );
End entity;


Architecture Behavioral of display_refresh is 

	Begin 

		selec_show_displays: process (clk, pta_display_1, pta_display_2, pta_display_3, pta_display_4, destino_display,Piso_actual_display) --Todas las entradas, aunque no se si bastaría con clk

		variable count: integer range 0 to 5;

		Begin 

		 	if (rising_edge(clk)) then 
		 		if (count = 5) then 
		 			count := 0; 
		 		else 
		 			count := count +1;

		 		end if; 
		 	end if; 

		 	Case count is 

		 			when 0 => display_selector <= "000001";
		 					  display_number <= pta_display_4;

		 			when 1 => display_selector <= "000010";
		 					  display_number <= pta_display_2;

		 			when 2 => display_selector <= "000100";
		 					  display_number <= pta_display_1;

		 			when 3 => display_selector <= "001000";
		 					  display_number <= pta_display_3;

		 			when 4 => display_selector <= "010000";
		 					  display_number <= destino_display;

		 			when 5 => display_selector <= "100000";
		 					  display_number <= Piso_actual_display;

		 	end case;

		end process;

End architecture;



