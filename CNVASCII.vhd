----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:10:21 05/21/2016 
-- Design Name: 
-- Module Name:    CNVASCII - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--		convierte un dato binario a tres datos ascii.
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

entity CNVASCII is
	port (
		CLK	: in std_logic;
		dato : in std_logic_vector(7 downto 0);
		startcnv : in std_logic;
		fincnv : out std_logic;
		ASCII_0 : out std_logic_vector(7 downto 0);
		ASCII_1 : out std_logic_vector(7 downto 0);
		ASCII_2 : out std_logic_vector(7 downto 0)
		);
end entity CNVASCII;

architecture comportamiento of CNVASCII is

	type MAQ_CNV is(IDLE,CALCULO,FIN);
	signal STCNV : MAQ_CNV := IDLE;
	
	signal datobcddec	: integer;
	signal datobcdcent	: integer;

begin

	process(clk)
		variable dato_tmp : integer;
	begin
		if rising_edge(CLK) then
			case STCNV is
				when IDLE =>
					fincnv <= '0';
					if startcnv = '1' then
						datobcddec <= 0;
						datobcdcent <= 0;
						dato_tmp := to_integer(unsigned(dato));
						STCNV <= CALCULO;
					end if;
				when CALCULO =>
					if dato_tmp < 10 then
						dato_tmp := dato_tmp + 48;
						ASCII_0 <= std_logic_vector(to_unsigned(dato_tmp,8));
						dato_tmp := datobcddec + 48;
						ASCII_1 <= std_logic_vector(to_unsigned(dato_tmp,8));
						dato_tmp := datobcdcent + 48;
						ASCII_2 <= std_logic_vector(to_unsigned(dato_tmp,8));
						fincnv <= '1';
						STCNV <= FIN;
					else
						if datobcddec = 9 then
							datobcddec <= 0;
							datobcdcent <= datobcdcent + 1;
						else
							datobcddec <= datobcddec + 1;
						end if;
						dato_tmp := dato_tmp - 10;
					end if;
				when FIN =>
					if startcnv = '0' then
						STCNV <= IDLE;
					end if;
				when others =>
					STCNV <= IDLE;
			end case;
		end if;
	end process;
	
end comportamiento;

