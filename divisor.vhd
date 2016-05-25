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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divisor is
    Port ( dividendo : in  STD_LOGIC_VECTOR (13 downto 0);
			  in_signal : in STD_LOGIC;
           divisor : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           resultado : out  STD_LOGIC_VECTOR (7 downto 0);
			  out_signal : out STD_LOGIC;
           resto : out  STD_LOGIC_VECTOR (13 downto 0));
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
		variable contador : integer := 0;
	begin
		if rising_edge(clk) then
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
			elsif divisor = "00000000" then
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

