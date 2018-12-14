-- CONTROLADOR-----------------------------------------

use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;

Entity controlador is -- Cambiar cada uno de los puertos por las señales correspondientes de la entidad top

	Generic (N: natural := 4);

	Port ( 

		boton, actual : IN std_logic_vector (N-1 downto 0); 
		motor : IN std_logic_vector(1 downto 0);
		clk: IN std_logic; --clk de 1Hz
		piso : OUT std_logic_vector (N-1 downto 0);
		ena : OUT std_logic
		--puerta: IN std_logic;
		);

End controlador;


Architecture behavioral of controlador is 

	Signal cont_boton, cont_ actual, aux : unsigned (N-1 downto 0) ;

	Begin 

		Process (clk) -- Incluir la entrada boton, pero como el if principal depende de clk, no tiene sentido por ahora 

			Variable diferencia : unsigned (N-1 downto 0);

				Begin 

					cont_boton <= to_unsigned (boton);
					cont_actual <= to_unsigned (actual);
					aux <= to_unsigned (actual);

					diferencia = cont_boton - cont_actual;

					if (rising_edge(clk)) then 

						if (diferencia /= 0 ) then  -- quizas se podría evaluar puerta = '0' 

							if (motor = "10") then 

								aux <= aux +1;
								ena <= 0;

							elsif (motor = "01") then 
							
								aux <= aux -1;
								ena <= 0;

							else 

								aux <= aux;
								ena <= 0;

							end if;

						elsif (diferencia = 0 ) then -- quizas se podría evaluar puerta = '1'

							aux <= aux; 
							actual <= boton; -- Revisar 
							ena <= 1; 

						end if;
					end if;

		end process;

		piso <= to_std_logic_vector(aux);
	
end architecture;



--TESTBENCH-- 




Entity controlador_tb is 
End entity; 


Architecture behavioral of controlador_tb is 

	Component controlador is 

	Generic (N: natural := 4);

	Port ( 

		boton, actual : IN std_logic_vector (N-1 downto 0); 
		motor : IN std_logic_vector(1 downto 0);
		clk: IN std_logic; 
		piso : OUT std_logic_vector (N-1 downto 0);
		ena : OUT std_logic
		--puerta: IN std_logic;
		);

	End component;


	Signal boton, actual : IN std_logic_vector (N-1 downto 0);
	Signal motor : IN std_logic_vector(1 downto 0);
	Signal clk: IN std_logic := '0';
	--Signal puerta : IN std_logic;
	Signal piso : OUT std_logic_vector (N-1 downto 0);
	Signal ena : OUT std_logic;


	Begin 

		uut: controlador port map (
			
			boton => boton, 
			actual => actual, 
			motor => motor,
			clk => clk, 
			--puerta => puerta, 
			piso => piso, 
			ena => ena
		);


		clk <= not clk after 1 s; --clk de 1Hz


		tb : process 

			Begin 

				boton <= "011";
				actual <= "000";
				motor <= "10";
				--puerta <='0';

				wait for 5 s; 

                boton <= "001";
				motor <= "00";

				wait for 2 s; 

				motor <= "01";

				wait for 5 s; 


            ASSERT false
            	report "Simulacion finalizada"
            	severity failure;

            End  process; 

End architecture;


























