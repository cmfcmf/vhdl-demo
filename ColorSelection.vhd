----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:08:01 07/16/2016 
-- Design Name: 
-- Module Name:    ColorSelection - Behavioral 
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

entity ColorSelection is
	Port (
		clk : in STD_LOGIC;
		RESET : in STD_LOGIC;
		rgb : inout STD_LOGIC_VECTOR (11 downto 0);
		set_color : in STD_LOGIC;
		ascii_ready : in STD_LOGIC;
		ascii_char : in STD_LOGIC_VECTOR (7 downto 0)
	);
end ColorSelection;

architecture Behavioral of ColorSelection is

begin

color_selection : process
variable color_value : STD_LOGIC_VECTOR (3 downto 0);
begin
	if RESET = '1' then
		rgb <= "111111111111";
	elsif rising_edge(clk) then
		if set_color = '1' and ascii_ready = '1' then
			case ascii_char is
				when X"30" => color_value := "0000";
				when X"31" => color_value := "0001";
				when X"32" => color_value := "0010";
				when X"33" => color_value := "0011";
				when X"34" => color_value := "0100";
				when X"35" => color_value := "0101";
				when X"36" => color_value := "0110";
				when X"37" => color_value := "0111";
				when X"38" => color_value := "1000";
				when X"39" => color_value := "1001";
				when X"41" => color_value := "1010";
				when X"42" => color_value := "1011";
				when X"43" => color_value := "1100";
				when X"44" => color_value := "1101";
				when X"45" => color_value := "1110";
				when X"46" => color_value := "1111";
				when others => color_value := "0011";
			end case;
			
			rgb <= rgb (7 downto 0) & color_value;
		else
			rgb <= rgb;
		end if;
	end if;
end process;

end Behavioral;

