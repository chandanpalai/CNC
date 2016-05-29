----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:47:10 05/17/2016 
-- Design Name: 
-- Module Name:    Secuenciador - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity Secuenciador is
	Port ( 
		instruccion 	: in  STD_LOGIC_VECTOR (1 downto 0); -- Instruccion recibida
		coordenada_x 	: in  STD_LOGIC_VECTOR (7 downto 0); -- Coordenada X de destino
		coordenada_y 	: in  STD_LOGIC_VECTOR (7 downto 0); -- Coordenada Y de destino
		coordenada_z 	: in  STD_LOGIC_VECTOR (7 downto 0); -- Coordenada Z de destino
		processing_x 	: in STD_LOGIC; -- Flag de proceso del motor X
		processing_y 	: in STD_LOGIC; -- Flag de proceso del motor Y
		processing_z 	: in STD_LOGIC; -- Flag de proceso del motor Z
		clk				: in STD_LOGIC; -- Reloj
		rst				: in STD_LOGIC; -- Reset
		order_pending 	: in STD_LOGIC; -- Flag de orden pendiente de procesar desde el ensamblador
		halt 				: in STD_LOGIC; -- Flag de HALT
		distancia_x 	: out  STD_LOGIC_VECTOR (7 downto 0); -- Distancia que tendra que recorrer el motor X
		velocidad_x 	: out STD_LOGIC_VECTOR (7 downto 0); -- Velocidad del motor X (de 0 a 100)
		direccion_x 	: out STD_LOGIC; -- Direccion de x (1 alante , 0 atras)
		distancia_y 	: out  STD_LOGIC_VECTOR (7 downto 0);
		velocidad_y 	: out STD_LOGIC_VECTOR (7 downto 0); 
		direccion_y 	: out STD_LOGIC;
		distancia_z 	: out  STD_LOGIC_VECTOR (7 downto 0);
		velocidad_z 	: out STD_LOGIC_VECTOR (7 downto 0);
		direccion_z		: out STD_LOGIC;
		sending_order 	: out STD_LOGIC; -- Flag para notificar a los motores que se les manda una orden
		reset_engines	: out STD_LOGIC; -- Flag para resetear los motores y pararlos
		order_done 		: out STD_LOGIC; -- Flag para señalar al ensamblador que se ha completado la orden
		coordenada_x_act : out std_logic_vector(7 downto 0);
		coordenada_y_act : out std_logic_vector(7 downto 0);
		coordenada_z_act : out std_logic_vector(7 downto 0)
	);
end Secuenciador; 

architecture Behavioral of Secuenciador is

	-- Variables intermedias
	signal i_coordenada_x, i_coordenada_y, i_coordenada_z : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_coordenada_destino_x, i_coordenada_destino_y, i_coordenada_destino_z : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
	signal i_distancia_x : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_distancia_y : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_distancia_z : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
	signal i_velocidad_x : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_velocidad_y : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_velocidad_z : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_reset_engines, i_sending_order : STD_LOGIC := '0';
	signal i_order_done : STD_LOGIC := '0';
	signal i_instruccion : STD_LOGIC_VECTOR(1 downto 0);
	signal in_signal1, in_signal2, out_signal1, out_signal2 : STD_LOGIC := '0';
	
	type max_possibles is (x, y, z); -- para el calculo de la distancia mayor
	type process_states is (waiting_order, process_order, process_reset, order_finished); -- Estados de proceso de la instruccion
	type division_states is (none, waiting, done); -- Estado de proceso de la division para la velocidad
	
	-- Variables para las dos divisiones
	signal dividendo1, dividendo2, resto1, resto2 : STD_LOGIC_VECTOR(13 downto 0);
	signal resultado1, resultado2, divisor1, divisor2 : STD_LOGIC_VECTOR (7 downto 0);
	
	-- Componente divisor que se usa para la velocidad
	component divisor 
		PORT(
			dividendo : in STD_LOGIC_VECTOR (13 downto 0);
			divisor : in STD_LOGIC_VECTOR (7 downto 0);
			in_signal : in STD_LOGIC;			
			clk : in STD_LOGIC;
			resultado : out STD_LOGIC_VECTOR (7 downto 0); 
			resto : out STD_LOGIC_VECTOR(13 downto 0);
			out_signal : out STD_LOGIC
		);
	end component;
	
begin
	
	distancia_x <= i_distancia_x;
	velocidad_x <= i_velocidad_x;
	
	distancia_y <= i_distancia_y;
	velocidad_y <= i_velocidad_y;
	
	distancia_z <= i_distancia_z;
	velocidad_z <= i_velocidad_z;
	
	reset_engines <= i_reset_engines;
	sending_order <= i_sending_order;
	
	coordenada_x_act <= i_coordenada_x;
	coordenada_y_act <= i_coordenada_y;
	coordenada_z_act <= i_coordenada_z;
	order_done <= i_order_done;
	
	div1 : divisor PORT MAP(
		dividendo 	=> dividendo1,
		divisor 		=> divisor1,
		in_signal 	=> in_signal1,
		clk 			=> clk,
		resultado 	=> resultado1,
		out_signal 	=> out_signal1,
		resto => resto1
	);
	
	div2 : divisor PORT MAP(
		dividendo 	=> dividendo2,
		divisor 		=> divisor2,
		in_signal 	=> in_signal2,
		clk 			=> clk,
		resultado 	=> resultado2,
		out_signal 	=> out_signal2,
		resto => resto2
	);
	
	process (clk, rst)
		variable max : max_possibles; -- Almacenamiento de la distancia mas larga para calcular la velocidad
		variable div_state : division_states := none; -- Estado de las divisiones para ver cuando se acaban de hacer
		variable process_state : process_states := waiting_order; -- Estado del procesamiento de la orden
		-- variables internas para transformar y operar
		variable coord_x, coord_y, coord_z : integer := 0;
		variable i_coord_x, i_coord_y, i_coord_z : integer := 0;
		variable dist_x, dist_y, dist_z : integer := 0;
		variable vel_x, vel_y, vel_z : integer range 0 to 100:= 100;
	begin
		if rising_edge(clk) then
			if rst = '1' and process_state /= process_reset and process_state /= order_finished then -- Si se ordena un reset y dicho reset no esta en proceso...
				i_instruccion <= "00"; -- Se ejecuta la instruccion reset
				process_state := process_order; 
				i_order_done <= '0';
			elsif halt = '1' and i_instruccion /= "11" and order_pending = '1' then
				i_instruccion <= "11";
				process_state := process_order; 
				i_order_done <= '0';
			elsif process_state = waiting_order and order_pending = '1' and i_order_done = '0' and i_sending_order = '0' then -- Se espera una orden y nos lo marcan en el flag
				i_instruccion <= instruccion; -- Establecemos las variables
				process_state := process_order;
				i_coordenada_destino_x <= coordenada_x;
				i_coordenada_destino_y <= coordenada_y;
				i_coordenada_destino_z <= coordenada_z;
				i_reset_engines <= '0';
			elsif process_state = process_order or process_state = process_reset then
				case i_instruccion is
					when "00" => -- R (reset)
						-- Establecemos como coordenadas de destino el origen y ordenamos una recta hacia ellas
						i_instruccion <= "01";
						i_reset_engines <= '0';
						i_coordenada_destino_x <= (others => '0');
						i_coordenada_destino_y <= (others => '0');
						i_coordenada_destino_z <= (others => '0');
					when "01" => -- S	(recta)
						case div_state is 
							when none => -- Si aun no se esta calculando la velocidad quiere decir que esta empezando
								-- Inicializamos las variables internas para hallar la distancia y velocidad
								coord_x := to_integer(unsigned(i_coordenada_destino_x));
								coord_y := to_integer(unsigned(i_coordenada_destino_y));
								coord_z := to_integer(unsigned(i_coordenada_destino_z));
								
								i_coord_x := to_integer(unsigned(i_coordenada_x));
								i_coord_y := to_integer(unsigned(i_coordenada_y));
								i_coord_z := to_integer(unsigned(i_coordenada_z));
								
								-- Establecemos la direccion (si las coordenadas son menores que las actuales, hacia atras)
								-- Buscamos la distancia maxima para calcular la velocidad relativa de las otras dos componentes
								if i_coord_x < coord_x then
									dist_x := coord_x - i_coord_x;
									direccion_x <= '1';
								else 
									dist_x := i_coord_x - coord_x;
									direccion_x <= '0';
								end if;
								
								if i_coord_y < coord_y then
									dist_y := coord_y - i_coord_y;
									direccion_y <= '1';
								else 
									dist_y := i_coord_y - coord_y;
									direccion_y <= '0';
								end if;
								
								if dist_y > dist_x then
									max := y;
								else
									max := x;
								end if;
								
								if i_coord_z < coord_z then
									dist_z := coord_z - i_coord_z;
									direccion_z <= '1';
								else 
									dist_z := i_coord_z - coord_z;
									direccion_z <= '0';
								end if;
								
								if dist_z > dist_y and max = y then
									max:= z;
								end if;
								
								-- Una vez sabida la distancia maxima, calculamos cual ira al 100 de la velocidad (el recorrido mas largo)
								-- Los otros dos iran a una velocidad proporcional a la distancia que tengan que cubrir
								case max is
									when x =>
										vel_x := 100;
										dividendo1 <= std_logic_vector(to_unsigned(dist_y * 100, dividendo1'length));
										divisor1 <= std_logic_vector(to_unsigned(dist_x, divisor1'length));
										dividendo2 <= std_logic_vector(to_unsigned(dist_z * 100, dividendo2'length));
										divisor2 <= std_logic_vector(to_unsigned(dist_x, divisor2'length));
									when y =>
										vel_y := 100;
										dividendo1 <= std_logic_vector(to_unsigned(dist_x * 100, dividendo1'length));
										divisor1 <= std_logic_vector(to_unsigned(dist_y, divisor1'length));
										dividendo2 <= std_logic_vector(to_unsigned(dist_z * 100, dividendo2'length));
										divisor2 <= std_logic_vector(to_unsigned(dist_y, divisor2'length));
									when z =>
										vel_z := 100;
										dividendo1 <= std_logic_vector(to_unsigned(dist_x * 100, dividendo1'length));
										divisor1 <= std_logic_vector(to_unsigned(dist_z, divisor1'length));
										dividendo2 <= std_logic_vector(to_unsigned(dist_y * 100, dividendo2'length));
										divisor2 <= std_logic_vector(to_unsigned(dist_z, divisor2'length));
								end case;
								-- Marcamos el comienzo de la division para que realice el calculo
								-- Manejamos estados ya que dicha division puede llevar varios ciclos de reloj
								in_signal1 <= '1';
								in_signal2 <= '1';
								div_state := waiting;
						when waiting => 
							-- Esperamos a que acabe la division
							if out_signal1 = '1' and out_signal2 = '1' then
								div_state := done;
							end if;
						when done =>
							-- Cuando se acaba la division leemos las velocidades
							div_state := none;
							
							case max is
								when x => 
									i_velocidad_x <= std_logic_vector(to_unsigned(vel_x, i_velocidad_x'length));
									if dist_y > 0 and unsigned(resultado1) = 0 then
										i_velocidad_y <= "00000001";
									else
										i_velocidad_y <= resultado1;
									end if;
									if dist_z > 0 and unsigned(resultado2) = 0 then
										i_velocidad_z <= "00000001";
									else
										i_velocidad_z <= resultado2;
									end if;
								when y =>
									i_velocidad_y <= std_logic_vector(to_unsigned(vel_y, i_velocidad_y'length));
									if dist_x > 0 and unsigned(resultado1) = 0 then
										i_velocidad_x <= "00000001";
									else
										i_velocidad_x <= resultado1;
									end if;
									if dist_z > 0 and unsigned(resultado2) = 0 then
										i_velocidad_z <= "00000001";
									else
										i_velocidad_z <= resultado2;
									end if;
								when z =>
									i_velocidad_z <= std_logic_vector(to_unsigned(vel_z, i_velocidad_z'length));
									if dist_x > 0 and unsigned(resultado1) = 0 then
										i_velocidad_x <= "00000001";
									else
										i_velocidad_x <= resultado1;
									end if;
									if dist_y > 0 and unsigned(resultado2) < 1 then
										i_velocidad_y <= "00000001";
									else
										i_velocidad_y <= resultado2;
									end if;
							end case;
							
							
							-- Reiniciamos el divisor a 0
							in_signal1 <= '0';
							in_signal2 <= '0';
							
							-- Volcamos los resultados en el bus
							i_coordenada_x <= coordenada_x;
							i_coordenada_y <= coordenada_y;
							i_coordenada_z <= coordenada_z;
							
							i_distancia_x <= std_logic_vector(to_unsigned(dist_x, i_distancia_x'length));
							i_distancia_y <= std_logic_vector(to_unsigned(dist_y, i_distancia_y'length));
							i_distancia_z <= std_logic_vector(to_unsigned(dist_z, i_distancia_z'length));
							
							-- Marcamos la instruccion como completada
							process_state := order_finished;
							
						end case;
					when "11" => -- H (halt)
						-- La orden para los motores
						i_reset_engines <= '1';
						process_state := order_finished;
					when others =>
						process_state := waiting_order;
				end case;
			elsif process_state = order_finished then
				if i_sending_order= '0' and i_reset_engines = '0' then
					-- Si se ha finalizado la orden y los motores han acabado su trabajo, enviamos la siguiente instruccion a los motores
					i_sending_order <= '1';
					-- Decimos que ya hemos terminado para que nos manden otra orden
					i_order_done <= '1';
					i_reset_engines <= '0';
				elsif i_reset_engines = '1' and processing_y = '0' and processing_z = '0' and i_sending_order = '0' then
					-- Si se ha finalizado la orden y los motores han acabado su trabajo, enviamos la siguiente instruccion a los motores
					i_sending_order <= '1';
					-- Decimos que ya hemos terminado para que nos manden otra orden
					i_order_done <= '1';
					i_reset_engines <= '0';
					i_sending_order <= '0';
				end if;
			end if;
			if processing_x = '1' and processing_y = '1' and processing_z = '1' and i_sending_order = '1' then
				-- si se ha acabado la instruccion decimos a los motores que hemos acabado
				i_sending_order <= '0';
			end if;
			if order_pending = '0' then
				i_order_done <= '0';
				process_state := waiting_order;
			end if;
		end if;
	end process;

end Behavioral;

