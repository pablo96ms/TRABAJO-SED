----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.12.2018 18:41:43
-- Design Name: 
-- Module Name: input_decoder - Behavioral
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


Entity input_decoder is 
    
    Generic (N: natural := 4); -- Numero de pisos, por cada piso un boton 
	Port (
		boton_placa: IN std_logic_vector(N-1 downto 0);
		boton_bin: OUT std_logic_vector(2 downto 0)
		);
End entity;


Architecture dataflow of input_decoder is 

Begin 
	
	With boton_placa select 

					boton_bin <= "001" when "0001",
								 "010" when "0010", 
								 "011" when "0100",
								 "100" when "1000", 
								 "000" when others;

End architecture;
