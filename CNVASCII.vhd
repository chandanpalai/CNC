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
--		La conversion se realiza decrementando de 10 en 10
--		el dato e incrementando las decenas hasta que el residuo
--		es inferior a 10.
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
		CLK	: in std_logic;									--Reloj.
		dato : in std_logic_vector(7 downto 0);			--Numero en binario que se desea transformar.
		startcnv : in std_logic;								--Flag de iniciacion.
		fincnv : out std_logic;									--Flag de fin de conversion.
		ASCII_0 : out std_logic_vector(7 downto 0);		--Primer digito transformacion en ASCII.
		ASCII_1 : out std_logic_vector(7 downto 0);		--Segundo digito transformacion en ASCII.
		ASCII_2 : out std_logic_vector(7 downto 0)		--Tercero digito transformacion en ASCII.
		);
end entity CNVASCII;

architecture comportamiento of CNVASCII is

	type MAQ_CNV is(IDLE,CALCULO,FIN);
	signal STCNV : MAQ_CNV := IDLE;
	
	signal datobcddec	: integer;								--Decenas Del numero en bcd.
	signal datobcdcent	: integer;							--Centenas del numero en bcd.

begin

	process(clk)
		variable dato_tmp : integer;
	begin
		if rising_edge(CLK) then
			case STCNV is
				when IDLE =>										--Espera a iniciar alguna conversion
					fincnv <= '0';									--Baja el flag de finalizacion a 0.
					if startcnv = '1' then						--Espera a que el flag de iniciacion se ponga a 1, empieza la conversion.
						datobcddec <= 0;
						datobcdcent <= 0;
						dato_tmp := to_integer(unsigned(dato));
						STCNV <= CALCULO;
					end if;
				when CALCULO =>
					if dato_tmp < 10 then						--No puede reducir mas el DatoTmp.
						dato_tmp := dato_tmp + 48;				-- DatoTmp coincidira con las unidades, 48 es 0 en ASCII.
						ASCII_0 <= std_logic_vector(to_unsigned(dato_tmp,8));
						dato_tmp := datobcddec + 48;			-- DatoTmp son las decenas.
						ASCII_1 <= std_logic_vector(to_unsigned(dato_tmp,8));
						dato_tmp := datobcdcent + 48;			-- DatoTmp son las Centenas.
						ASCII_2 <= std_logic_vector(to_unsigned(dato_tmp,8));
						fincnv <= '1';									--Sube el flag de finalizacion a 1.
						STCNV <= FIN;									--Termina la conversion.
					else
						if datobcddec = 9 then						--Al Sumarle 1 a las dec, alcanza 10, se pone a 0 y accarrea 1 a las cent.
							datobcddec <= 0;
							datobcdcent <= datobcdcent + 1;
						else
							datobcddec <= datobcddec + 1;			--Las dec son menor a 9 y no hay posible acarreo, luego aumenta en 1.
						end if;
						dato_tmp := dato_tmp - 10;					--Se reduce en 10 DatoTmp.
					end if;
				when FIN =>												--Espera a que el flag de iniciacion se ponga a 0.
					if startcnv = '0' then
						STCNV <= IDLE;
					end if;
				when others =>
					STCNV <= IDLE;
			end case;
		end if;
	end process;
	
end comportamiento;

