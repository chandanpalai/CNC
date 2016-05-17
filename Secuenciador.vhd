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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Secuenciador is
    Port ( instruccion : in  STD_LOGIC_VECTOR (1 downto 0);
           coordenada_x : in  STD_LOGIC_VECTOR (23 downto 0);
           coordenada_y : in  STD_LOGIC_VECTOR (23 downto 0);
           coordenada_z : in  STD_LOGIC_VECTOR (23 downto 0);
           radio : in  STD_LOGIC_VECTOR (23 downto 0);
           distancia_x : out  STD_LOGIC_VECTOR (23 downto 0);
			  velocidad_x : in STD_LOGIC_VECTOR (23 downto 0);
			  direccion_x : in STD_LOGIC;
           distancia_y : out  STD_LOGIC_VECTOR (23 downto 0);
			  velocidad_y : in STD_LOGIC_VECTOR (23 downto 0);
			  direccion_y : in STD_LOGIC;
           distancia_z : out  STD_LOGIC_VECTOR (23 downto 0);
			  velocidad_z : in STD_LOGIC_VECTOR (23 downto 0);
			  direccion_z: in STD_LOGIC
	);
end Secuenciador;

architecture Behavioral of Secuenciador is
	signal coordenadas_x : STD_LOGIC_VECTOR(23 downto 0) := X"0";
	signal coordenadas_y : STD_LOGIC_VECTOR(23 downto 0) := X"0";
	signal coordenadas_z : STD_LOGIC_VECTOR(23 downto 0) := X"0";

begin

	process
	begin
		CASE instruccion IS
			WHEN "00" => -- R (reset)
				
			WHEN "01" => -- S	(recta)
			WHEN "10" => -- C (curva)
			WHEN "11" => -- H (halt)
		END CASE;
	end process;

end Behavioral;

