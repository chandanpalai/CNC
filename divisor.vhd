----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:17:01 05/21/2016 
-- Design Name: 
-- Module Name:    divisor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Divisor de dos vectores por restas sucesivas
entity divisor is
	Port ( 
		dividendo	: in  STD_LOGIC_VECTOR (13 downto 0); -- dividendo
		in_signal 	: in STD_LOGIC; -- senal que marca el comienzo de la operacion
		divisor 		: in  STD_LOGIC_VECTOR (7 downto 0); -- divisor
		clk 			: in  STD_LOGIC; -- reloj
		resultado 	: out  STD_LOGIC_VECTOR (7 downto 0); -- resultado de la operacion
		out_signal 	: out STD_LOGIC; -- flag de completado
		resto 		: out  STD_LOGIC_VECTOR (13 downto 0) -- resto de la operacion
	);
end divisor;

architecture Behavioral of divisor is
	signal i_resto : STD_LOGIC_VECTOR (13 downto 0) := (others => '0');
	signal i_resultado : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_out_signal : STD_LOGIC := '0';
begin
	resultado <= i_resultado;
	resto <= i_resto;
	out_signal <= i_out_signal;
	process(clk)
		variable contador : integer := 0; -- contador de restas
	begin
		if rising_edge(clk) then
			-- Controlamos que empiece y que no sea division por cero
			if(in_signal = '1' and i_out_signal = '0' and divisor /= "00000000") then
				if contador = 0 then
					i_resto <= dividendo;
					contador := contador + 1;
				elsif (unsigned(i_resto) < unsigned(divisor)) then
					i_resultado <= std_logic_vector(to_unsigned(contador - 1, i_resultado'length));
					i_out_signal <= '1';
				else
					i_resto <= std_logic_vector(unsigned(i_resto) - unsigned(divisor));
					contador := contador +1;
				end if;
			elsif in_signal = '1' and divisor = "00000000" then
				-- si la division es por cero marcamos como completado y salimos
				i_out_signal <= '1';
			elsif i_out_signal = '1' and in_signal = '0' then
				contador := 0;
				i_resto <= (others => '0');
				i_resultado <= (others => '0');
				i_out_signal <= '0';
			end if;
		end if;
	end process;
end Behavioral;

