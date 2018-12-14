--DECODER MOTOR---------------------------------------------------

use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;

Entity decoder is 


	Port (

		motor : IN std_logic_vector(1 downto 0);
		Led : OUT std_logic_vector(6 downto 0)

		);

End entity; 

Architecture dataflow of decoder is 

Begin 
	
With motor select 
			
			Led <= "0000001" when "00",
				   "1001111" when "01",
				   "0010010" when others;


End architecture;



-- TESTBENCH --



Entity decoder_tb is 

End decoder_tb;



Architecture behavioral of decoder_tb is 

	Component decoder is 


		Port (

			motor : IN std_logic_vector(1 downto 0);
			Led : OUT std_logic_vector(6 downto 0)

			);

	End component;

Signal motor : std_logic_vector(1 downto 0);
Signal Led: std_logic_vector(6 downto 0);


TYPE vtest is record

	 motor : std_logic_vector(1 DOWNTO 0);
	 Led : std_logic_vector(6 DOWNTO 0);

END RECORD;


TYPE vtest_vector IS ARRAY (natural RANGE <>) OF vtest;

CONSTANT test: vtest_vector := (

 (motor => "00", led => "0000001"),
 (motor => "01", led => "1001111"),
 (motor => "10", led => "0010010")

 );


 Begin 

 		uut: decoder port map (
 			
 			motor => motor;
 			Led => Led;
 		);
 			
 		       

 		
 		tb: PROCESS

				BEGIN
						FOR i IN 0 TO test'HIGH LOOP
							motor <= test(i).motor;
							WAIT FOR 20 ns;
							ASSERT led = test(i).led
									REPORT "Salida incorrecta."
									SEVERITY FAILURE;
						END LOOP;

						ASSERT false

						REPORT "Simulacin finalizada. Test superado."
						SEVERITY FAILURE;
           
            End process;

End behavioral;




















