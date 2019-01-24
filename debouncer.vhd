
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
end Behavioral;
