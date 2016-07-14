----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:15:03 06/30/2016 
-- Design Name: 
-- Module Name:    VierBitRegister - Behavioral 
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

entity DRegister is
	 Generic (bits : INTEGER);
    Port ( clk : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
			  enable : in STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (bits downto 1);
           output : buffer  STD_LOGIC_VECTOR (bits downto 1)
	 );
end DRegister;


architecture Behavioral of DRegister is
begin 
	D_Reg : process(clk, RESET, input, output)
		begin
			if RESET = '1' then
				output <= (others => '0');
			end if;
			if clk'event and clk = '1' and enable = '1' then
				output <= input;
			end if;
	end process;

end Behavioral;