use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;


Entity controlador_puerta is 

	Port (
		motor_puerta: IN std_logic_vector(1 downto 0);
		sensor_presencia, clk, reset: IN std_logic;
		sensor_puerta: OUT std_logic;
		puerta_display: OUT std_logic_vector (3 downto 0) --Manda al display el estado de la puerta a cada segundo
		);
End entity;	


Architecture Behavioral of controlador_puerta is 

Begin 

	Process (clk, sensor_presencia, reset) 

		Variable cont: natural range 0 to 4; 
		Begin 
			if (reset ='1') then 
				puerta_display <= "0001"; --Puerta cerrada, estado de inicio
				sensor_puerta <= '1'; 
			elsif (sensor_presencia ='1') then -- Problema: si el las puertas estan abriendose y pulsamos sensor presencia se iniciaria este bucle. 
				if (cont /= 0) then 
					cont := cont -1; 
					if (cont = 2) then -- Valoro los diferentes valores de la cuenta y saco el estado de la puerta que corresponda
						puerta_display <= "0010"; 
					elsif (cont = 1) then 
						puerta_display <= "0100";
					elsif (cont =0) then 
						puerta_display <= "1000";
					end if;
				else 
					sensor_puerta <= '0'; -- Puerta abierta 
					cont := 0; 
					--puerta_display <= "1000"; No se si deberia ponerlo para mantener el display
				end if; 

			elsif (rising_edge(clk)) then 
				if (motor_puerta = "10") then --Puertas cerrándose 
					if (cont /= 4) then -- Tardarán tres seg. en cerrarse las puertas en caso de que el clk sea de 1Hz			
						if (cont =0) then 
							puerta_display <= "1000";
						elsif (cont = 1) then 
							puerta_display <= "0100";
						elsif (cont = 2) then
							puerta_display <= "0010";
						elsif (cont = 3) then 
							puerta_display <= "0001";
						end if;
						cont := cont +1;
								
					else 
						cont := 0; 
						sensor_puerta <= '1'; -- Puerta cerrada 
						--puerta_display <= "11"; No se si deberia ponerlo aquí para mantener el valor en el display
					end if; 
				 

				elsif (motor_puerta ="01") then --Puertas abriéndose 
					if (cont /= 4) then 
						if (cont =0) then 
							puerta_display <= "0001";
						elsif (cont = 1) then 
							puerta_display <= "0010";
						elsif (cont = 2) then
							puerta_display <= "0100";
						elsif (cont = 3) then 
							puerta_display <= "1000";
						end if;
						cont := cont +1;
					else 
						cont := 0; 
						sensor_puerta <= '0'; --Puerta abierta 
						--puerta_display <= "1000"; No se si deberia ponerla para mantener el valor del display
					end if; 

				elsif (motor_puerta ="11") then -- Motor parado con puertas cerradas 
					sensor_puerta <= '1'; --Puerta cerrada 
					puerta_display <= "0001";
				
				else -- Unico estado que queda: motor parado con puertas abiertas 
					sensor_puerta <= '0'; -- Puerta abierta
					puerta_display <= "1000";
				end if;

			end if;

	End process;



TESTBENCH
				
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controlador_Puerta_tb is
--  Port ( );
end Controlador_Puerta_tb;

architecture Behavioral of Controlador_Puerta_tb is
    component controlador_puerta is 

	   Port (
		  motor_puerta: IN std_logic_vector(1 downto 0);
		  sensor_presencia, clk, reset: IN std_logic;
		  sensor_puerta: OUT std_logic;
		  puerta_display: OUT std_logic_vector (1 downto 0) --Manda al display el estado de la puerta a cada segundo
		);
    End component;	
    
signal motor_puerta_tb: std_logic_vector(1 downto 0);
signal sensor_presencia_tb, clk_tb, reset_tb: std_logic;

    begin
        inst_Controlador_Puerta: Controlador_Puerta PORT MAP(
            motor_puerta=>motor_puerta_tb,
            sensor_presencia=>sensor_presencia_tb,
            clk=>clk_tb,
            reset=>reset_tb
);
clk_tb<= NOT clk_tb after 30ns;
reset_tb<= '0','1' after 20ns,'0' after 60ns;
sensor_presencia_tb<='1';
    process
        begin
            wait for 70ns;
            motor_puerta_tb<="01";
            wait for 100ns;
            motor_puerta_tb<="10";
            wait for 130ns;
            motor_puerta_tb<="11";
    end process;


end Behavioral;
