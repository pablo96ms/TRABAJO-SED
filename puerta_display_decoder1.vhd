----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2019 18:53:14
-- Design Name: 
-- Module Name: puerta_display_decoder1 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity puerta_display_decoder1 is
	Port (
    puerta_display : IN std_logic_vector(3 downto 0);
    pta_display_1: OUT std_logic_vector(6 downto 0)
    );
end puerta_display_decoder1;

architecture Behavioral of puerta_display_decoder1 is

begin
    with puerta_display select 

						pta_display_1 <= "1001111" when "0011",
										 "1111001" when "0010",
										 "1111111" when others; -- Todo apagado

end Behavioral;
