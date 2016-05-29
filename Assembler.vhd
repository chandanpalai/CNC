-- company: 
-- engineer: 
-- 
-- create date:    19:30:33 05/22/2016 
-- design name: 
-- module name:    assembler - behavioral
-- project name: 
-- target devices: 
-- tool versions: 
-- description: 
--
-- dependencies: 
--
-- revision: 
-- revision 0.01 - file created
-- additional comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;

-- uncomment the following library declaration if instantiating
-- any xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

entity assembler is
    port ( clk, reset: in std_logic;
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
			  traza : out	std_logic_vector(7 downto 0) := (others=>'0');
			  order_halt : out std_logic := '0'
	);
end assembler;

architecture behavioral of assembler is

--variables , seales y tipos de datos.
type state is ( waiting, processing, recta, calculo ,dx, dy, dz, waiting_to_send, e_reset, halt); --Se declara el tipo state para el automata de este bloque.
type transmision is (espera, transmite1, transmite2); --Se declara el tipo transmision para el automata encargado de transmitir a la UART.

signal estado: state:= waiting;
signal transmitir: transmision:= espera;
signal i_dato_x, i_dato_y, i_dato_z: std_logic_vector (7 downto 0) := (others => '0');
signal i_btrans : std_logic_vector (7 downto 0):=(others => '0'); --init
signal i_rec_done, i_tstart, i_order_pending: std_logic:='0';
signal i_instruccion: std_logic_vector (1 downto 0):="10"; --init

constant letra_o: std_logic_vector (7 downto 0) := x"4f";
constant letra_k: std_logic_vector(7 downto 0):= x"4b";
--variables y seales.

begin

	datox <= i_dato_x;
	datoy <= i_dato_y;
	datoz <= i_dato_z;
	btrans <= i_btrans; --init
	instruccion<=i_instruccion; --init
	rec_done <= i_rec_done;
	tstart <= i_tstart;
	order_pending <= i_order_pending;

	process(clk, reset)
		--variables
		variable contador,num_datos: integer range 0 to 3:=0;
		variable dato: integer range 0 to 255:=0;
		variable resultado_entero3,resultado_entero2,resultado_entero1, total: integer range 0 to 255:=0;
		variable resul_unsig: unsigned(7 downto 0):=(others=>'0');
		--variables
	begin		
		if reset = '0' then 
			if (rising_edge(clk)) then
				if order_done = '1' and i_order_pending = '1' then
					i_order_pending <= '0';
					order_halt <= '0';
				end if;
				if rec_pending = '0' then
					i_rec_done <= '0';
				elsif estado = waiting_to_send or (rec_pending = '1' and i_rec_done = '0') then -- se comprueba antes que rec_pending = 1 para continuar con el tratamiento del byte enviado.
					case estado is
						when waiting => 
							if order_done = '0' and i_order_pending = '0' then
								estado <= processing;
--							elsif order_done = '1' and i_order_pending = '1' then
--								i_order_pending <= '0';
							end if;
						when processing => -- Se procesan los bytes enviados desde la UART.
							CASE brec IS -- Conjunto de estados, cada uno con una instruccion a reconocer.
								WHEN "01010011" => --RECTA 01
									estado<=recta;
								WHEN "01010010" => --RESET 00
									estado<= e_reset;
								WHEN "01001000" => --HALT  11
									estado<= halt;
								WHEN OTHERS => --OTHERS
									estado<=waiting; --Estado de espera cuando lo recibido no se corresponda con el formato requerido.
							end case;
							i_rec_done <= '1';
						when recta =>
							i_instruccion<="01";
							if Brec(7 downto 4) = "0011" then --se comprueba que lo enviado es un dato y no una instruccion.
								estado<=calculo;
								dato:= to_integer(unsigned(brec(3 downto 0))); -- Se obtiene el dato desde el bus.
							else
								estado<=waiting;
							end if;						
						when calculo => -- Se procede a calcular el valor real del dato enviado.
							case contador is
								when 0 =>
									resultado_entero3:=dato*100;  --se calcula dato x 100.
									estado<=recta;
									contador:=contador+1;
									i_rec_done <= '1';
								when 1 =>
									dato:=to_integer(unsigned(brec(3 downto 0)));
									resultado_entero2:=dato*10;  --se calcula dato x 10.
									contador:=contador+1;
									estado<=recta;
									i_rec_done <= '1';
								when 2 =>
									dato:=to_integer(unsigned(brec(3 downto 0)));
									resultado_entero1:=dato; -- se obtiene dato.
									if num_datos = 0 then -- Se verifica que dato se ha tratado.
										estado<=dx;
										contador:=0;
									elsif num_datos = 1 then
										estado<=dy;
										contador:=0;
									elsif num_datos = 2 then 
										estado<=dz;
										contador:=0;
									end if;
								when others => -- En el caso de que lo recibido no sea un dato, se vuelve al estado waiting.
									estado <= waiting;
							end case;
							WHEN dx =>
								total:=resultado_entero1+resultado_entero2+resultado_entero3; 
								i_dato_x<=std_logic_vector(to_unsigned(total,i_dato_x'length)); -- Juntamos todos los valores obtenidos para obtener el valor del dato recibido en datoX.
								num_datos:=num_datos+1;
								estado<=recta;
								i_rec_done <= '1';
							WHEN dy =>
								total:=resultado_entero1+resultado_entero2+resultado_entero3;
								i_dato_y<=std_logic_vector(to_unsigned(total,i_dato_y'length)); -- Juntamos todos los valores obtenidos para obtener el valor del dato recibido en datoY.
								num_datos:=num_datos+1;
								estado<=recta;
								i_rec_done <= '1';
							WHEN dz =>
								total:=resultado_entero1+resultado_entero2+resultado_entero3;
								i_dato_z<=std_logic_vector(to_unsigned(total,i_dato_z'length)); -- Juntamos todos los valores obtenidos para obtener el valor del dato recibido en datoZ.
								num_datos := 0;
								i_rec_done <= '1';
								estado<=waiting_to_send; -- Se va al estado waiting_to_send para informar de que se ya ha tratado la informacion recibida.
							WHEN e_reset => --RESET
								i_instruccion <= "00";
								estado<=waiting_to_send;
							WHEN halt => --HALT
								order_halt <= '1';
								estado<=waiting_to_send;
							WHEN waiting_to_send =>
								i_order_pending <= '1';
								estado <= waiting;
							WHEN OTHERS =>
								estado<=waiting;
					end case;
				end if;
			end if;-- sentencia if para clk.
		else -- En el caso de activarse el reset, se inicializan los valores y estado.
			estado <=waiting;
			i_dato_x <="00000000";
			i_dato_y <="00000000";
			i_dato_z <="00000000";
			i_rec_done <='0';
			i_order_pending <= '0';
		end if;--sentencia if del reset.
	end process;
	
	i: process(clk) -- Proceso para la transmision entre la UART y el Ensamblador.
	begin
		if rising_edge(clk) then
			case transmitir is
				when espera => 
					if t_done = '0' and i_tstart = '0' and order_done = '1' and i_order_pending = '1' then --Se comprueban los flags antes de pasar a transmitir a la UART.
						transmitir <= transmite1;
					elsif t_done = '1' and i_tstart = '1' then
						i_tstart <= '0';
					end if;
				when transmite1 => --Se transmite la primera parte del mensaje que va a la UART, la letra O en este caso.
					if t_done = '0' and i_tstart = '0' then
						i_btrans<=letra_o;
						i_tstart<='1';
						transmitir<=transmite2;
					elsif t_done = '1' then
						i_tstart<='0';
					end if;
				when transmite2 =>
					if t_done = '0' and i_tstart = '0' then --Se vuelven a comprobar los flags para enviar la segunda parte del mensaje.
						i_btrans<=letra_k;
						i_tstart <= '1';
						transmitir <= espera;
					elsif t_done = '1' then
						i_tstart<='0';
					end if;
				end case;
		end if;

	end process;
	
	TRAZA(0) <= '1' when estado = recta else '0';
	TRAZA(1) <= '1' when estado = dx else '0';
	TRAZA(2) <= '1' when estado = dy else '0';
	TRAZA(3) <= '1' when estado = dz else '0';
	TRAZA(7) <= rec_pending;
	
end behavioral;