----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.12.2018 18:03:43
-- Design Name: 
-- Module Name: Piso_actual_display - Behavioral
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
use ieee.numeric_std.all;	
use std.textio.all;
use ieee.std_logic_textio.all;

Entity Piso_actual_display is 
    
	Generic (N: integer:= 3);

	Port (
		Piso_actual: IN std_logic_vector(N-1 downto 0);
		Piso_actual_display: OUT std_logic_vector(6 downto 0)
		);

End entity;


Architecture dataflow of Piso_actual_display is 

	Begin 

		With Piso_actual select 

					Piso_actual_display <= "0000001" when "001", -- Piso 0
									       "1001111" when "010", -- Piso 1
									       "0010010" when "011", -- Piso 2
									       "0000110" when "100", -- Piso 3
									       "1111110" when others; -- Una raya en medio en cualquier otro caso

End architecture;
