----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:43 07/09/2016 
-- Design Name: 
-- Module Name:    Ausgabemodul_STW - Behavioral 
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

entity Ausgabemodul_STW is
    Port ( RESET : in  STD_LOGIC;
           ready : in  STD_LOGIC;
           E0 : in  STD_LOGIC;
           F0 : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           CE : out  STD_LOGIC);
end Ausgabemodul_STW;

architecture Behavioral of Ausgabemodul_STW is
signal state : STD_LOGIC;
begin

steuerwerk : process begin
	if RESET = '1' then
		state <= '0';
		CE <= '0';
	else
		CE <= (not state) and ready and (not E0) and (not F0);
		if clk'event and clk = '1' then
			if state = '0' then
				state <= ready and (not E0) and F0;
			else 
				state <= not ready;
			end if;
		end if;
	end if;
end process;

end Behavioral;

