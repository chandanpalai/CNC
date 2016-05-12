----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:19:02 05/05/2016 
-- Design Name: 
-- Module Name:    UART - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is
    Port ( rx : in  STD_LOGIC;
           tx : out  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           brec : out  STD_LOGIC_VECTOR (7 downto 0);
           rec_pending : out  STD_LOGIC;
           rec_done : in  STD_LOGIC;
           btrans : in  STD_LOGIC_VECTOR (7 downto 0);
           tstart : in  STD_LOGIC;
           tdone : out  STD_LOGIC);
end UART;

architecture Behavioral of UART is
	type state is (waiting, transmiting, stoping);
	signal recState: state := waiting;
	signal transState: state := waiting;
	signal recibido: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
begin

	process(clk) -- Mensaje del PC a la FPGA
		variable ticks:integer := 0;
		variable position:integer := 0;
	begin
		IF clk'event AND clk = '0' THEN
			IF ticks = 5208 AND rec_pending = '0' THEN -- 50 Mhz / 9600 bps
				CASE recState IS
					WHEN waiting => 
						IF rx = '0' THEN
							recState <= transmiting;
							position := 0;
						END IF;
					WHEN transmiting => 
						IF position < 8 THEN
							recibido(position) <= rx;
							position := position + 1;
						ELSIF rx = '1' THEN
							recState <= stoping;
							position := 0;
						END IF;
					WHEN stoping =>
						IF rx = '1' THEN
							brec <= recibido;
							rec_pending <= '1';
						END IF;
						recState <= waiting;
				END CASE;
				ticks := 0;
			ELSIF rec_pending = '0'
				ticks := ticks + 1;
			ELSE
				ticks := 0;   -- Evitar que el contador siga mientra no se lea lo que hay en el vector de salida
			END IF;
			IF rec_done = '1' THEN -- Cuando se lee lo que hemos puesto en el vector de salida
				rec_pending <= '0'; -- volvemos a permitir la lectura
			END IF;
		END IF;
	end process;
	
	process(clk) -- Mensaje de la FPGA al PC
		variable ticks:integer := 0;
		variable posicion:integer := 0;
	begin
		IF clk'event AND clk = '0' AND tstart = '1' THEN
			IF ticks = 5208 THEN
				CASE transState IS
					WHEN waiting =>
						tx <= '0'; -- Comenzamos la transmision
						position := 0;
						transState <= transmiting;
					WHEN transmiting =>
						IF position < 8 THEN
							tx <= btrans(position);
							position := position + 1;
						ELSE
							tx <= '1';
							transState <= stopping;
						END IF;
					WHEN stopping =>
						tx <= '1';
						transState <= waiting;
						tdone <= '1';
				END CASE;
			END IF;
		END IF;
	end process;
end Behavioral;

