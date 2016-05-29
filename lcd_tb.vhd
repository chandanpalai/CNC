--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:18:04 05/28/2016
-- Design Name:   
-- Module Name:   /home/domi/CNC/lcd_tb.vhd
-- Project Name:  CNC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lcd
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
 
ENTITY lcd_tb IS
END lcd_tb;
 
ARCHITECTURE behavior OF lcd_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lcd
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         datoX : IN  std_logic_vector(7 downto 0);
         datoY : IN  std_logic_vector(7 downto 0);
         datoZ : IN  std_logic_vector(7 downto 0);
         LCD_D : OUT  std_logic_vector(3 downto 0);
         LCD_E : OUT  std_logic;
         LCD_RS : OUT  std_logic;
         LCD_Wn : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '1';
   signal datoX : std_logic_vector(7 downto 0) := (others => '0');
   signal datoY : std_logic_vector(7 downto 0) := (others => '0');
   signal datoZ : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal LCD_D : std_logic_vector(3 downto 0);
   signal LCD_E : std_logic;
   signal LCD_RS : std_logic;
   signal LCD_Wn : std_logic;
	

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lcd PORT MAP (
          CLK => CLK,
          RST => RST,
          datoX => datoX,
          datoY => datoY,
          datoZ => datoZ,
          LCD_D => LCD_D,
          LCD_E => LCD_E,
          LCD_RS => LCD_RS,
          LCD_Wn => LCD_Wn
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST <= '0';	-- quito reset.
      wait for clk_period*10;
		wait for 40 ms; 
      -- insert stimulus here 
		 datoX <= "00100001";	--33
       datoY <= "01000010";	--66	
       datoZ <= "10000100";	--132
		wait for 5 ms; 
		 
		 datoX <= "00110111";	--55
       datoY <= "01101110";	--110	
       datoZ <= "11011100";	--220
		 
		wait for clk_period*100;
		wait for 5 ms; 
		assert false report "Fin test" severity failure;
      wait;
   end process;

END;
