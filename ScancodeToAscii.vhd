----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:21:07 07/14/2016 
-- Design Name: 
-- Module Name:    ScancodeToAscii - Behavioral 
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

entity ScancodeToAscii is
    Port ( scancode : in  STD_LOGIC_VECTOR (7 downto 0);
           ascii : out  STD_LOGIC_VECTOR (7 downto 0));
end ScancodeToAscii;

architecture Behavioral of ScancodeToAscii is

begin

converter : process
begin
	CASE scancode IS
		WHEN x"29" => ascii <= x"20"; --space
		WHEN x"0D" => ascii <= x"09"; --tab (HT control code)
		WHEN x"5A" => ascii <= x"0D"; --enter (CR control code)         
		WHEN x"1C" => ascii <= x"41"; --A
		WHEN x"32" => ascii <= x"42"; --B
		WHEN x"21" => ascii <= x"43"; --C
		WHEN x"23" => ascii <= x"44"; --D
		WHEN x"24" => ascii <= x"45"; --E
		WHEN x"2B" => ascii <= x"46"; --F
		WHEN x"34" => ascii <= x"47"; --G
		WHEN x"33" => ascii <= x"48"; --H
		WHEN x"43" => ascii <= x"49"; --I
		WHEN x"3B" => ascii <= x"4A"; --J
		WHEN x"42" => ascii <= x"4B"; --K
		WHEN x"4B" => ascii <= x"4C"; --L
		WHEN x"3A" => ascii <= x"4D"; --M
		WHEN x"31" => ascii <= x"4E"; --N
		WHEN x"44" => ascii <= x"4F"; --O
		WHEN x"4D" => ascii <= x"50"; --P
		WHEN x"15" => ascii <= x"51"; --Q
		WHEN x"2D" => ascii <= x"52"; --R
		WHEN x"1B" => ascii <= x"53"; --S
		WHEN x"2C" => ascii <= x"54"; --T
		WHEN x"3C" => ascii <= x"55"; --U
		WHEN x"2A" => ascii <= x"56"; --V
		WHEN x"1D" => ascii <= x"57"; --W
		WHEN x"22" => ascii <= x"58"; --X
		WHEN x"35" => ascii <= x"5A"; --Y (swapped with Z for German layout)
		WHEN x"1A" => ascii <= x"59"; --Z (swapped with Y for German layout)
		WHEN x"45" => ascii <= x"30"; --0
		WHEN x"16" => ascii <= x"31"; --1
		WHEN x"1E" => ascii <= x"32"; --2
		WHEN x"26" => ascii <= x"33"; --3
		WHEN x"25" => ascii <= x"34"; --4
		WHEN x"2E" => ascii <= x"35"; --5
		WHEN x"36" => ascii <= x"36"; --6
		WHEN x"3D" => ascii <= x"37"; --7
		WHEN x"3E" => ascii <= x"38"; --8
		WHEN x"46" => ascii <= x"39"; --9
      WHEN OTHERS => NULL;
   END CASE;
end process;

end Behavioral;

