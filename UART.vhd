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
	signal recibido: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
begin

	process(clk)
		variable ticks:integer := 0;
		variable position:integer := 0;
	begin
		if clk'event AND clk = '0' AND not clk'stable then
			if ticks = 5208 then -- 50 Mhz / 9600 bps
				CASE recState IS
					WHEN waiting => 
						IF rx = '0' THEN
							recState <= transmiting;
							rec_pending <= '1';
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
						END IF;
						recState <= waiting;
						rec_pending <= '0';
				END CASE;
				ticks := 0;
			ELSE
				ticks := ticks + 1;
			END IF;
		end if;
	end process;
end Behavioral;

