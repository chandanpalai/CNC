-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY SecuenciadorTest IS
  END SecuenciadorTest;

  ARCHITECTURE behavior OF SecuenciadorTest IS 

	  -- Component Declaration
		COMPONENT Secuenciador
			PORT(
				instruccion : in  STD_LOGIC_VECTOR (1 downto 0);
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

		signal i_instruccion :  STD_LOGIC_VECTOR (1 downto 0);
		signal i_coordenada_x, i_coordenada_y, i_coordenada_z : STD_LOGIC_VECTOR (7 downto 0);
		signal i_processing_x, i_processing_y, i_processing_z : STD_LOGIC := '0';
		signal i_distancia_x, i_distancia_y, i_distancia_z : STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
		signal i_velocidad_x, i_velocidad_y, i_velocidad_z : STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
		signal i_direccion_x, i_direccion_y, i_direccion_z : STD_LOGIC := '0';
		signal i_sending_order : STD_LOGIC := '0';
		signal clk, reset, order_pending, reset_engines : std_logic := '0';
		signal order_done : std_logic := '1';
		
		
		type sending_status is (sending_recta, sending_halt, sending_reset, reset_afrer_recta, finishing);
      
		constant clk_period : time := 20 ns;

  BEGIN

  -- Component Instantiation
          uut: Secuenciador PORT MAP(
                  instruccion => i_instruccion,
						coordenada_x => i_coordenada_x,
						coordenada_y => i_coordenada_y,
						coordenada_z => i_coordenada_z,
						processing_x => i_processing_x,
						processing_y => i_processing_y,
						processing_z => i_processing_z,
						clk => clk,
						rst => reset,
						order_pending => order_pending,
						direccion_x => i_direccion_x,
						direccion_y => i_direccion_y,
						direccion_z => i_direccion_z,
						sending_order => i_sending_order,
						velocidad_x => i_velocidad_x,
						velocidad_y => i_velocidad_y,
						velocidad_z => i_velocidad_z,
						distancia_x => i_distancia_x,
						distancia_y => i_distancia_y,
						distancia_z => i_distancia_z,
						reset_engines => reset_engines,
						order_done => order_done
          );
		   -- Clock process definitions
		clk_process :process
		begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		end process;
		
		motores_delay: process
		begin
			if i_sending_order = '1' then
				wait for 30 ns;
				i_processing_x <= '1';
				i_processing_y <= '1';
				i_processing_z <= '1';
			else
				i_processing_x <= '0';
				i_processing_y <= '0';
				i_processing_z <= '0';
			end if;
			wait for 25 ns;
		end process;

  --  Test Bench Statements
     tb : PROCESS
		variable status : sending_status := sending_recta;
     BEGIN
			if order_done = '1' and order_pending = '1' then
				order_pending <= '0';
			elsif order_pending = '0' then
				case status is
				  when sending_recta =>
						i_instruccion <= "01";
						i_coordenada_x <= X"10";
						i_coordenada_y <= X"50";
						i_coordenada_z <= X"40";

						wait for 10 ns;

						i_coordenada_x <= X"10";
						i_coordenada_y <= X"50";
						i_coordenada_z <= X"40";
						
						wait for 10 ns;
						
						order_pending <= '1';
						status := sending_halt;
					when sending_halt =>
						i_instruccion <= "11";
						order_pending <= '1';
						status := sending_reset;
					when sending_reset => 
						i_instruccion <= "00";
						order_pending <= '1';
						status := reset_afrer_recta;
					when reset_afrer_recta => 
						i_instruccion <= "01";
						order_pending <= '1';
						wait for 5 ns;
						reset <= '1';
						wait for 100 ns;
						reset <= '0';
						status := finishing;
						wait for 100 ns;
					when finishing => 
						assert false report "Fin test" severity failure;
					when others => 
						assert false report "Fin test" severity failure;
				end case;
			end if;
			wait for 10 ns; 
     END PROCESS tb;
  --  End Test Bench 

  END;
