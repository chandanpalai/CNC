--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:51:30 05/09/2016
-- Design Name:   
-- Module Name:   D:/IS/CNC/UARTTest.vhd
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY UARTTest IS
END UARTTest;
 
ARCHITECTURE behavior OF UARTTest IS 
 
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
   signal rx : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal rec_done : std_logic := '0';
   signal btrans : std_logic_vector(7 downto 0) := (others => '0');
   signal tstart : std_logic := '0';

 	--Outputs
   signal tx : std_logic;
   signal brec : std_logic_vector(7 downto 0);
   signal rec_pending : std_logic;
   signal tdone : std_logic;
 
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

	clk <= not clk after 0.5 ns;
	rx <= '1' after 2 ns,
			'0' after 5203 ns,
			'1' after 10415 ns,
			'1' after 15621 ns,
			'0' after 20832 ns,
			'1' after 26040 ns,
			'0' after 31208 ns,
			'1' after 46872 ns;
END;
