--DECODER MOTOR---------------------------------------------------

use library ieee;
use ieee.std_logic_1164.all;
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
			
			Led <= "0000001" when "10", -- Hacia arriba
				   "1001111" when "01",-- Hacia abajo 
				   "0010010" when others; --Parado


End architecture;



-- TESTBENCH --



Entity decoder_motor_led_tb is 

End decoder_motor_led_tb;



Architecture behavioral of decoder_motor_led_tb is 

	Component decoder_motor_led is 


		Port (

			motor_ascensor: IN std_logic_vector(1 downto 0);
			Led : OUT std_logic_vector(6 downto 0)

			);

	End component;

Signal motor_ascensor : std_logic_vector(1 downto 0);
Signal Led: std_logic_vector(6 downto 0);


TYPE vtest is record

	 motor_ascensor : std_logic_vector(1 DOWNTO 0);
	 Led : std_logic_vector(6 DOWNTO 0);

END RECORD;


TYPE vtest_vector IS ARRAY (natural RANGE <>) OF vtest;

CONSTANT test: vtest_vector := (

 (motor_ascensor => "00", led => "0000001"),
 (motor_ascensor => "01", led => "1001111"),
 (motor_ascensor => "10", led => "0010010")

 );


 Begin 

 		uut: decoder_motor_led port map (
 			
 			motor_ascensor => motor_ascensor,
 			Led => Led
 		);
 			
 		       

 		
 		tb: PROCESS

				BEGIN
						FOR i IN 0 TO test'HIGH LOOP
							motor_ascensor <= test(i).motor_ascensor;
							WAIT FOR 20 ns;
							ASSERT led = test(i).led
								REPORT "Salida incorrecta."
								SEVERITY FAILURE;
						END LOOP;

						ASSERT false

						REPORT "Simulacion finalizada. Test superado."
						SEVERITY FAILURE;
           
            End process;

End behavioral;




















