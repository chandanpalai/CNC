----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:01:50 05/25/2016 
-- Design Name: 
-- Module Name:    CNC - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CNC is
    Port ( rx : in  STD_LOGIC;
           tx : out  STD_LOGIC;
           clk : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  leds : out std_logic_vector(7 downto 0);
			  bobina_x 	: out STD_LOGIC_VECTOR(3 downto 0);
			  bobina_y 	: out STD_LOGIC_VECTOR(3 downto 0);
			  bobina_z 	: out STD_LOGIC_VECTOR(3 downto 0)
			  );
end CNC;

architecture Behavioral of CNC is
	COMPONENT UART
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
	END COMPONENT;
	
	COMPONENT Assembler
		PORT(
			clk, reset: in std_logic;
			  brec : in  std_logic_vector (7 downto 0);
           rec_pending : in  std_logic;
           btrans : out   std_logic_vector(7 downto 0);
           tstart : out  std_logic;
           t_done, order_done : in  std_logic;
			  rec_done : out  std_logic;
           instruccion : out  std_logic_vector (1 downto 0);
           datox : out  std_logic_vector (7 downto 0);
           datoy : out  std_logic_vector (7 downto 0);
           datoz : out  std_logic_vector (7 downto 0);
			  order_pending: out std_logic;
			  traza : out	std_logic_vector(7 downto 0) := (others=>'0')
		);
	END COMPONENT;
	COMPONENT Secuenciador
		Port ( instruccion : in  STD_LOGIC_VECTOR (1 downto 0);
				coordenada_x : in  STD_LOGIC_VECTOR (7 downto 0);
				coordenada_y : in  STD_LOGIC_VECTOR (7 downto 0);
				coordenada_z : in  STD_LOGIC_VECTOR (7 downto 0);
				processing_x : in STD_LOGIC;
				processing_y : in STD_LOGIC;
				processing_z : in STD_LOGIC;
				clk, rst, order_pending : in STD_LOGIC;
				distancia_x : out  STD_LOGIC_VECTOR (7 downto 0);
				velocidad_x : out STD_LOGIC_VECTOR (7 downto 0);
				direccion_x : out STD_LOGIC;
				distancia_y : out  STD_LOGIC_VECTOR (7 downto 0);
				velocidad_y : out STD_LOGIC_VECTOR (7 downto 0);
				direccion_y : out STD_LOGIC;
				distancia_z : out  STD_LOGIC_VECTOR (7 downto 0);
				velocidad_z : out STD_LOGIC_VECTOR (7 downto 0);
				direccion_z: out STD_LOGIC;
				sending_order : out STD_LOGIC;
				reset_engines, order_done : out STD_LOGIC
		);
	END COMPONENT;
	COMPONENT Motor
		Port (
			CLK		: in   STD_LOGIC;
			Rst 		: in  STD_LOGIC;
			Dir      : in  STD_LOGIC;
			Dis      : in  STD_LOGIC_VECTOR (7 downto 0);
			Vel      : in  STD_LOGIC_VECTOR (7 downto 0);
			Ord 		: in  STD_LOGIC;
			Proc     : out  STD_LOGIC;
			bobina 	: out STD_LOGIC_VECTOR(3 downto 0)
		);
	END COMPONENT;
	signal rec_pending, tdone, rec_done, tstart, order_pending, processing_x, processing_y, processing_z, sending_order, order_done, reset_engines: STD_LOGIC := '0';
	signal direccion_x, direccion_y, direccion_z : STD_LOGIC := '1';
	signal brec, btrans, coordenada_x, coordenada_y, coordenada_z, distancia_x, distancia_y, distancia_z, velocidad_x, velocidad_y, velocidad_z : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
	signal instruccion : STD_LOGIC_VECTOR (1 downto 0) := "00";
	
		type LED_T is array(natural range<>) of integer;
	signal CNT_LED	: LED_T(0 to 7) := (others=>0);
	signal TRAZA : std_logic_vector(7 downto 0):= (others=>'0');
begin

	process(CLK)
	begin
		if rising_edge(CLK) then
			for i in 0 to 7 loop
				if TRAZA(i) = '1' then
					CNT_LED(i) <= 500000;
					LEDS(i) <= '1';
				elsif CNT_LED(i) > 0 then
					LEDS(i) <= '1';
					CNT_LED(i) <= CNT_LED(i) -1;
				else
					LEDS(i) <= '0';
				end if;
			end loop;
		end if;
	end process;

	uuart : UART PORT MAP (
		rx => rx,
		tx => tx,
		clk => clk,
		rst => reset,
		brec => brec,
		rec_pending => rec_pending,
		rec_done => rec_done,
		btrans => btrans,
		tstart => tstart,
		tdone => tdone
	);
	uassembler : Assembler PORT MAP(
		clk => clk,
		Brec => brec,
		rec_pending => rec_pending,
		Btrans =>  btrans,
		Tstart => tstart,
		t_done => tdone,
		rec_done => rec_done,
		Instruccion => instruccion,
		DatoX => coordenada_x,
		DatoY => coordenada_y,
		DatoZ => coordenada_z,
		reset => reset,
		order_done => order_done,
		traza => traza,
		order_pending => order_pending
	);
	
	usecuenciador : Secuenciador PORT MAP(
		instruccion => instruccion,
		coordenada_x => coordenada_x,
		coordenada_y => coordenada_y,
		coordenada_z => coordenada_z,
		processing_x => processing_x,
		processing_y => processing_y,
		processing_z => processing_z,
		clk => clk,
		rst => reset,
		order_pending => order_pending,
		distancia_x => distancia_x,
		velocidad_x => velocidad_x,
		direccion_x => direccion_x,
		distancia_y => distancia_y,
		velocidad_y => velocidad_y,
		direccion_y => direccion_y,
		distancia_z => distancia_z,
		velocidad_z => velocidad_z,
		direccion_z => direccion_z,
		sending_order => sending_order,
		reset_engines => reset_engines,
		order_done => order_done
	);
	
	umotorx : Motor PORT MAP(
		CLK		=> clk,
		Rst 		=> reset_engines,
		Dir      => direccion_x,
		Dis      => distancia_x,
		Vel      => velocidad_x,
		Ord 		=> sending_order,
		Proc     => processing_x,
		bobina 	=> bobina_x
	);
	
	umotory : Motor PORT MAP(
		CLK		=> clk,
		Rst 		=> reset_engines,
		Dir      => direccion_y,
		Dis      => distancia_y,
		Vel      => velocidad_y,
		Ord 		=> sending_order,
		Proc     => processing_y,
		bobina 	=> bobina_y
	);
	
	umotorz : Motor PORT MAP(
		CLK		=> clk,
		Rst 		=> reset_engines,
		Dir      => direccion_z,
		Dis      => distancia_z,
		Vel      => velocidad_z,
		Ord 		=> sending_order,
		Proc     => processing_z,
		bobina 	=> bobina_z
	);

end Behavioral;

