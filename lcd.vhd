----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:10:21 05/21/2016 
-- Design Name: 
-- Module Name:    lcd - Behavioral 
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
use ieee.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lcd is
    Port ( CLK 	  : in   STD_LOGIC;
           RST 	  : in   STD_LOGIC;
		   datoX  : in	std_logic_vector(7 downto 0) := (others=>'0');
		   datoY  : in	std_logic_vector(7 downto 0) := (others=>'0');
		   datoZ  : in	std_logic_vector(7 downto 0) := (others=>'0');
           LCD_D  : out  STD_LOGIC_VECTOR (3 downto 0);
           LCD_E  : out  STD_LOGIC;
           LCD_RS : out  STD_LOGIC;
           LCD_Wn : out  STD_LOGIC);
end lcd;

architecture Behavioral of lcd is

	component CNVASCII
	port (
		CLK	: in std_logic;
		dato : in std_logic_vector(7 downto 0);
		startcnv : in std_logic;
		fincnv : out std_logic;
		ASCII_0 : out std_logic_vector(7 downto 0);
		ASCII_1 : out std_logic_vector(7 downto 0);
		ASCII_2 : out std_logic_vector(7 downto 0)
		);
	end component;

	type MAQLCD_t is (INI,INI1,INI2,INI3,INI4,INI5,INI6,INI7,INI8,INI9,INI10,
							INI11,IDLE,WHIGH,WHIGH1,WLOW,WLOW1,WLOW2,WLOW3,WFIN);
	signal STLCD	: MAQLCD_t := INI;
	
	type MAQ_Dis is (WHW,INIDISP,INIDISP1,INIDISP2,INIDISP3,INIDISP4,INIDISP5,
							INIDISP6,INIDISP7,INIDISP8,WCARATULA,WCARATULA1,WCARATULA2,
							WCARATULA3,WCARATULA4,WCARATULA5,WCARATULA6,WCARATULA7,
							WATCHINGX,WATCHINGY,WATCHINGZ,ProcX,ProcX2,ProcX3,ProcX4,
							ProcY,ProcY2,ProcY3,ProcY4,ProcZ,ProcZ2,ProcZ3,ProcZ4);
	signal DISPST: MAQ_Dis := WHW;

	signal Wake : std_logic := '0';

	signal TmpVel	:	std_logic_vector(7 downto 0):= (others=>'0');

	-- interfaz proceso envio.
	signal Done : std_logic := '0';
	signal Start : std_logic := '0';
	signal Aux	:	std_logic_vector(7 downto 0);
	signal RS : std_logic := '0';

	signal TempX	:	std_logic_vector(7 downto 0):= (others=>'0');
	signal TempY	:	std_logic_vector(7 downto 0):= (others=>'0');
	signal TempZ	:	std_logic_vector(7 downto 0):= (others=>'0');
	
	-- interfaz conversor ascii.
	signal datobin	:	std_logic_vector(7 downto 0);
	signal startcnv :   std_logic := '0';
	signal fincnv :   std_logic;
	
	type ARRCHAR is array(natural range<>) of std_logic_vector(7 downto 0);
	signal ASCII :   ARRCHAR(2 downto 0);
	
	constant CARATULA	: string(1 to 15) := "X= 000; Y= 000;";
	constant CARATULA2	: string(1 to 7)  := "Z= 000;";
	
	
begin 

	LCD_Wn <= '0';

	process(clk,rst) -- Refresco de DISPLAY.
		variable TICKS	: integer := 0;
		variable INDEX : integer := 0;
	begin
		if RST = '1' then
			DISPST <= WHW;
			START <= '0';
			startcnv <= '0';
			RS <= '0';
		elsIF rising_edge(CLK) THEN
			case DISPST is
				when WHW =>
					START <= '0';
					if Wake = '1' then
						DISPST <= INIDISP;
					end if;
				when INIDISP =>	-- Function Set.
					RS <= '0';
					AUX <= X"28";
					Start <= '1';
					DISPST <= INIDISP1;
				when INIDISP1 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						DISPST <= INIDISP2;
					end if;
				when INIDISP2 =>	-- Auto increment address.
					if Done = '0' then
						AUX <= X"06";
						Start <= '1';
						DISPST <= INIDISP3;		
					end if;
				when INIDISP3 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						DISPST <= INIDISP4;
					end if;
				when INIDISP4 =>	-- Display ON.
					if Done = '0' then
						AUX <= X"0C";
						Start <= '1';
						DISPST <= INIDISP5;		
					end if;
				when INIDISP5 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						DISPST <= INIDISP6;
					end if;
				when INIDISP6 =>	-- Clear Display.
					if Done = '0' then
						AUX <= X"01";
						Start <= '1';
						DISPST <= INIDISP7;		
					end if;	
				when INIDISP7 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						TICKS := 0;
						DISPST <= INIDISP8;
					end if;	
				when INIDISP8 =>	-- Espera por ejecucion CLEAR DISPLAY
					if TICKS > 82000 then
						DISPST <= WCARATULA;
					else
						TICKS := TICKS + 1;
					end if;
				when WCARATULA =>	-- Address 0, primera linea de caratula
					AUX <= X"80";
					Start <= '1';
					DISPST <= WCARATULA1;	
				when WCARATULA1 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						INDEX := 1;
						DISPST <= WCARATULA2;
					end if;		
				when WCARATULA2 =>	-- Siguiente caracter de la primera linea de caratula.
					if Done = '0' then
						AUX <= conv_std_logic_vector(character'pos(CARATULA(INDEX)),8);
						RS <= '1';
						Start <= '1';
						DISPST <= WCARATULA3;		
					end if;
				when WCARATULA3 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						INDEX := INDEX+1;
						if INDEX = 16 then
							DISPST <= WCARATULA4;
						else
							DISPST <= WCARATULA2;
						end if;
					end if;
				when WCARATULA4 =>	-- Address 40, segunda linea de caratula
					if Done = '0' then
						AUX <= X"C0";
						RS <= '0';
						Start <= '1';
						DISPST <= WCARATULA5;	
					end if;
				when WCARATULA5 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						INDEX := 1;
						DISPST <= WCARATULA6;
					end if;	
				when WCARATULA6 =>	-- Siguiente caracter de la segunda linea de caratula.
					if Done = '0' then
						AUX <= conv_std_logic_vector(character'pos(CARATULA2(INDEX)),8);
						RS <= '1';
						Start <= '1';
						DISPST <= WCARATULA7;		
					end if;
				when WCARATULA7 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						RS <= '0';
						INDEX := INDEX+1;
						if INDEX = 8 then
							DISPST <= WATCHINGX;
						else
							DISPST <= WCARATULA6;
						end if;
					end if;			
				when WATCHINGX =>		--Esperar cambio en los datos de X
					if TempX /= datoX then
						TempX <= datoX;
						DISPST <= ProcX;
					else
						DISPST <= WATCHINGY;
					end if;
				when WATCHINGY =>		--Esperar cambio en los datos de Y
					if TempY /= datoY then
						TempY <= datoY;
						DISPST <= ProcY;
					else
						DISPST <= WATCHINGZ;
					end if;
				when WATCHINGZ =>		--Esperar cambio en los datos de Z
					if TempZ /= datoZ then
						TempZ <= datoZ;
						DISPST <= ProcZ;
					else
						DISPST <= WATCHINGX;
					end if;
				when ProcX =>	--Address 03, dato x (80+3)
					if Done = '0' then
						AUX <= X"83";
						RS <= '0';
						Start <= '1';
						datobin <= TempX;
						startcnv <= '1';
						DISPST <= ProcX2;
					end if;
				when ProcX2 =>	-- Esperar por el otro proceso
					if Done = '1' and fincnv = '1' then
						Start <= '0';
						startcnv <= '0';
						INDEX := 2;
						DISPST <= ProcX3;
					end if;	
				when ProcX3 =>	-- Siguiente caracter x
					if Done = '0' then  
						AUX <= ASCII(INDEX);
						RS <= '1';
						Start <= '1';
						DISPST <= ProcX4;		
					end if;
				when ProcX4 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						RS <= '0';
						if INDEX = 0 then
							DISPST <= WATCHINGY;
						else
							DISPST <= ProcX3;
						end if;
						INDEX := INDEX-1;
					end if;	
				when ProcY =>	--Address 0B, dato y (80+0B)
					if Done = '0' then
						AUX <= X"8B";
						RS <= '0';
						Start <= '1';
						datobin <= TempY;
						startcnv <= '1';
						DISPST <= ProcY2;
					end if;
				when ProcY2 =>	-- Esperar por el otro proceso
					if Done = '1' and fincnv = '1' then
						Start <= '0';
						startcnv <= '0';
						INDEX := 2;
						DISPST <= ProcY3;
					end if;	
				when ProcY3 =>	-- Siguiente caracter Y
					if Done = '0' then  
						AUX <= ASCII(INDEX);
						RS <= '1';
						Start <= '1';
						DISPST <= ProcY4;		
					end if;
				when ProcY4 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						RS <= '0';
						if INDEX = 0 then
							DISPST <= WATCHINGZ;
						else
							DISPST <= ProcY3;
						end if;
						INDEX := INDEX-1;
					end if;	
				when ProcZ => --Address 43, dato z (80+43)
					if Done = '0' then
						AUX <= X"C3";
						Start <= '1';
						RS <= '0';
						datobin <= TempZ;
						startcnv <= '1';
						DISPST <= ProcZ2;
					end if;
				when ProcZ2 =>	-- Esperar por el otro proceso
					if Done = '1' and fincnv = '1' then
						Start <= '0';
						startcnv <= '0';
						INDEX := 2;
						DISPST <= ProcZ3;
					end if;		
				when ProcZ3 =>	-- Siguiente caracter z
					if Done = '0' then  
						AUX <= ASCII(INDEX);
						RS <= '1';
						Start <= '1';
						DISPST <= ProcZ4;		
					end if;
				when ProcZ4 =>	-- Esperar por el otro proceso
					if Done = '1' then
						Start <= '0';
						RS <= '0';
						if INDEX = 0 then
							DISPST <= WATCHINGX;
						else
							DISPST <= ProcZ3;
						end if;
						INDEX := INDEX-1;
					end if;					
				when others =>
					DISPST <= WHW;
			end case;
		end if;
	end process;


	-- Proceso de iniciacion HW display y escritura DISPLAY.
	process(CLK,RST)
		variable TICKS		: integer := 0;
	begin
		if RST = '1' then
			STLCD <= INI;
			TICKS := 0;
			LCD_RS <= '0';
			LCD_E <= '0';
			DONE <= '0';
			Wake <= '0';
		elsif rising_edge(CLK) then
			case STLCD is
				when INI =>			-- Esperar 15 ms.
					if TICKS > 750000 then
						LCD_D <= X"3";
						LCD_RS <= '0';
						STLCD <= INI1;
					else
						TICKS := TICKS + 1;
					end if;
				when INI1 =>	-- Setup for strobe.
					STLCD <= INI2;
				when INI2 =>
					LCD_E <= '1';
					TICKS := 0;
					STLCD <= INI3;
				when INI3 =>	-- 12 ticks strobe.
					if TICKS > 12 then
						LCD_E <= '0';
						STLCD <= INI4;
					else
						TICKS := TICKS + 1;
					end if;
				when INI4 =>	-- Esperar 4.1 ms.
					if TICKS > 205000 then
						LCD_E <= '1';
						TICKS := 0;
						STLCD <= INI5;
					else
						TICKS := TICKS + 1;
					end if;
				when INI5 =>	-- 12 ticks strobe.
					if TICKS > 12 then
						LCD_E <= '0';
						STLCD <= INI6;
					else
						TICKS := TICKS + 1;
					end if;
				when INI6 =>	-- Esperar 100 us.
					if TICKS > 5000 then
						LCD_E <= '1';
						TICKS := 0;
						STLCD <= INI7;
					else
						TICKS := TICKS + 1;
					end if;
				when INI7 =>	-- 12 ticks strobe.
					if TICKS > 12 then
						LCD_E <= '0';
						STLCD <= INI8;
					else
						TICKS := TICKS + 1;
					end if;	
				when INI8 =>	--Esperar 40 us.
					if TICKS > 2000 then
						LCD_D <= X"2";
						TICKS := 0;
						STLCD <= INI9;
					else
						TICKS := TICKS + 1;
					end if;
				when INI9 => 	-- setup strobe.
					STLCD <= INI10;
				when INI10 =>	-- 12 ticks strobe.
					LCD_E <= '1';
					if TICKS > 12 then
						LCD_E <= '0';
						STLCD <= INI11;
					else
						TICKS := TICKS + 1;
					end if;		
				when INI11 =>	--Esperar 40 us.
					if TICKS > 2000 then
						STLCD <= IDLE;
					else
						TICKS := TICKS + 1;
					end if;		
				when IDLE =>		--Esperar orden y mandar High.
					Wake <= '1';
					DONE <= '0';
					if START = '1' then
						LCD_RS <= RS;
						LCD_D <= AUX(7 downto 4);
						TICKS := 0;
						STLCD <= WHIGH;
					end if;
				when WHIGH =>		-- Setup strobe.
					STLCD <= WHIGH1;
				when WHIGH1 =>	-- 12 ticks strobe.
					LCD_E <= '1';
					if TICKS > 12 then
						LCD_E <= '0';
						TICKS := 0;
						STLCD <= WLOW;
					else
						TICKS := TICKS + 1;
					end if;		
				when WLOW =>	--Esperar 1 us. y mandar low.
					if TICKS > 50 then
						LCD_D <= AUX(3 downto 0);
						TICKS := 0;
						STLCD <= WLOW1;
					else
						TICKS := TICKS + 1;
					end if;
				when WLOW1 =>		-- Setup strobe.
					STLCD <= WLOW2;
				when WLOW2 =>	-- 12 ticks strobe.
					LCD_E <= '1';
					if TICKS > 12 then
						LCD_E <= '0';
						TICKS := 0;
						STLCD <= WLOW3;
					else
						TICKS := TICKS + 1;
					end if;		
				when WLOW3 =>	-- Esperar 40 us.
					if TICKS > 2000 then	
						Done <= '1';
						STLCD <= WFIN;
					else
						TICKS := TICKS + 1;
					end if;
				when WFIN =>	-- Espera quiten START.
					if START = '0' then
						STLCD <= IDLE;
					end if;
				when others =>
					STLCD <= INI;
			end case;
		end if;
	end process;

	U1 : CNVASCII	--Componente para transformar Binario en ASCII    
	port map(
		CLK => CLK,
		dato => datobin,
		startcnv => startcnv,
		fincnv  => fincnv,
		ASCII_0  => ASCII(0),
		ASCII_1  => ASCII(1),
		ASCII_2  => ASCII(2)
		);

					
end Behavioral;

