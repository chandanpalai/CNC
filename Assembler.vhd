----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:30:33 05/22/2016 
-- Design Name: 
-- Module Name:    Assembler - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Assembler is
    Port ( clk: in STD_LOGIC;
			  Brec : in  STD_LOGIC_VECTOR (7 downto 0);
           rec_pending : in  STD_LOGIC;
           Btrans : out   STD_LOGIC_VECTOR(7 downto 0);
           Tstart : out  STD_LOGIC;
           t_done : in  STD_LOGIC;
			  rec_done : out  STD_LOGIC;
           Instruccion : out  STD_LOGIC_VECTOR (1 downto 0);
           DatoX : out  STD_LOGIC_VECTOR (7 downto 0);
           DatoY : out  STD_LOGIC_VECTOR (7 downto 0);
           DatoZ : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end Assembler;

architecture Behavioral of Assembler is

--variables y señales
type state is ( waiting, recta, calculo ,dx, dy, dz, reset, halt);
signal estado: state:= waiting;
signal i_dato_x, i_dato_y, i_dato_z: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
constant letra_o: std_logic_vector (7 downto 0) := x"4b";
constant letra_k: std_logic_vector(7 downto 0):= x"4f";
--signal instruc : STD_LOGIC_VECTOR(1 downto 0);

--variables y señales

BEGIN

	DatoX <= i_dato_x;
	DatoY <= i_dato_y;
	DatoZ <= i_dato_z;

	process(clk)
	--variables y señales
	variable contador,num_datos: integer:=0;
	variable dato: integer range 0 to 255:=0;
	variable resultado_entero3,resultado_entero2,resultado_entero1, total: integer range 0 to 255:=0;
	variable resul_unsig: unsigned(7 downto 0):=(others=>'0');
	--variables y señales
	BEGIN
		IF (RISING_EDGE(CLK)) THEN
		
			IF rec_pending = '0' THEN
			
				CASE estado IS
					
					WHEN waiting =>
						
						CASE brec IS
						WHEN "01010011" => --RECTA 10
								--instruccion<="01";
								estado<=recta;

						WHEN "01010010" => --RESET 00
						
								estado<= reset;
						WHEN "01001000" => --HALT  11
								estado<= halt;
						WHEN OTHERS => --OTHERS
								estado<=waiting;
						END CASE;
						
					WHEN recta => --RECTA
					instruccion<="01";
						if Brec(7 downto 4) = "0011" then
						estado<=calculo;
						dato:= to_integer (unsigned(brec(3 downto 0)));
						else estado<=waiting;
						end if;
					WHEN calculo =>
					
						case contador is
							when 0 =>
								resultado_entero3:=dato*100;  --dato x 100
								estado<=recta;
								contador:=contador+1;
							when 1 =>

								dato:=to_integer(unsigned(brec(3 downto 0)));
								resultado_entero2:=dato*10;  --dato x 10
								contador:=contador+1;
								estado<=recta;
							when 2 =>
								dato:=to_integer(unsigned(brec(3 downto 0)));
								resultado_entero1:=dato; -- dato
								contador:=contador+1;
								estado<=recta;
							when 3 =>
								dato:=to_integer(unsigned(brec(3 downto 0)));
								resultado_entero1:=dato;
								if num_datos = 0 then
								estado<=dx;
								contador:=0;
								elsif num_datos = 1 then
								estado<=dy;
								contador:=0;
								elsif num_datos = 2 then 
								estado<=dz;
								contador:=0;
								end if;
							when others =>
							estado <= waiting;
						end case;						
					WHEN dx =>
						rec_done<='1';
						dato:=to_integer(unsigned(brec(3 downto 0)));
						resultado_entero1:=dato;
						total:=resultado_entero1+resultado_entero2+resultado_entero3;
						i_dato_x<=std_logic_vector(to_unsigned(total,i_dato_x'length) srl 0);
						num_datos:=num_datos+1;
						estado<=recta;
					WHEN dy =>
						rec_done<='1';
						resultado_entero1:=dato;
						total:=resultado_entero1+resultado_entero2+resultado_entero3;
						i_dato_y<=std_logic_vector(to_unsigned(total,i_dato_y'length) srl 0);
						num_datos:=num_datos+1;
						estado<=recta;
					WHEN dz =>
						dato:=to_integer(unsigned(brec(3 downto 0)));
						rec_done<='1';
						resultado_entero1:=dato;
						total:=resultado_entero1+resultado_entero2+resultado_entero3;
						i_dato_z<=std_logic_vector(to_unsigned(total,i_dato_z'length) srl 0);
						estado<=waiting;
					WHEN reset => --RESET
						instruccion <= "00";						
						rec_done<='1';
						estado<=waiting;
						
					WHEN halt => --HALT
						instruccion <= "11";						
						rec_done<='1';	
						estado<=waiting;
						
				END CASE;
			END IF;--IF DEL REC_PENDING
		END IF;--IF DEL CLK
	END PROCESS;
	transmitir: process(t_done)
	variable ticks : integer range 0 to 512:=0;
	
	begin
		if t_done = '0' then
			if ticks < 0 then
				tstart<='1';
				btrans<=letra_o;
				ticks:=ticks+1;
			end if;
			btrans<=letra_k;
			tstart<='0';
			ticks:=0;
		end if;
	end process;
	
END BEHAVIORAL;