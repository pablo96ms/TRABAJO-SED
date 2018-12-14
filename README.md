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
