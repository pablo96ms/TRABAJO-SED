----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2019 19:11:27
-- Design Name: 
-- Module Name: top - Structural
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

entity top is
    Port ( sensor_presencia : in STD_LOGIC;
           --sensor_puerta_top : BUFFER STD_LOGIC;
           RST : in STD_LOGIC;
           stop_emergencia : in STD_LOGIC;
           botones : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           CLOCK : in STD_LOGIC;
           display_number : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           Led_top: out STD_LOGIC_VECTOR(6 DOWNTO 0);
           led_top_fsm: out std_logic_vector(5 downto 0);
           --led_piso_actual: out std_logic_vector(2 downto 0);
           display_selection : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end top;

architecture Structural of top is

signal boton_bin_out: std_logic_vector(2 downto 0);
signal clk_control_pisos_puerta: std_logic;
signal clk_refresh_displays: std_logic;
signal destino_fsm: std_logic_vector(2 downto 0);
signal motor_puerta_fsm, motor_ascensor_fsm:std_logic_vector(1 downto 0);
signal piso_actual: std_logic_vector(2 downto 0);
signal puerta_display_top: std_logic_vector(3 downto 0);
signal piso_actual_display_top: std_logic_vector(6 downto 0);
signal destino_display_top: std_logic_vector(6 downto 0);
signal puerta_display_1: std_logic_vector(6 downto 0);
signal puerta_display_2: std_logic_vector(6 downto 0);
signal puerta_display_3: std_logic_vector(6 downto 0);
signal puerta_display_4: std_logic_vector(6 downto 0);
signal sensor_puerta_aux:std_logic;
signal boton_sinc:std_logic_vector(3 downto 0);
signal boton_deb:std_logic_vector(3 downto 0);
signal led_fsm : std_logic_vector(5 downto 0);
signal led_piso_actual_int: std_logic_vector (2 downto 0);
signal clk_control_puerta:std_logic;

    component debouncer is
        Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_out : out STD_LOGIC);
    end component;
    
    
    component sincronizador is
        Port ( sync_in : in STD_LOGIC;
               clk : in STD_LOGIC;
               sync_out : out STD_LOGIC);
    end component;


        component clk_divider is
        generic(n:positive:=100000000);
            Port ( clk : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   clk_out : out STD_LOGIC);
    end component;
    
    component Controlador_Pisos is
            generic(N:natural:=3);
                Port ( clk : in STD_LOGIC;
                       reset : in STD_LOGIC;
                       motor_ascensor : in STD_LOGIC_VECTOR (N-2 downto 0);
                       --led_piso:out std_logic_vector (N-1 downto 0);
                       piso_actual : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component;
    
    component Piso_actual_display is 
        
        Generic (N: integer:= 3);
    
        Port (
            Piso_actual: IN std_logic_vector(N-1 downto 0);
            Piso_actual_display: OUT std_logic_vector(6 downto 0)
            );
    
    End component;
    
    component controlador_puerta is 
    
        Port (
            motor_puerta: IN std_logic_vector(1 downto 0);
            sensor_presencia, clk, reset: IN std_logic;
            sensor_puerta: OUT std_logic;
            puerta_display: OUT std_logic_vector (3 downto 0) --Manda al display el estado de la puerta a cada segundo
            );
    End component;    
    
    
    component decoder_destino_display is 
    
        Generic (N: integer:= 4);
    
        Port (
            destino_fsm: IN std_logic_vector(N-2 downto 0);
            destino_display: OUT std_logic_vector(6 downto 0)
            );
    
    End component;
    
    component decoder_motor_led is 
    
    Port (
    
            motor_ascensor : IN std_logic_vector(1 downto 0);
            Led : OUT std_logic_vector(6 downto 0));
    End component; 
    
    component display_refresh is 
    
        Port (
            clk: IN std_logic; -- clk de m�s o menos 60 Hz o m�s 
            pta_display_1, pta_display_2, pta_display_3, pta_display_4: IN std_logic_vector(6 downto 0);
            destino_display: IN std_logic_vector(6 downto 0);
            Piso_actual_display: IN std_logic_vector(6 downto 0);
            display_selector: OUT std_logic_vector(7 downto 0);
            display_number: OUT std_logic_vector(6 downto 0)
             );
    End component;
    
    component input_decoder is 
        
        Generic (N: natural := 4); -- Numero de pisos, por cada piso un boton 
        Port (
            boton_placa: IN std_logic_vector(N-1 downto 0);
            boton_bin: OUT std_logic_vector(2 downto 0)
            );
    End component;
    
    component puerta_display_decoder1 is
        Port (
        puerta_display : IN std_logic_vector(3 downto 0);
        pta_display_1: OUT std_logic_vector(6 downto 0)
        );
    end component;
    
    component puerta_display_decoder2 is
            Port (
            puerta_display : IN std_logic_vector(3 downto 0);
            pta_display_2: OUT std_logic_vector(6 downto 0)
            );
        end component;
        
        component puerta_display_decoder3 is
                Port (
                puerta_display : IN std_logic_vector(3 downto 0);
                pta_display_3: OUT std_logic_vector(6 downto 0)
                );
            end component;
            
        component puerta_display_decoder4 is
                    Port (
                    puerta_display : IN std_logic_vector(3 downto 0);
                    pta_display_4: OUT std_logic_vector(6 downto 0)
                    );
        end component;
                
        
        component state_machine is 
        
            Generic (N: natural:= 3);
            Port (
                sensor_puerta_fsm, stop_emergencia, reset, clk: IN std_logic;
                -- sensor_puerta : 1 cerrada/ 0 abierta
                -- sensor_presencia : 1 presencia/ 0 nadie 
                -- Discutir la frecuencia del clk
                --sensor_apertura: IN std_logic; 
                boton_piso, piso_actual : IN std_logic_vector(N-1 downto 0); 
                motor_puerta, motor_ascensor: OUT std_logic_vector(1 downto 0);
                destino_fsm: OUT std_logic_vector (N-1 downto 0);
                led : out std_logic_vector(5 downto 0)
                );
        
        End component;    
        
    
    
begin

gen_sinc:for i in botones'range generate
inst_sincronizador: sincronizador port map(
sync_in=>botones(i),
clk=>CLOCK,
sync_out=>boton_sinc(i)
);
end generate;

gen_deb:for i in botones'range generate
inst_debouncer: debouncer port map(
clk=>CLOCK,
rst=>RST,
btn_in=>boton_sinc(i),
btn_out=>boton_deb(i)
);
end generate;

inst_input_decoder: input_decoder generic map(N=>4) port map(
boton_placa=>boton_deb,
boton_bin=>boton_bin_out
);
inst_clk_divider_control_puerta: clk_divider generic map (n=>50000000) port map(
clk=>CLOCK,
reset=>RST,
clk_out=>clk_control_puerta
);

inst_clk_divider_control_pisos_puerta: clk_divider generic map (n=>100000000) port map(
clk=>CLOCK,
reset=>RST,
clk_out=>clk_control_pisos_puerta
);
inst_clk_divider_refresh_displays: clk_divider generic map(n=>200000) port map(--frecuencia de 50hz pero se puede poner m�s sin problema
clk=>CLOCK,
reset=>RST,
clk_out=>clk_refresh_displays
);
inst_contr_puerta: Controlador_Puerta port map(
motor_puerta=>motor_puerta_fsm,
sensor_presencia=>sensor_presencia,
clk=>clk_control_puerta,
reset=>RST,
sensor_puerta=>sensor_puerta_aux,
puerta_display=>puerta_display_top
);
inst_state_machine: state_machine generic map(N=>3) port map(
sensor_puerta_fsm=>sensor_puerta_aux,
stop_emergencia=>stop_emergencia,
reset=>RST,
clk=>CLOCK,
--sensor_presencia=>sensor_presencia,
boton_piso=>boton_bin_out,--no estoy muy seguro de si est� bien porque poseen rangos distintos
piso_actual=>piso_actual,--salida controlador pisos
motor_puerta=>motor_puerta_fsm,
motor_ascensor=>motor_ascensor_fsm,
destino_fsm=>destino_fsm,
led => led_top_fsm
);

--sensor_puerta_aux<=sensor_puerta_top;

inst_contr_pisos: Controlador_Pisos generic map (N=>3) port map(
clk=>clk_control_pisos_puerta,
reset=>RST,
motor_ascensor=>motor_ascensor_fsm,
--led_piso=>led_piso_actual,
piso_actual=>piso_actual
);

--sensor_puerta_aux<=sensor_puerta_top;
inst_decoder_motor_led: decoder_motor_led port map(
motor_ascensor=>motor_ascensor_fsm,
Led=>Led_top
);
inst_Piso_actual_display: Piso_actual_display generic map (N=>3) port map(
Piso_actual=>piso_actual,
Piso_actual_display=>piso_actual_display_top
);
inst_decoder_destino_display: decoder_destino_display generic map(N=>4) port map(
destino_fsm=>destino_fsm,
destino_display=>destino_display_top
);
inst_pta_display_decod_1: puerta_display_decoder1 port map(
puerta_display=>puerta_display_top,--PROBLEMA:puerta_display tiene 4 bits y puerta_display_top tiene 2 bits que vienen de la salida del controlador de la puerta
pta_display_1=>puerta_display_1
);
inst_pta_display_decod_2: puerta_display_decoder2 port map(
puerta_display=>puerta_display_top,--PROBLEMA:puerta_display tiene 4 bits y puerta_display_top tiene 2 bits que vienen de la salida del controlador de la puerta
pta_display_2=>puerta_display_2
);
inst_pta_display_decod_3: puerta_display_decoder3 port map(
puerta_display=>puerta_display_top,--PROBLEMA:puerta_display tiene 4 bits y puerta_display_top tiene 2 bits que vienen de la salida del controlador de la puerta
pta_display_3=>puerta_display_3
);
inst_pta_display_decod_4: puerta_display_decoder4 port map(
puerta_display=>puerta_display_top,--PROBLEMA:puerta_display tiene 4 bits y puerta_display_top tiene 2 bits que vienen de la salida del controlador de la puerta
pta_display_4=>puerta_display_4
);
inst_refresh_displays: display_refresh port map(
clk=>clk_refresh_displays,-- 50hz pero se pueden poner m�s
pta_display_1=>puerta_display_1,
pta_display_2=>puerta_display_2,
pta_display_3=>puerta_display_3,
pta_display_4=>puerta_display_4,
destino_display=>destino_display_top,
Piso_actual_display=>piso_actual_display_top,
display_selector=>display_selection,
display_number=>display_number
);



end Structural;
