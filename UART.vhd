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
	type state is (waiting, transmiting, stop);
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
				if start = "0" AND rx = "0" then
					start := "1";
				elsif stop = "0" AND start = "1" AND position < 8 then
					recibido(position) := rx;
					position := position + 1;
				elsif rx = "1" then
					stop := "1";
				elsif stop = "1" then
					brec := recibido;
					position := 0;
					start := "0";
				end if;
				ticks := 0;
			end if;
			ticks := ticks + 1;
		end if;
	end process;

end Behavioral;

