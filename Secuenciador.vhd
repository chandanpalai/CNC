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
--use IEEE.STD_LOGIC_ARITH.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Secuenciador is
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
end Secuenciador; 

architecture Behavioral of Secuenciador is
	signal i_coordenada_x, i_coordenada_y, i_coordenada_z : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_coordenada_destino_x, i_coordenada_destino_y, i_coordenada_destino_z : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
	signal i_distancia_x : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_distancia_y : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_distancia_z : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
	signal i_velocidad_x : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_velocidad_y : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal i_velocidad_z : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
	type max_possibles is (x, y, z);
	type division_states is (none, waiting, done);
	type process_states is (waiting_order, process_order, process_reset, order_finished);
	signal dividendo1, dividendo2, resto1, resto2 : STD_LOGIC_VECTOR(13 downto 0);
	signal resultado1, resultado2, divisor1, divisor2: STD_LOGIC_VECTOR (7 downto 0);
	signal in_signal1, in_signal2, out_signal1, out_signal2 : STD_LOGIC := '0';
	signal i_instruccion : STD_LOGIC_VECTOR(1 downto 0);
	signal i_reset_engines, i_sending_order : STD_LOGIC := '0';
	
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
	
	div1 : divisor PORT MAP(
		dividendo => dividendo1,
		divisor => divisor1,
		in_signal => in_signal1,
		clk => clk,
		resultado => resultado1,
		resto => resto1,
		out_signal => out_signal1
	);
	
	div2 : divisor PORT MAP(
		dividendo => dividendo2,
		divisor => divisor2,
		in_signal => in_signal2,
		clk => clk,
		resultado => resultado2,
		resto => resto2,
		out_signal => out_signal2
	);
	
	process (clk, rst)
		variable max : max_possibles;
		variable div_state : division_states := none;
		variable process_state : process_states := waiting_order;
		variable coord_x, coord_y, coord_z : integer := 0;
		variable i_coord_x, i_coord_y, i_coord_z : integer := 0;
		variable dist_x, dist_y, dist_z : integer := 0;
		variable vel_x, vel_y, vel_z : integer range 0 to 100:= 100;
		constant cien : integer range 0 to 100 := 100;
	begin
		if rising_edge(clk) then
			if rst = '1' and process_state /= process_reset and process_state /= order_finished then
				i_instruccion <= "00";
				process_state := process_order;
				order_done <= '0';
			elsif process_state = waiting_order and order_pending = '1' then
				i_instruccion <= instruccion;
				process_state := process_order;
				i_coordenada_destino_x <= coordenada_x;
				i_coordenada_destino_y <= coordenada_y;
				i_coordenada_destino_z <= coordenada_z;
				order_done <= '0';
			elsif process_state = process_order or process_state = process_reset then
				case i_instruccion is
					when "00" => -- R (reset)
						i_instruccion <= "01";
						i_coordenada_destino_x <= (others => '0');
						i_coordenada_destino_y <= (others => '0');
						i_coordenada_destino_z <= (others => '0');
					when "01" => -- S	(recta)
						case div_state is
							when none =>
								coord_x := to_integer(unsigned(i_coordenada_destino_x));
								coord_y := to_integer(unsigned(i_coordenada_destino_y));
								coord_z := to_integer(unsigned(i_coordenada_destino_z));
								
								i_coord_x := to_integer(unsigned(i_coordenada_x));
								i_coord_y := to_integer(unsigned(i_coordenada_y));
								i_coord_z := to_integer(unsigned(i_coordenada_z));
								
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
								in_signal1 <= '1';
								in_signal2 <= '1';
								div_state := waiting;
						when waiting => 
							if out_signal1 = '1' and out_signal2 = '1' then
								div_state := done;
							end if;
						when done =>
							div_state := none;
							case max is
								when x => 
									i_velocidad_x <= std_logic_vector(to_unsigned(vel_x, i_velocidad_x'length));
									i_velocidad_y <= std_logic_vector(unsigned(resultado1));
									i_velocidad_z <= std_logic_vector(unsigned(resultado2));
								when y =>
									i_velocidad_y <= std_logic_vector(to_unsigned(vel_y, i_velocidad_y'length));
									i_velocidad_x <= std_logic_vector(unsigned(resultado1));
									i_velocidad_z <= std_logic_vector(unsigned(resultado2));
								when z =>
									i_velocidad_z <= std_logic_vector(to_unsigned(vel_z, i_velocidad_z'length));
									i_velocidad_x <= std_logic_vector(unsigned(resultado1));
									i_velocidad_y <= std_logic_vector(unsigned(resultado2));
							end case;
							
							in_signal1 <= '0';
							in_signal2 <= '0';
							
							i_coordenada_x <= coordenada_x;
							i_coordenada_y <= coordenada_y;
							i_coordenada_z <= coordenada_z;
							
							i_distancia_x <= std_logic_vector(to_unsigned(dist_x, i_distancia_x'length));
							i_distancia_y <= std_logic_vector(to_unsigned(dist_y, i_distancia_y'length));
							i_distancia_z <= std_logic_vector(to_unsigned(dist_z, i_distancia_z'length));
							
							process_state := order_finished;
							
						end case;
					when "10" => -- C (curva)
					when "11" => -- H (halt)
						i_reset_engines <= '1';
						process_state := order_finished;
					when others =>
						process_state := waiting_order;
				end case;
			elsif process_state = order_finished and processing_x = '0' and processing_y = '0' and processing_z = '0' and order_pending = '1' then
				i_sending_order <= '1';
				order_done <= '1';
				i_reset_engines <= '0';
				process_state := waiting_order;
			end if;
			if processing_x = '0' and processing_y = '0' and processing_z = '0' and i_sending_order = '1' then
				i_sending_order <= '0';
			end if;
		end if;
	end process;

end Behavioral;

