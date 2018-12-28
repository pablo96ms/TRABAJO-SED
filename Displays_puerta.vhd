use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;

Entity puerta_display_decoder1 is 

	Port (
		puerta_display : IN std_logic_vector(3 downto 0);
		pta_display_1: OUT std_logic_vector(6 downto 0)
		);
End puerta_display_decoder1;



Entity puerta_display_decoder2 is 

	Port (
		puerta_display : IN std_logic_vector(3 downto 0);
		pta_display_2: OUT std_logic_vector(6 downto 0)
		);
End puerta_display_decoder2;



Entity puerta_display_decoder3 is 

	Port (
		puerta_display : IN std_logic_vector(3 downto 0);
		pta_display_3: OUT std_logic_vector(6 downto 0)
		);
End puerta_display_decoder3;



Entity puerta_display_decoder4 is 

	Port (
		puerta_display : IN std_logic_vector(3 downto 0);
		pta_display_4: OUT std_logic_vector(6 downto 0)
		);
End puerta_display_decoder4;



Architecture dataflow of puerta_display_decoder1 is 

	Begin 

		With puerta_display select 

						pta_display_1 <= "1001111" when "0001",
										 "1111001" when "0010",
										 "1111111" when others; -- Todo apagado 
									 
End architecture;


Architecture dataflow of puerta_display_decoder2 is 

	Begin 

		With puerta_display select 

						pta_display_2 <= "1111001" when "0001",
									 	 "1001111" when "0010",
									 	 "1111111" when others; -- Todo apagado 
									 
End architecture;


Architecture dataflow of puerta_display_decoder3 is 

	Begin 

		With puerta_display select 

						pta_display_3 <= "1001111" when "0100",
									 	 "1111001" when "1000",
									 	 "1111111" when others; -- Todo apagado 
									 
End architecture;


Architecture dataflow of puerta_display_decoder4 is 

	Begin 

		With puerta_display select 

						pta_display_4 <= "1111001" when "0100",
									 	 "1001111" when "1000",
									 	 "1111111" when others; -- Todo apagado 
									 
End architecture;


