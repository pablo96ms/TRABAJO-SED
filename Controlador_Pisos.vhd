
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.textio.all;
use IEEE.std_logic_textio.all;
library UNISIM;
use UNISIM.VComponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controlador_Pisos is
        generic(N:natural:=3);
        Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           motor_ascensor : in STD_LOGIC_VECTOR (N-2 downto 0);
           --led_piso:out std_logic_vector (N-1 downto 0);
           piso_actual : out STD_LOGIC_VECTOR (N-1 downto 0));
end Controlador_Pisos;

architecture Behavioral of Controlador_Pisos is

Signal piso_actual_internal: unsigned (N-1 downto 0);
--Signal led_piso_internal: unsigned (N-1 downto 0);

begin
    process(clk,reset)--clk 1Hz
        begin
                --piso_actual_internal <= to_unsigned (piso_actual);
    
                if (reset = '0') then 
                    piso_actual_internal <= "001";
                    --led_piso_internal <= "001";
    
                elsif (rising_edge(clk)) then -- clk de 1Hz, sube un piso por segundo
    
                    if (motor_ascensor = "10") then 
                        piso_actual_internal <= piso_actual_internal +1;
                        --led_piso_internal <= led_piso_internal+1;
    
                    elsif (motor_ascensor = "01") then --Bajando a 1 segundo por planta  
                        piso_actual_internal <= piso_actual_internal -1;
                         --led_piso_internal <= led_piso_internal -1;
    
                    else -- Parado 
                        piso_actual_internal <= piso_actual_internal; -- �Unaffected? Tengo mis dudas, hay que revisarlo 
                        --led_piso_internal <= led_piso_internal;
                        
                    end if;
                end if;
    
     end process; 
        piso_actual <= std_logic_vector (piso_actual_internal);
        --led_piso<= std_logic_vector(led_piso_internal);


end Behavioral;
