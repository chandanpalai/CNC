--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:46:38 05/24/2016
-- Design Name:   
-- Module Name:   C:/Users/Kovac/Documents/XilinxP/Assembler/test_assembler.vhd
-- Project Name:  Assembler
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Assembler
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
 
ENTITY test_assembler IS
END test_assembler;
 
ARCHITECTURE behavior OF test_assembler IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Assembler
    PORT(
         clk, reset: IN  std_logic;
         Brec : IN  std_logic_vector(7 downto 0);
         rec_pending : IN  std_logic;
         Btrans : OUT  std_logic_vector(7 downto 0);
         Tstart : OUT  std_logic;
         t_done : IN  std_logic;
			order_done : in  std_logic;
         rec_done : OUT  std_logic;
         Instruccion : OUT  std_logic_vector(1 downto 0);
         DatoX : OUT  std_logic_vector(7 downto 0);
         DatoY : OUT  std_logic_vector(7 downto 0);
         DatoZ : OUT  std_logic_vector(7 downto 0);
			Order_pending: out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk, reset : std_logic := '0';
   signal Brec : std_logic_vector(7 downto 0) := (others => '0');
   signal rec_pending : std_logic := '0';
   signal t_done : std_logic := '0';
	signal order_done : std_logic:='0';

 	--Outputs
   signal Btrans : std_logic_vector(7 downto 0):=(others=>'0');
   signal Tstart : std_logic := '0';
   signal rec_done : std_logic := '0';
   signal Instruccion : std_logic_vector(1 downto 0):="10";
   signal DatoX : std_logic_vector(7 downto 0);
   signal DatoY : std_logic_vector(7 downto 0);
   signal DatoZ : std_logic_vector(7 downto 0);
   signal Order_pending : std_logic;

   
		type status is (uart, datos,enviar, finishing);
		type estado_datos is (x, y, z);
      
		constant clk_period : time := 20 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Assembler PORT MAP (
          clk => clk,
			 reset => reset,
          Brec => Brec,
          rec_pending => rec_pending,
          Btrans => Btrans,
          Tstart => Tstart,
          t_done => t_done,
			 order_done =>order_done,
          rec_done => rec_done,
          Instruccion => Instruccion,
          DatoX => DatoX,
          DatoY => DatoY,
          DatoZ => DatoZ,
			 Order_pending => order_pending,
			 traza => traza
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	tdone_proc: process 
	begin
		if tstart = '1' and t_done = '0' then
			wait for 40 ns;
			t_done <= '1';
		elsif tstart = '0' then
			t_done <= '0';
		end if;
		wait for 10 ns;
	end process;
	
	order_proc : process 
	begin 
		if order_pending = '1' and order_done = '0' then
			wait for 40 ns;
			order_done <= '1';
			wait for 60 ns;
		elsif order_pending = '0' then
			order_done <= '0';
		end if;
		wait for 10 ns;
	end process;
	
 
  tb : PROCESS
		variable estado : status := uart;
		variable estatus_datos : estado_datos := x;
     BEGIN
				case estado is
					when uart =>
						if rec_done = '0' and rec_pending = '0' then
							brec<="01010011";
							wait for 10 ns;
							rec_pending <= '1';
						elsif rec_done = '1' then
							rec_pending <= '0';
							estado:=datos;
						end if;
					when datos =>
						if rec_done = '0' and rec_pending = '0' then
							case estatus_datos is
								when x => 
									brec<="00110010";
									estatus_datos := y;
								when y => 
									brec<="00110011";
									estatus_datos := z;
								when z => 
									brec<="00110010";
									estado := finishing;
							end case;
							wait for 10 ns;
							rec_pending <= '1';
						elsif rec_done = '1' then
							wait for 10 ns;
							rec_pending <= '0';
						end if;
					when finishing => 
						wait for 500 ns;
						assert false report "Fin test" severity failure;
					when others => 
						assert false report "Fin test" severity failure;
				end case;
			wait for 10 ns; 
     END PROCESS tb;
END;
