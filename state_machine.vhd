----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.12.2018 19:42:48
-- Design Name: 
-- Module Name: state_machine - Behavioral
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


----- NUEVA M�QUINA DE ESTADOS 3.0 ----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.textio.all;
use IEEE.std_logic_textio.all;
library UNISIM;
use UNISIM.VComponents.all;

Entity state_machine is 

	Generic (N: natural:= 3);
	Port (
		sensor_puerta_fsm, stop_emergencia, reset, clk : IN std_logic;
		-- sensor_puerta : 1 cerrada/ 0 abierta
		-- sensor_presencia : 1 presencia/ 0 nadie 
		-- Discutir la frecuencia del clk
		--sensor_apertura: IN std_logic;
		led : out std_logic_vector (5 downto 0); 
		boton_piso, piso_actual : IN std_logic_vector(N-1 downto 0); 
		motor_puerta, motor_ascensor: OUT std_logic_vector(1 downto 0);
		destino_fsm: OUT std_logic_vector (N-1 downto 0)
		);

End entity;	


Architecture Behavioral of state_machine is 

type state_type is (inicio, abrir, reposo, cerrar, en_marcha, emergencia);
signal actual, siguiente: state_type; 
signal boton_piso_op, piso_actual_op : signed (N-1 downto 0); -- Se�ales para hacer comparaci�n entre diferentes pisos 
signal destino: std_logic_vector (N-1 downto 0):="000";
signal motor_puerta_aux: std_logic_vector(1 downto 0):="00";
signal motor_ascensor_aux: std_logic_vector(1 downto 0):="00";

Begin 

	sync_proc: process (clk, reset) -- proceso de actualizacion del estado actual
		begin 
			if (reset = '0') then 
				actual <= inicio; 

			elsif (rising_edge(clk)) then 
				actual <= siguiente; 
			end if; 
	end process; 


	next_state_decode: process (actual,sensor_puerta_fsm, stop_emergencia, boton_piso, piso_actual,destino,destino) --proceso para calcular el siguiente estado 
		begin 
			--siguiente <= inicio; 

			case (actual) is 
                     when inicio => -- Estado de comienzo de simulacion; para salir de este estado hay que pulsar el bot�n del primer piso
                        if (boton_piso = "001" and sensor_puerta_fsm = '1') then 
                            siguiente <= abrir;
                        else
                         siguiente<=inicio;
                        end if; 

                    when abrir => -- Abriendo las puertas 
                        if (sensor_puerta_fsm = '0') then  
                            siguiente <= reposo;
                        else
                        siguiente<=abrir;
                        end if; 

                    when reposo => --Ascensor en reposo, permanece hasta que no pulsamos un piso diferente
                        if (boton_piso /= piso_actual and boton_piso/= "000") then --No se si poner boton_piso o destino en el if
                            destino <= boton_piso; --Guardo el pulso del boton en una se�al 
			                boton_piso_op <= signed(boton_piso); --Convierto el pulso del boton en un signed
                            siguiente <= cerrar;
                         else
                         siguiente<=reposo;
                        end if; 

                    when cerrar => -- Cerrando puertas
                        if (sensor_puerta_fsm = '1') then 
                            siguiente <= en_marcha;

                        --elsif (sensor_presencia = '1') then -- Si mientras se cierra las puertas para alguien al ascensor, las puertas se abren  
                            --siguiente <= abrir;
                        else
                        siguiente<=cerrar;

                        end if; 

                    when en_marcha => -- Ascensor subiendo o bajando 
                        if (destino = piso_actual) then 
                            siguiente <= abrir; 
                        elsif (stop_emergencia = '1') then  
                            siguiente <= emergencia;
                         else
                         siguiente<=en_marcha;
                        end if; 

                    when emergencia => -- Dentro del ascensor hay un boton de emergencia, si se pulsa el ascensor se detendr� mientras este pulsado
                        if (stop_emergencia = '0') then 
                            siguiente <= en_marcha;
                         else
                         siguiente<=emergencia;
                        end if; 
                        
                    when others=> NULL;

                end case;
    End process; 
destino_fsm <= destino;

    output_decode: process (actual,piso_actual,boton_piso_op,piso_actual_op,piso_actual,boton_piso_op)
    	begin

    		--boton_piso_op <= to_signed (boton_piso);
    		piso_actual_op <= signed (piso_actual);

    		case (actual) is 
    			when inicio => -- Motor del ascensor y de las puertas parados
    				motor_puerta_aux <= "11"; --Motor puerta parado con puertas cerradas
    				motor_ascensor_aux <= "11";
    				led <= "000001";

    			when abrir => -- Puertas abri�ndose y ascensor parado
    				motor_puerta_aux <= "01";
    				motor_ascensor_aux <= "11";
    				led <= "000010";
				
    			when reposo => -- puertas abiertas y ascensor parado 
    				motor_puerta_aux <= "00"; --Motor puerta parado con puertas abiertas
    				motor_ascensor_aux <= "11";
    				led <= "000100";

    			when cerrar => -- Puertas cerr�ndose y motor parado 
    				motor_puerta_aux <= "10";
    				motor_ascensor_aux <= "11";
    				led <= "001000";
				--destino_fsm <= destino; -- No se si tengo que poner esta salida en todos los estados para que se mantenga

    			when en_marcha =>  -- Puertas cerradas 
    				motor_puerta_aux <= "11";				
    				if ((boton_piso_op - piso_actual_op) > 0) then -- Si el piso requerido est� por encima del actual, le motor ir� hacia arriba (10)
    					motor_ascensor_aux <= "10";
    				else 
    					motor_ascensor_aux <= "01"; -- Sino, el motor ir� para abajo (01)
    				end if;
                    led <= "010000";
    			when emergencia => -- Cuando se pulsa el boton de emergencia el ascensor se para y permanece cerrado
    				motor_puerta_aux <= "11";
    				motor_ascensor_aux <= "11";
    				led <= "100000";
    		   when others => null;
				

    		end case;
    end process;
    motor_puerta<=motor_puerta_aux;
    motor_ascensor<=motor_ascensor_aux;
    --destino_fsm <= destino;
end Behavioral; 
