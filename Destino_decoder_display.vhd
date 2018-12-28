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