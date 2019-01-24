----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2018 20:04:44
-- Design Name: 
-- Module Name: display_refresh - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;


Entity display_refresh is 

	Port (
		clk: IN std_logic; -- clk de m�s o menos 60 Hz o m�s 
		pta_display_1, pta_display_2, pta_display_3, pta_display_4: IN std_logic_vector(6 downto 0);
		destino_display: IN std_logic_vector(6 downto 0);
		Piso_actual_display: IN std_logic_vector(6 downto 0);
		display_selector: OUT std_logic_vector(7 downto 0);
		display_number: OUT std_logic_vector(6 downto 0)
		 );
End entity;


Architecture Behavioral of display_refresh is 

	Begin 

		selec_show_displays: process (clk)-- pta_display_1, pta_display_2, pta_display_3, pta_display_4, destino_display,Piso_actual_display --Todas las entradas, aunque no se si bastar�a con clk
            variable count: integer range 0 to 5:=0;

		Begin 

		 	if (rising_edge(clk)) then 
		 		if (count = 5) then 
		 			count := 0; 
		 		else 
		 			count := count +1;

		 		end if; 
		 	

		 	Case count is 

		 			when 0 => display_selector <= "11111110";
		 					  display_number <= destino_display ;

		 			when 1 => display_selector <= "11111101";
		 					  display_number <= Piso_actual_display;

		 			when 2 => display_selector <= "10111111";
		 					  display_number <= pta_display_1;

		 			when 3 => display_selector <= "01111111";
		 					  display_number <= pta_display_3;

		 			when 4 => display_selector <= "11101111";
		 					  display_number <= pta_display_4;

		 			when 5 => display_selector <= "11011111";
		 					  display_number <=pta_display_2 ;
		 					  
		 		   when others => null;

		 	end case;
end if; 
		end process;

End architecture;
