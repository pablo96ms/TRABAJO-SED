library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divider is
generic(n:positive:=100000000);-- frecuencia del reloj 100Mhz
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clk_divider;

architecture Behavioral of clk_divider is
    signal temp:std_logic;--para gestionar el estado de la se�al de salida
    signal counter:integer range 0 to n-1:=0;--contador que lleva la cuenta del n�mero de cambios de estado de �a entrada de reloj
    begin
        process(clk,reset)
            begin
            if(reset='0')then
                temp<='0';
                counter<=0;
            elsif (rising_edge(clk))then
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
