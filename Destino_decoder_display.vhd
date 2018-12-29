use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;


Entity decoder_destino_display is 

	Generic (N: integer:= 4);

	Port (
		destino_fsm: IN std_logic_vector(N-1 downto 0);
		destino_display: OUT std_logic_vector(6 downto 0)
		);

End entity;


Architecture dataflow of decoder_destino_display is 

	Begin 

		With destino_fsm select 

					destino_display <= "1111110" when "001", -- Piso 0
									   "1001111" when "010", -- Piso 1
									   "0010010" when "011", -- Piso 2
									   "0000110" when "100", -- Piso 3
									   "1111110" when others; -- Una raya en medio en cualquier otro caso

End architecture;
	
	
	
	--TESTBENCH
	
	library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_destino_display_tb is
--  Port ( );
end decoder_destino_display_tb;

architecture Behavioral of decoder_destino_display_tb is

    component decoder_destino_display is 

	   Generic (N: integer:= 4);

	   Port (
		  destino_fsm: IN std_logic_vector(N-2 downto 0);
		  destino_display: OUT std_logic_vector(6 downto 0)
		);

    End component;
    
    signal destino_fsm_tb: std_logic_vector(2 downto 0):="000";
    signal destino_display_tb: std_logic_vector(6 downto 0);
    
        begin
            inst_decoder:decoder_destino_display PORT MAP(
                destino_fsm=>destino_fsm_tb,
                destino_display=>destino_display_tb
                );
        process
            begin
                wait for 30ns;
                destino_fsm_tb<="001";
                wait for 60ns;
                destino_fsm_tb<="010";
                wait for 90ns;
                destino_fsm_tb<="011";
                wait for 120ns;
                destino_fsm_tb<="100";
                wait for 150ns;
                destino_fsm_tb<="111";
                
        end process;
        


end Behavioral;
