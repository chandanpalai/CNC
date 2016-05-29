----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:18:19 05/23/2016 
-- Design Name: 
-- Module Name:    Motor - Behavioral 
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
-- Uncomment the following library declaration if using.
-- arithmetic functions with Signed or Unsigned values.
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating.
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Motor is
    Port ( 
		CLK		: in   STD_LOGIC;								--Reloj.
		Rst 		: in  STD_LOGIC;								--Reset.
		Dir      : in  STD_LOGIC;								--Sentido/direccion.
      Dis      : in  STD_LOGIC_VECTOR (7 downto 0);	--Distancia total que recorrer.
      Vel      : in  STD_LOGIC_VECTOR (7 downto 0);	--Velocidad de giro.
      Ord 		: in  STD_LOGIC;								--Flag de orden recivida.
      Proc     : out  STD_LOGIC;								--Flag de orden ya procesada.
		bobina 	: out STD_LOGIC_VECTOR(3 downto 0));	--Señales para activar las bobinas del motor.
end Motor;

architecture Behavioral of Motor is
signal step : STD_LOGIC_VECTOR (2 downto 0) := (others=>'0');
signal pasos: integer;				--Sirve para controlar el correcto orden de activacion de las bobinas.
type MAQ_rec is (WAITING,START,MUEVE,WPASO,STOP);
signal recState: MAQ_rec := WAITING;
signal VEL_I : integer := 0;
constant MAXPER : integer := 10e6; -- maxima distancia entre steps (en ciclos de clk) para velocidad de 5 step/s.(1%).

begin
	
	VEL_I <= to_integer(unsigned(Vel));

	Process(STEP)
	Begin
		case STEP is								--Son las distintas secuencias de señales para activar las bobinas.
			when "000"=> bobina <= "1000";
			when "001"=> bobina <= "1100";
			when "010"=> bobina <= "0100";
			when "011"=> bobina <= "0110";
			when "100"=> bobina <= "0010";
			when "101"=> bobina <= "0011";
			when "110"=> bobina <= "0001";
			when "111"=> bobina <= "1001";
			when others => bobina <= "0000";
		end case;
	End Process;
	
	Process(CLK,Rst)
		variable retardo : integer := 0;
	Begin
		if RST = '1' then							--Comprueba si hay orden de reset.
			recState <= WAITING;
			Proc <= '0';
		elsif rising_edge(CLK) then
			case recState is
				when WAITING =>					--Esperando orden.
					Proc <= '0';
					if Ord = '1' then
						recState <= START;
					end if;
				when START =>
					if VEL_I = 0 then				--En caso de que no manden velocidad.
						Proc <= '1';
						recState <= STOP;
					else
						pasos <= to_integer(unsigned(Dis)*16); --*16 para que 255 sea aprox. una vuelta entera.
						recState <= MUEVE;
					end if;
				when MUEVE =>						--La activacion de las bobinas tienen que seguir un orden.
					if pasos /= 0 then			
						pasos <= pasos -1;
						if dir = '1' then												
							STEP <= std_logic_vector(unsigned(STEP) + 1); 	--Al ser unsigned dara vueltas dentro de los casos.Para avanzar.
						else
						 	STEP <= std_logic_vector(unsigned(STEP) - 1);	--Para retroceder.
						end if;
						retardo := MAXPER;
						recState <= WPASO;
					else										--Fianlizacion de movimiento.
						Proc <= '1';
						recState <= STOP;
					end if;
				when WPASO =>	-- Espera entre STEP y STEP para cumplir velocidad.
					if retardo > VEL_I then
						retardo := retardo - VEL_I;
					else
						recState <= MUEVE;
					end if;
				when STOP =>								--Espera que los flags del secuenciador se pongan a 0.
					if Ord = '0' then
						recState <= WAITING;
					end if;
				when others =>
					recState <= WAITING;
			end case;
		end if;
	End process;
	
end Behavioral;

