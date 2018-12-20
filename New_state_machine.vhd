

----- NUEVA MÁQUINA DE ESTADOS 3.0 ----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.textio.all;
use IEEE.std_logic_textio.all;
library UNISIM;
use UNISIM.VComponents.all;

Entity state_machine is 

	Generic (N: natural:4);
	Port (
		sensor_puerta, stop_emergencia, reset, clk, sensor_presencia : IN std_logic;
		-- sensor_puerta : 1 cerrada/ 0 abierta
		-- sensor_presencia : 1 presencia/ 0 nadie 
		-- Discutir la frecuencia del clk
		--sensor_apertura: IN std_logic; 
		boton_piso, piso_actual : IN std_logic_vector(N-1 downto 0); 
		motor_puerta, motor_ascensor: OUT std_logic_vector(1 downto 0);
		destino_fsm: OUT std_logic _vector (N-1 downto 0)
		);

End entity;	


Architecture Behavioral of state_machine is 

type state_type is (incio, abrir, reposo, cerrar, en_marcha, emergencia);
signal actual, siguiente: state_type; 
signal boton_piso_op, piso_actual_op : signed (N-1 downto 0); -- Señales para hacer comparación entre diferentes pisos 
signal destino: std_logic_vector (N-1 downto 0);

Begin 

	sync_proc: process (clk, reset) -- proceso de actualizacion del estado actual
		begin 
			if (reset = '1') then 
				actual <= inicio; 

			elsif (rising_edge(clk)) then 
				actual <= siguiente; 
			end if; 
	End process; 


	next_state_decode: process (actual,sensor_puerta, stop_emergencia, sensor_presencia, boton_piso, piso_actual) --proceso para calcular el siguiente estado 
		begin 
			siguiente <= incio; 

			case (actual) is 
                     when inicio => -- Estado de comienzo de simulacion; para salir de este estado hay que pulsar el botón del primer piso
                        if (boton_piso = "001" and sensor_puerta = '1') then 
                            actual <= abrir;
                        end if; 

                    when abrir => -- Abriendo las puertas 
                        if (sensor_puerta = '0') then 
                            actual <= reposo; 
                        end if; 

                    when reposo => --Ascensor en reposo, permanece hasta que no pulsamos un piso diferente
                        if (boton_piso /= piso_actual and boton/= "000") then 
				
			    destino <= boton_piso; --Guardo el pulso del boton en una señal 
			    boton_piso_op <= to_signed (boton_piso); --Convierto el pulso del boton en un signed
                            actual <= cerrar;
			    
                        end if; 

                    when cerrar => -- Cerrando puertas
                        if (sensor_puerta <= '1') then 
                            actual <= en_marcha; 

                        elsif (sensor_presencia <= '1') then -- Si mientras se cierra las puertas para alguien al ascensor, las puertas se abren 
                            actual <= abrir; 

                        end if; 

                    when en_marcha => -- Ascensor subiendo o bajando 
                        if (destino = piso_actual) then 
                            actual <= abrir; 
                        elsif (stop_emergencia = '1') then 
                            actual <= emergencia; 
                        end if; 

                    when emergencia => -- Dentro del ascensor hay un boton de emergencia, si se pulsa el ascensor se detendrá mientras este pulsado
                        if (stop_emergencia <= '0') then 
                            actual <= en_marcha;
                        end if; 

                end case;
    End process; 


    output_decode: process (actual)
    	begin

    		--boton_piso_op <= to_signed (boton_piso);
    		piso_actual_op <= to_signed (piso_actual);

    		case (actual) is 
    			when incio => -- Motor del ascensor y de las puertas parados
    				motor_puerta <= "11";
    				motor_ascensor <= "11";

    			when abrir => -- Puertas abriéndose y ascensor parado
    				motor_puerta <= "01";
    				motor_ascensor <= "11";
				
    			when reposo => -- puertas abiertas y ascensor parado 
    				motor_puerta <= "11";
    				motor_ascensor<= "11";

    			when cerrar => -- Puertas cerrándose y motor parado 
    				motor_puerta <= "10";
    				motor_ascensor <= "11";
				destino_fsm <= destino; -- No se si tengo que poner esta salida en todos los estados para que se mantenga

    			when en_marcha =>  -- Puertas cerradas 
    				motor_puerta <= "11";				
    				if ((boton_piso_op - piso_actual_op) > 0) then -- Si el piso requerido está por encima del actual, le motor irá hacia arriba (10)
    					motor_ascensor <= "10";
    				else 
    					motor_ascensor <= "01"; -- Sino, el motor irá para abajo (01)
    				end if;

    			when emergencia => -- Cuando se pulsa el boton de emergencia el ascensor se para y permanece cerrado
    				motor_puerta <= "11";
    				motor_ascensor <= "11";
				

    		end case;
    End process;


























