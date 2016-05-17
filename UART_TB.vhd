--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:45:08 05/14/2016
-- Design Name:   
-- Module Name:   /home/domi/CNC/UART_TB.vhd
-- Project Name:  CNC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY UART_TB IS
END UART_TB;
 
ARCHITECTURE behavior OF UART_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART
    PORT(
         rx : IN  std_logic;
         tx : OUT  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         brec : OUT  std_logic_vector(7 downto 0);
         rec_pending : OUT  std_logic;
         rec_done : IN  std_logic;
         btrans : IN  std_logic_vector(7 downto 0);
         tstart : IN  std_logic;
         tdone : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rx : std_logic := '1';
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal rec_done : std_logic := '0';
   signal btrans : std_logic_vector(7 downto 0) := (others => '0');
   signal tstart : std_logic := '0';

 	--Outputs
   signal tx : std_logic;
   signal brec : std_logic_vector(7 downto 0);
   signal rec_pending : std_logic;
   signal tdone : std_logic;

	signal data : std_logic_vector(7 downto 0) := X"55";
	signal data_to_send : std_logic_vector(7 downto 0) := X"10";
	
   -- Clock period definitions
   constant clk_period : time := 20 ns;
	constant TBIT	: time := 1 sec/9600;	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART PORT MAP (
          rx => rx,
          tx => tx,
          clk => clk,
          rst => rst,
          brec => brec,
          rec_pending => rec_pending,
          rec_done => rec_done,
          btrans => btrans,
          tstart => tstart,
          tdone => tdone
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	process
	begin
		wait for 20 ns;
		if rec_pending = '1' then
			wait for 1 ms;
			rec_done <= '1';
		else
			rec_done <= '0';
		end if;
		if tdone = '1' then -- transfer tests
			wait for 1 ms;
			tstart <= '0';
		elsif tstart = '0' then
			wait for 100 ns;
			btrans <= data_to_send;
			wait for 100ns;
			tstart <= '1';
		end if;
	end process;
	

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST <= '0';	-- quito reset.
      wait for clk_period*10;
      -- insert stimulus here 
		for j in 0 to 5 loop
			rx <= '0';
			wait for TBIT;
			for i in 0 to 7 loop
				rx <= data(i);
				wait for TBIT;
			end loop;
			rx <= '1';
			wait for (2*TBIT);
			data <= std_logic_vector(unsigned(data) + 1);
		end loop;
		wait for clk_period*100;
		assert false report "Fin test" severity failure;
      wait;
   end process;

END;
