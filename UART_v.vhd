----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:19:02 05/05/2016 
-- Design Name: 
-- Module Name:    UART - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;

entity UART is
    Port ( 
		rx 			: in  STD_LOGIC; -- Cable de recepcion del PC
		tx 			: out  STD_LOGIC; -- Cable de envio al PC
      clk 			: in  STD_LOGIC; -- Reloj
      rst 			: in  STD_LOGIC; -- Reset
      brec 			: out  STD_LOGIC_VECTOR (7 downto 0); -- Bit completo recibido
      rec_pending : out  STD_LOGIC; -- flag de recibido
      rec_done 	: in  STD_LOGIC; -- flag de recibido leido
      btrans 		: in  STD_LOGIC_VECTOR (7 downto 0); -- Bit completo a enviar
      tstart 		: in  STD_LOGIC; -- flag de envio
      tdone 		: out  STD_LOGIC -- flag de envio completo
	);
end UART;

architecture Behavioral of UART is

	type MAQ_rec is (WAITING,WCENTER,REC); -- estados de recepcion
	signal recState: MAQ_rec := WAITING; -- estado inicial de recepcion
	
	type MAQ_tx is (WAITING,TRANSMITING,STOPPING); -- estados de emision
	signal transState: MAQ_tx := waiting; -- estado inicial de emision
	
	signal recibido: STD_LOGIC_VECTOR(7 downto 0) := "00000000"; -- Byte recibido
	signal RXF	:	std_logic_vector(1 downto 0) := (others=>'1'); -- Array para evitar metaestabilidad
	signal rec_pending_i : std_logic := '0';
	signal tdone_i : std_logic := '0';
	
	constant BRR	: integer := (50E6/9600)-1;	-- Ciclos celda de bit
	constant BRRM	: integer := BRR/2;				-- Ciclos media celda.
	
begin

	rec_pending <= rec_pending_i;
	
	-- Proceso filtrado RX para evitar metaestabilidad.
	process(clk,rst)
	begin
		if rst = '1' then
			RXF <= (others=>'1');
		elsif rising_edge(clk) then
			RXF <= RXF(0) & rx;
		end if;
	end process;
	
	process(clk,rst) -- Mensaje del PC a la FPGA (Maquina de recepcion).
		variable ticks:integer := 0;		-- Contador para reloj de recepcion
		variable position:integer := 0;	-- Indice de bit recibido.
	begin
		if rst = '1' then -- Si se habilita el reset se reinicia la comunicación
			recState <= WAITING;
			ticks := 0;
			position := 0;
			rec_pending_i <= '0';
		elsif rising_edge(CLK) then
			ticks := ticks + 1;
			if ticks > BRR then -- Si nos pasamos del tamano de celda empezamos a contar de nuevo (50Hz / 9600 baudios)
				ticks := 0;
			end if;
			
			if rec_done = '1' then -- Cuando se lee lo que hemos puesto en el vector de salida
				rec_pending_i <= '0'; -- volvemos a permitir la lectura
			end if;
			
			case recState is
				when WAITING => 	-- Esperando bit start.
					if RXF(1) = '0' then
						ticks := 0;
						recState <= WCENTER;
					end if;
				when WCENTER =>	-- Temporizamos al centro de celda del bit de start.
					if ticks = BRRM then
						if RXF(1) /= '0' then		-- Falso start por ruido.
							recState <= WAITING;
						else
							ticks := 0;
							position := 0;
							recState <= REC;
						end if;
					end if;
				when REC =>			-- Recibiendo dato.
					if ticks = BRR then
						if	position < 8 then
							recibido(position) <= RXF(1);
							position := position + 1;
						elsif RXF(1) = '1' then	-- Bit stop correcto.
							if rec_pending_i = '0' then	-- anterior ya retirado.
								brec <= recibido;
								rec_pending_i <= '1';
							end if;
							recState <= WAITING;
						end if;
					end if;
				when others =>
					recState <= WAITING;
			end case;
		end if;
	end process;

	tdone <= tdone_i;
	process(clk, rst) -- Mensaje de la FPGA al PC
		variable ticks:integer := 0; -- Contador de pulsos para controlar el reloj
		variable position:integer := 0; -- Posicion del bit a enviar
	begin
		IF rst = '1' THEN -- Si se habilita el reset se reinicia la comunicacion
			transState <= WAITING;
			tx <= '1';
			position := 0;
			ticks := 0;
			tdone_i <= '0';
		ELSIF rising_edge(CLK) THEN
			IF tstart = '0' THEN -- Hasta que no se habilita el flag de comienzo no se empieza a comunicar
				transState <= WAITING;
				tx <= '1';
				position := 0;
				ticks := 0;
				tdone_i <= '0';
			ELSE
				ticks := ticks + 1;
				IF ticks >  BRR THEN
					ticks := 0;
				END IF;
				
				IF ticks = BRR THEN
					CASE transState IS
						WHEN waiting =>
							tx <= '0'; -- Comenzamos la transmision con un bit a 0
							position := 0;
							transState <= transmiting;
						WHEN transmiting => -- Comenzamos a transmitir el byte bit a bit
							IF position < 8 THEN
								tx <= btrans(position);
								position := position + 1;
							ELSE
								tx <= '1'; -- cuando se llega al noveno bit se marca el stop con un 1
								transState <= stopping;
							END IF;
						WHEN stopping =>
							tx <= '1'; -- Segundo 1 consecutivo para marcar el fin de la transmision
							transState <= waiting; -- reiniciamos la comunicacion
							tdone_i <= '1'; -- Marcamos que ya se ha terminado
					END CASE;
				END IF;
			END IF;
		END IF;
	end process;
end Behavioral;
