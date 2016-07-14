----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:42:38 07/13/2016 
-- Design Name: 
-- Module Name:    Counter - Behavioral 
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

entity Counter is
	 Generic (
		 max  :  INTEGER   := 10
	 );
    Port ( clk : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           max_reached : out  STD_LOGIC;
			  count : out  INTEGER);
end Counter;

architecture Behavioral of Counter is
signal current : INTEGER := 0;
begin

count <= current;
max_reached <= '1' when current = (max - 1) else '0';

count_process : process
begin
	if RESET = '1' then
		current <= 0;
	elsif rising_edge(clk) and enable = '1' then
		if current < (max - 1) then
			current <= current + 1;
		else
			current <= 0;
		end if;
	end if;
end process;

end Behavioral;

