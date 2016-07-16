----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:29:24 07/16/2016 
-- Design Name: 
-- Module Name:    RGBGenerator - Behavioral 
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

entity RGBGenerator is
	Port(
		pixel_clk : in STD_LOGIC;
		RESET : in STD_LOGIC;
		display_enable : in STD_LOGIC;
		write_pixel : in STD_LOGIC;
		rgb : in STD_LOGIC_VECTOR (11 downto 0);
		R : out STD_LOGIC_VECTOR (3 downto 0);
		G : out STD_LOGIC_VECTOR (3 downto 0);
		B : out STD_LOGIC_VECTOR (3 downto 0)
	);
end RGBGenerator;

architecture Behavioral of RGBGenerator is

begin

rgb_generator : process
begin
	if RESET = '1' then
		R <= "0000";
		G <= "0000";
		B <= "0000";
	elsif rising_edge(pixel_clk) then
		if display_enable = '1' and write_pixel = '1' then
			R <= rgb (11 downto 8);
			G <= rgb (7 downto 4);
			B <= rgb (3 downto 0);
		else 
			R <= "0000";
			G <= "0000";
			B <= "0000";
		end if;
	end if;
end process;

end Behavioral;

