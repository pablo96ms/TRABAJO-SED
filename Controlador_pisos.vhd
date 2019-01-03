
------ CONTROLADOR DE LOS PISOS ------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.textio.all;
use IEEE.std_logic_textio.all;
library UNISIM;
use UNISIM.VComponents.all;



entity Controlador_Pisos is
        generic(N:natural:=4);
        Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           motor_ascensor : in STD_LOGIC_VECTOR (N-3 downto 0);
           piso_actual : out STD_LOGIC_VECTOR (N-2 downto 0));
end Controlador_Pisos;

architecture Behavioral of Controlador_Pisos is

Signal piso_actual_internal: unsigned (N-2 downto 0);

begin
    process(clk,reset)--clk 1Hz
        begin
                --piso_actual_internal <= to_unsigned (piso_actual);--lo he comentado porque daba error
    
                if (reset = '1') then 
                    piso_actual_internal <= "001";
    
                elsif (rising_edge(clk)) then -- clk de 1Hz, sube un piso por segundo
    
                    if (motor_ascensor = "10") then 
                        piso_actual_internal <= piso_actual_internal +1;
    
                    elsif (motor_ascensor = "01") then --Bajando a 1 segundo por planta  
                        piso_actual_internal <= piso_actual_internal -1;
    
                    else -- Parado 
                        piso_actual_internal <= piso_actual_internal; -- ¿Unaffected? 
                        
                    end if;
                end if;
    
     end process; 
        piso_actual <= std_logic_vector (piso_actual_internal);


end Behavioral;
			    
			    
			    
			    --TESTBENCH
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Controlador_Pisos_tb is
--  Port ( );
end Controlador_Pisos_tb;

architecture Behavioral of Controlador_Pisos_tb is

    component Controlador_Pisos is
        generic(N:natural:=4);
        Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           motor_ascensor : in STD_LOGIC_VECTOR (1 downto 0);
           piso_actual : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
    
signal clk_tb: std_logic:='0';
signal reset_tb: std_logic:='0';
signal motor_ascensor_tb: std_logic_vector(1 downto 0):="00";
signal piso_actual_tb: std_logic_vector(2 downto 0):="000";

begin
    inst_Controlador_Pisos: Controlador_Pisos PORT MAP(
        clk=>clk_tb,
        reset=>reset_tb,
        motor_ascensor=>motor_ascensor_tb,
        piso_actual=>piso_actual_tb
     );

    clk_tb<= NOT clk_tb after 30ns;
    reset_tb<= '0','1' after 20ns,'0' after 60ns;
    process
        begin
            wait for 40ns;
            motor_ascensor_tb<="01";
            wait for 70ns;
            motor_ascensor_tb<="10";
            wait for 90ns;
            motor_ascensor_tb<="11";
            wait for 110ns;
            motor_ascensor_tb<="00";
    end process;
end Behavioral;

