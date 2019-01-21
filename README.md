# TRABAJO-SED
Aquí iremos poniendo los progresos que vayamos haciendo en el trabajo, de manera que podamos ver las intervenciones, aportaciones o sugerencias de cada uno. 

MÁQUINA DE ESTADOS
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity elevator is
generic(n:positive:=2);
    Port ( boton : in std_logic_vector(n downto 0);
             clk: in STD_LOGIC;
           reset_n: in STD_LOGIC;--siempre que se active reset volvemos al piso 0
           piso : out STD_LOGIC_VECTOR(n downto 0));
end elevator;

architecture Behavioral of elevator is

type state_type is(p0,p1,p2,p3,p4);
signal actual,siguiente:state_type;--estado actual y estado siguiente
signal bot:std_logic_vector(n downto 0);--almacena el boton pulsado

begin

sync_proc:process(clk,reset_n)--bloque secuencial para calcular el estado siguiente
    begin
    if (rising_edge(clk)) then
        if(reset_n='1') then
            actual<=p0;
        else 
            actual<=siguiente;
        end if;
    end if;
end process;

output_decode:process(actual)--bloque dataflow para actualizar el estado actual
begin
case(actual)is
when p0=>piso<="000";
when p1=>piso<="001";
when p2=>piso<="010";
when p3=>piso<="011";
when p4=>piso<="100";
when others=>piso<="000";
end case;
end process;

next_state_decode:process(actual,boton)
begin
siguiente<=p0;
case(actual) is
when p0=>
if(boton="000") then
siguiente<=p0;
end if;
if(boton="001") then
siguiente<=p1;
end if;
if(boton="010") then
siguiente<=p2;
end if;
if(boton="00011") then
siguiente<=p3;
end if;
if(boton="100") then
siguiente<=p4;
end if;

when p1=>
if(boton="000") then
siguiente<=p0;
end if;
if(boton="001") then
siguiente<=p1;
end if;
if(boton="010") then
siguiente<=p2;
end if;
if(boton="011") then
siguiente<=p3;
end if;
if(boton="100") then
siguiente<=p4;
end if;

when p2=>
if(boton="000") then
siguiente<=p0;
end if;
if(boton="001") then
siguiente<=p1;
end if;
if(boton="010") then
siguiente<=p2;
end if;
if(boton="011") then
siguiente<=p3;
end if;
if(boton="100") then
siguiente<=p4;
end if;

when p3=>
if(boton="000") then
siguiente<=p0;
end if;
if(boton="001") then
siguiente<=p1;
end if;
if(boton="010") then
siguiente<=p2;
end if;
if(boton="011") then
siguiente<=p3;
end if;
if(boton="100") then
siguiente<=p4;
end if;

when p4=>
if(boton="000") then
siguiente<=p0;
end if;
if(boton="001") then
siguiente<=p1;
end if;
if(boton="010") then
siguiente<=p2;
end if;
if(boton="011") then
siguiente<=p3;
end if;
if(boton="100") then
siguiente<=p4;
end if;

when others=>siguiente<=p0;
end case;
end process;



end Behavioral;



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

entity elevator_tb is
--  Port ( );
end elevator_tb;

architecture Behavioral of elevator_tb is
    component elevator is
    generic(n:positive:=2);
        Port ( boton : in std_logic_vector(n downto 0);
                clk: in STD_LOGIC;
                reset_n: in STD_LOGIC;--siempre que se active reset volvemos al piso 0
                piso : out STD_LOGIC_VECTOR(n downto 0));
    end component;
    
    signal boton_int:std_logic_vector(2 downto 0):="000";
    signal clk_int:std_logic:='0';
    signal reset_int:std_logic:='0';
    signal piso_int:std_logic_vector(2 downto 0):="000";
    
    begin
    inst_elevator:elevator port map(
    boton=>boton_int,
    clk=>clk_int,
    reset_n=>reset_int,
    piso=>piso_int
);
clk_int<= NOT clk_int after  30ns;
reset_int<='0','1' after 40 ns, '0' after 60 ns,'1' after 80 ns,'0' after 100 ns;
process
begin
wait for 40 ns;
boton_int<="000";
wait for 20 ns;
boton_int<="010";
wait for 50 ns;
boton_int<="100";
wait for 30 ns;
boton_int<="011";
wait for 50 ns;
boton_int<="011";
end process;


end Behavioral;



MÓDULO ANTIRREBOTES
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_out : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
signal Q1,Q2,Q3:std_logic;
begin
process(clk)
begin
if(clk'event and clk='1') then
if(rst='0') then
Q1<='0';
Q2<='0';
Q3<='0';
else
Q1<=btn_in;
Q2<=Q1;
Q3<=Q2;
end if;
end if;
end process;
btn_out<=Q1 and Q2 and (not Q3);
end Behavioral


SINCRONIZADOR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sincronizador is
    Port ( sync_in : in STD_LOGIC;
           clk : in STD_LOGIC;
           sync_out : out STD_LOGIC);
end sincronizador;

architecture Behavioral of sincronizador is
constant SYNC_STAGES : integer := 3;
constant PIPELINE_STAGES : integer := 1;
constant INIT : std_logic := '0';
signal sreg : std_logic_vector(SYNC_STAGES-1 downto 0) := (others => INIT);
attribute async_reg : string;
attribute async_reg of sreg : signal is "true";
signal sreg_pipe : std_logic_vector(PIPELINE_STAGES-1 downto 0) := (others => INIT);
attribute shreg_extract : string;
attribute shreg_extract of sreg_pipe : signal is "false";

begin
process(clk)
begin
if(clk'event and clk='1')then
sreg <= sreg(SYNC_STAGES-2 downto 0) & sync_in;
end if;
end process;
no_pipeline : if PIPELINE_STAGES = 0 generate
begin
sync_out <= sreg(SYNC_STAGES-1);
end generate;
one_pipeline : if PIPELINE_STAGES = 1 generate
begin
process(clk)
begin
if(clk'event and clk='1') then
sync_out <= sreg(SYNC_STAGES-1);
end if;
end process;
end generate;
multiple_pipeline : if PIPELINE_STAGES > 1 generate
begin
process(clk)
begin
if(clk'event and clk='1') then
sreg_pipe <= sreg_pipe(PIPELINE_STAGES-2 downto 0) & sreg(SYNC_STAGES-1);
end if;
end process;
sync_out <= sreg_pipe(PIPELINE_STAGES-1);
end generate;

end Behavioral



DIVISOR DE FRECUENCIA
entity clk_divider is
generic(n:positive:=1000000);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clk_divider;

architecture Behavioral of clk_divider is
    signal temp:std_logic;--para gestionar el estado de la señal de salida
    signal counter:integer range 0 to n-1:=0;--contador que lleva la cuenta del número de cambios de estado de ña entrada de reloj
    begin
        process(clk,reset)
            begin
            if(reset='1')then
                temp<='0';
                counter<=0;
            elsif rising_edge(clk)then
                if(counter=n-1)then
                    temp<=not (temp);
                    counter<=0;
                else
                counter<=counter + 1;
                end if;
            end if;
         end process;
clk_out<=temp;

end Behavioral;







NUEVA MÁQUINA DE ESTADOS

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

entity elevator is
generic(n:positive:=2);
    Port ( piso: in std_logic_vector(n downto 0);--piso al que el usuario desea ir mediante 4 botones
             clk, nivel, reset_n: in STD_LOGIC;--siempre que se active reset volvemos al piso 0
           puerta: out std_logic;--abierta(0), cerrada(1)
           count:out std_logic_vector(n-1 downto 0);
           motor: out std_logic_vector(1 downto 0);--parado(00), bajando(01), subiendo(10), en marcha(11)
           piso_destino : in STD_LOGIC_VECTOR(n downto 0));--piso en el que el ascensor está en momento dado(debe ser in)
end elevator;

architecture Behavioral of elevator is
type state_type is(p0,p1,p2,p3,p4,parado,bajando,subiendo,en_marcha,inicial,abriendo,cerrando);--definición de los estados tanto de la puerta como del motor
signal actual,siguiente:state_type;--estado actual y estado siguiente
signal bot:std_logic_vector(n downto 0);--almacena el boton pulsado
signal piso_ini:std_logic_vector(n downto 0);--piso en el que se está actualmente
signal temp:std_logic_vector(n-1 downto 0):="00";

begin

sync_proc:process(clk,reset_n)--bloque secuencial para calcular el estado siguiente
    begin
    if (reset_n='1') then
        actual<=inicial;
        elsif(rising_edge(clk))then
            case(actual)is
                when inicial=> --primer estado en el que se encuentra el ascensor, queremos que inicialmente solamente se nivele
                    if nivel='1' then
                        actual<=parado;
                    end if;
                when parado=> --esperamos la pulsación de un botón
                    if ((bot/="000") and (bot/=piso_destino))then --el operador "/=" devuelve un valor booleano
                        actual<=cerrando;
                            puerta<='0';--abierta
                    end if;
                when cerrando=>
                    puerta<='1'; --se cierra la puerta
                    actual<=en_marcha;
                when en_marcha=> --el ascensor va hacia el piso deseado
                    if((bot=piso_destino) and (nivel='1'))then
                        actual<=abriendo;
                    end if;
                when abriendo=> --se abre la puerta del ascensor
                    puerta<='0';
                    actual<=parado;
                when others=>
                    puerta<='1';
                    actual<=parado;
            end case;
    end if;
end process;


salida:process(piso)
       begin
        case(actual)is
            when inicial=> --al iniciar el funcionamiento, es posible que el ascensor esté entre dos pisos
                if(piso="001")then
                    motor<="01";--bajando
                else
                    motor<="10";--subiendo
                end if;
                puerta<='0';--abierta
             when parado=>
                motor<="00";--parado
                puerta<='0';--abierta
             when cerrando=>
                motor<="00";--parado
                --¿qué podemos hacer para indicar que la puerta puede estar abierta o cerrada?
                if(rising_edge(clk))then
                    if temp="11" then
                        temp<="00";
                        puerta<='1';--puerta cerrada
                    else 
                        temp<=temp+1;
                        puerta<='0';--puerta abierta
                    end if;
                 end if;
                
                
                when en_marcha=>
                    if(bot<piso_ini)then --si el piso al que quiero ir está por debajo del piso en el que estoy, entonces bajo
                        motor<="01";--bajar
                    else
                        motor<="10";--subir
                    end if;
                    puerta<='1';--puerta cerrada
                when abriendo=>
                    motor<="00";--motor parado
                    puerta<='0';--abrir puerta
            end case;
end process;
                    
                
                
memoria:process(reset_n,clk) --en este process queremos capturar la pulsación del botón y el piso deonde se encuentra
        begin
            if reset_n='1' then
                bot<="000";
                piso_ini<=piso_destino;
            elsif rising_edge(clk)then
                if actual=parado then
                    if((bot="001")or(bot="010")or(bot="011")or(bot="100"))then
                    bot<=piso;
                    else
                        bot<="000"; --cualquier otra combinación no vale
                    end if;
                    piso_ini<=piso;
                end if;
            end if;
        end process;
            
            



end Behavioral;










ENTIDAD_TOP_FINAL Y TESTBENCH

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( sensor_presencia : in STD_LOGIC;
           reset : in STD_LOGIC;
           stop_emergencia : in STD_LOGIC;
           botones : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           clk : in STD_LOGIC;
           display_number : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           Led_top: out STD_LOGIC_VECTOR(6 DOWNTO 0);
           display_selection : out STD_LOGIC_VECTOR(5 DOWNTO 0));
end top;

architecture Structural of top is

signal boton_bin_out: std_logic_vector(2 downto 0);
signal clk_control_pisos_puerta: std_logic;
signal clk_refresh_displays: std_logic;
signal destino_fsm: std_logic_vector(2 downto 0);
signal motor_puerta_fsm, motor_ascensor_fsm:std_logic_vector(1 downto 0);
signal piso_actual: std_logic_vector(2 downto 0);
signal puerta_display_top: std_logic_vector(3 downto 0);
signal sensor_puerta_top: std_logic;
signal piso_actual_display_top: std_logic_vector(6 downto 0);
signal destino_display_top: std_logic_vector(6 downto 0);
signal puerta_display_1: std_logic_vector(6 downto 0);
signal puerta_display_2: std_logic_vector(6 downto 0);
signal puerta_display_3: std_logic_vector(6 downto 0);
signal puerta_display_4: std_logic_vector(6 downto 0);



    component clk_divider is
        generic(n:positive:=1000000);
            Port ( clk : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   clk_out : out STD_LOGIC);
    end component;
    
    component Controlador_Pisos is
            generic(N:natural:=3);
                Port ( clk : in STD_LOGIC;
                       reset : in STD_LOGIC;
                       motor_ascensor : in STD_LOGIC_VECTOR (N-2 downto 0);
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
            clk: IN std_logic; -- clk de más o menos 60 Hz o más 
            pta_display_1, pta_display_2, pta_display_3, pta_display_4: IN std_logic_vector(6 downto 0);
            destino_display: IN std_logic_vector(6 downto 0);
            Piso_actual_display: IN std_logic_vector(6 downto 0);
            display_selector: OUT std_logic_vector(5 downto 0);
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
                sensor_puerta, stop_emergencia, reset, clk, sensor_presencia : IN std_logic;
                -- sensor_puerta : 1 cerrada/ 0 abierta
                -- sensor_presencia : 1 presencia/ 0 nadie 
                -- Discutir la frecuencia del clk
                --sensor_apertura: IN std_logic; 
                boton_piso, piso_actual : IN std_logic_vector(N-1 downto 0); 
                motor_puerta, motor_ascensor: OUT std_logic_vector(1 downto 0);
                destino_fsm: OUT std_logic_vector (N-1 downto 0)
                );
        
        End component;    
    
    
begin

inst_input_decoder: input_decoder generic map(N=>4) port map(
boton_placa=>botones,
boton_bin=>boton_bin_out
);
inst_clk_divider_control_pisos_puerta: clk_divider generic map (n=>100000000) port map(
clk=>clk,
reset=>reset,
clk_out=>clk_control_pisos_puerta
);
inst_clk_divider_refresh_displays: clk_divider generic map(n=>2000000) port map(--frecuencia de 50hz pero se puede poner más sin problema
clk=>clk,
reset=>reset,
clk_out=>clk_refresh_displays
);
inst_state_machine: state_machine generic map(N=>3) port map(
sensor_puerta=>sensor_puerta_top,
stop_emergencia=>stop_emergencia,
reset=>reset,
clk=>clk,
sensor_presencia=>sensor_presencia,
boton_piso=>boton_bin_out,--no estoy muy seguro de si está bien porque poseen rangos distintos
piso_actual=>piso_actual,--salida controlador pisos
motor_puerta=>motor_puerta_fsm,
motor_ascensor=>motor_ascensor_fsm,
destino_fsm=>destino_fsm
);
inst_contr_pisos: Controlador_Pisos generic map (N=>3) port map(
clk=>clk_control_pisos_puerta,
reset=>reset,
motor_ascensor=>motor_ascensor_fsm,
piso_actual=>piso_actual
);
inst_contr_puerta: Controlador_Puerta port map(
motor_puerta=>motor_puerta_fsm,
sensor_presencia=>sensor_presencia,
clk=>clk_control_pisos_puerta,
reset=>reset,
sensor_puerta=>sensor_puerta_top,
puerta_display=>puerta_display_top
);
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
clk=>clk_refresh_displays,-- 50hz pero se pueden poner más
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





TESTBENCH

library ieee;
use ieee.std_logic_1164.all;

entity tb_top is
end tb_top;

architecture tb of tb_top is

    component top
        port (sensor_presencia  : in std_logic;
              reset             : in std_logic;
              stop_emergencia   : in std_logic;
              botones           : in std_logic_vector (3 downto 0);
              clk               : in std_logic;
              display_number    : out std_logic_vector (6 downto 0);
              Led_top           : out std_logic_vector (6 downto 0);
              display_selection : out std_logic_vector (5 downto 0));
    end component;

    signal sensor_presencia  : std_logic;
    signal reset             : std_logic;
    signal stop_emergencia   : std_logic;
    signal botones           : std_logic_vector (3 downto 0);
    signal clk               : std_logic;
    signal display_number    : std_logic_vector (6 downto 0);
    signal Led_top           : std_logic_vector (6 downto 0);
    signal display_selection : std_logic_vector (5 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top
    port map (sensor_presencia  => sensor_presencia,
              reset             => reset,
              stop_emergencia   => stop_emergencia,
              botones           => botones,
              clk               => clk,
              display_number    => display_number,
              Led_top           => Led_top,
              display_selection => display_selection);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        sensor_presencia <= '0';
        stop_emergencia <= '0';
        botones <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top of tb_top is
    for tb
    end for;
end cfg_tb_top;

