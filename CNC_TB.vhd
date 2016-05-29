--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:23:49 05/27/2016
-- Design Name:   
-- Module Name:   M:/IS/CNC/CNC_TB.vhd
-- Project Name:  CNC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CNC
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
 
ENTITY CNC_TB IS
END CNC_TB;
 
ARCHITECTURE behavior OF CNC_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CNC
    PORT(
         rx : IN  std_logic;
         tx : OUT  std_logic;
         clk : IN  std_logic;
         reset : IN  std_logic;
         leds : OUT  std_logic_vector(7 downto 0);
         bobina_x : OUT  std_logic_vector(3 downto 0);
         bobina_y : OUT  std_logic_vector(3 downto 0);
         bobina_z : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rx : std_logic := '1';
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';

 	--Outputs
   signal tx : std_logic;
   signal leds : std_logic_vector(7 downto 0);
   signal bobina_x : std_logic_vector(3 downto 0);
   signal bobina_y : std_logic_vector(3 downto 0);
   signal bobina_z : std_logic_vector(3 downto 0);

   -- Clock period definitions
	constant clk_period : time := 20 ns;
	constant TBIT	: time := 1 sec/9600;	
	
	constant instruccion : std_logic_vector(7 downto 0) := X"53";
	constant datoX1 : std_logic_vector(7 downto 0) := X"30";
	constant datoX2 : std_logic_vector(7 downto 0) := X"32";
	constant datoX3 : std_logic_vector(7 downto 0) := X"33";
	
	constant datoY1 : std_logic_vector(7 downto 0) := X"30";
	constant datoY2 : std_logic_vector(7 downto 0) := X"35";
	constant datoY3 : std_logic_vector(7 downto 0) := X"36";
	
	constant datoZ1 : std_logic_vector(7 downto 0) := X"30";
	constant datoZ2 : std_logic_vector(7 downto 0) := X"34";
	constant datoZ3 : std_logic_vector(7 downto 0) := X"37";
	
	constant zero	: std_logic_vector(7 downto 0) := X"30";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CNC PORT MAP (
          rx => rx,
          tx => tx,
          clk => clk,
          reset => reset,
          leds => leds,
          bobina_x => bobina_x,
          bobina_y => bobina_y,
          bobina_z => bobina_z
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		reset <= '0';	-- quito reset.
		wait for clk_period*10;
		-- enviamos la instruccion
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= instruccion(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		-- enviamos X
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= datoX1(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= datoX2(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= datoX3(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		-- Enviamos y
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= datoY1(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= datoY2(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= datoY3(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		-- Enviamos z
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= datoZ1(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= datoZ2(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= datoZ3(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		wait for clk_period*10;
		-- enviamos la instruccion
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= instruccion(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		-- enviamos X
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= zero(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= zero(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= zero(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		-- Enviamos y
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= zero(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= zero(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= zero(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		-- Enviamos z
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= zero(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= zero(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		rx <= '0';
		wait for TBIT;
		for i in 0 to 7 loop
			rx <= zero(i);
			wait for TBIT;
		end loop;
		rx <= '1';
		wait for (2*TBIT);
		
		wait for clk_period*1000;
		assert false report "Fin test" severity failure;
   end process;

END;
