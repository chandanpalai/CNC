----------------------------------------------------------------------------------
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
			  order_pending: out std_logic
			  );
end assembler;

architecture behavioral of assembler is

--variables , señales y tipos de datos.
type state is ( waiting, processing, recta, calculo ,dx, dy, dz, waiting_to_send, e_reset, halt);
type transmision is (espera, transmite1, transmite2);

signal estado: state:= waiting;
signal transmitir: transmision:= espera;
signal i_dato_x, i_dato_y, i_dato_z, i_btrans: std_logic_vector (7 downto 0) := (others => '0');
signal i_rec_done, i_tstart, i_order: std_logic:='0';

constant letra_o: std_logic_vector (7 downto 0) := x"4b";
constant letra_k: std_logic_vector(7 downto 0):= x"4f";
--variables y señales.

begin

	datox <= i_dato_x;
	datoy <= i_dato_y;
	datoz <= i_dato_z;
	btrans <= i_btrans;
	rec_done <= i_rec_done;
	tstart <= i_tstart;
	order_pending <= i_order;

	process(clk, reset)
		--variables y señales
		variable contador,num_datos: integer range 0 to 3:=0;
		variable dato: integer range 0 to 255:=0;
		variable resultado_entero3,resultado_entero2,resultado_entero1, total: integer range 0 to 255:=0;
		variable resul_unsig: unsigned(7 downto 0):=(others=>'0');
		--variables y señales
	begin		
		if reset = '0' then
			if (rising_edge(clk)) then
				if rec_pending = '0' then
					i_rec_done <= '0';
				elsif rec_pending = '1' then
					case estado is
						when waiting => 
							if order_done = '0' and i_order = '0' then
								estado <= processing;
							end if;
						when processing => 
							CASE brec IS
								WHEN "01010011" => --RECTA 10
									estado<=recta;
								WHEN "01010010" => --RESET 00
									estado<= e_reset;
								WHEN "01001000" => --HALT  11
									estado<= halt;
								WHEN OTHERS => --OTHERS
									estado<=waiting;
							end case;
							i_rec_done <= '1';
						when recta =>
							instruccion<="01";
							if Brec(7 downto 4) = "0011" then
								estado<=calculo;
								dato:= to_integer(unsigned(brec(3 downto 0)));
							else
								estado<=waiting;
							end if;						
						when calculo =>
							case contador is
								when 0 =>
									resultado_entero3:=dato*100;  --dato x 100
									estado<=recta;
									contador:=contador+1;
								when 1 =>
									dato:=to_integer(unsigned(brec(3 downto 0)));
									resultado_entero2:=dato*10;  --dato x 10
									contador:=contador+1;
									estado<=recta;
								when 2 =>
									dato:=to_integer(unsigned(brec(3 downto 0)));
									resultado_entero1:=dato; -- dato
									contador:=contador+1;
									estado<=recta;
								when 3 =>
									dato:=to_integer(unsigned(brec(3 downto 0)));
									resultado_entero1:=dato;
									if num_datos = 0 then
										estado<=dx;
										contador:=0;
									elsif num_datos = 1 then
										estado<=dy;
										contador:=0;
									elsif num_datos = 2 then 
										estado<=dz;
										contador:=0;
									end if;
								when others =>
									estado <= waiting;
							end case;
							WHEN dx =>
								dato:=to_integer(unsigned(brec(3 downto 0)));
								resultado_entero1:=dato;
								total:=resultado_entero1+resultado_entero2+resultado_entero3;
								i_dato_x<=std_logic_vector(to_unsigned(total,i_dato_x'length));
								num_datos:=num_datos+1;
								estado<=recta;
								i_rec_done <= '1';
							WHEN dy =>
								resultado_entero1:=dato;
								total:=resultado_entero1+resultado_entero2+resultado_entero3;
								i_dato_y<=std_logic_vector(to_unsigned(total,i_dato_y'length));
								num_datos:=num_datos+1;
								estado<=recta;
								i_rec_done <= '1';
							WHEN dz =>
								dato:=to_integer(unsigned(brec(3 downto 0)));
								resultado_entero1:=dato;
								total:=resultado_entero1+resultado_entero2+resultado_entero3;
								i_dato_z<=std_logic_vector(to_unsigned(total,i_dato_z'length));
								i_rec_done <= '1';
								estado<=waiting_to_send;
							WHEN e_reset => --RESET
								instruccion <= "00";						
								i_rec_done <= '1';
								estado<=waiting_to_send;
							WHEN halt => --HALT
								instruccion <= "11";						
								i_rec_done <= '1';
								estado<=waiting_to_send;
							WHEN waiting_to_send =>
								i_order <= '1';
								estado <= waiting;
							WHEN OTHERS =>
								estado<=waiting;
					end case;
				end if;
			end if;
		else 
			estado <=waiting;
			i_dato_x <="00000000";
			i_dato_y <="00000000";
			i_dato_z <="00000000";
			i_rec_done <='0';
			i_order <= '0';
		end if;
	end process;
	
	i: process(clk) 
	begin
		if rising_edge(clk) then
			case transmitir is
				when espera => 
					if t_done = '0' and i_order = '1' and order_done = '1' then
						transmitir <= transmite1;
					elsif
						t_done = '1' and i_tstart = '1' then
						i_tstart <= '0';
					end if;
				when transmite1 => 
					i_btrans<=letra_o;
					i_tstart<='1';
					transmitir<=transmite2;
				when transmite2 =>
					if t_done = '1' and i_tstart = '0' then
						i_btrans<=letra_k;
						i_tstart <= '1';
						transmitir <= espera;
					elsif i_tstart = '1' then
						i_tstart<='0';
					end if;
				end case;
		end if;
	end process;
	
end behavioral;