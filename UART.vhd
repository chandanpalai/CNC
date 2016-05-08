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
	signal nowState: state := waiting;
	signal recibido: STD_LOGIC_VECTOR(7 downto 0) := "000000000";
	signal start, stop: STD_LOGIC := "0";
begin

	process(clk)
		variable ticks:integer := 0;
		variable position:integer := 0;
	begin
		if clk'event AND clk then
			if ticks = 2600 then
				CASE nowState IS
					WHEN waiting => 
						IF rx = "0" THEN
							nowState:=transmiting;
						END IF;
					WHEN transmiting => 
						IF position < 8 THEN
							recibido(positon) := rx;
							position := position + 1;
						ELSIF rx = "1" THEN
							nowState:=stoping;
							position := 0;
						END IF;
					WHEN stoping =>
						IF rx = "1" THEN
							brec := recibido;
							rec_done := "1";
						END IF;
						nowState := waiting;				
				END CASE;
				ticks := 0;
			ELSE
				ticks := ticks + 1;
			END IF;
		end if;
	end process;

end Behavioral;

