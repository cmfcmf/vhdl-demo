----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:44:00 07/15/2016 
-- Design Name: 
-- Module Name:    CursorController - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CursorController is
    Port (
		clk : in STD_LOGIC;
		RESET : in STD_LOGIC;
		arrow : in STD_LOGIC_VECTOR (1 downto 0);
	   arrow_pressed : in STD_LOGIC;
		write_address : inout STD_LOGIC_VECTOR (11 downto 0);
		ascii_ready : in STD_LOGIC
	 );
end CursorController;

architecture Behavioral of CursorController is
signal write_address_t : INTEGER;
signal increment_ram_address : STD_LOGIC := '0';
begin

controller : process
begin
	write_address_t <= to_integer(unsigned(write_address));		
	if RESET = '1' then
		write_address <= "000000000000";
	elsif rising_edge(clk) then
		if increment_ram_address = '1' then
			write_address_t <= write_address_t + 1;
			increment_ram_address <= '0';
		end if;
		if arrow_pressed = '1' then
			if arrow = "00" then -- Up arrow
				if write_address_t >= 80 then
					write_address_t <= write_address_t - 80;
				end if;
			elsif arrow = "01" then -- Left arrow
				if write_address_t /= 0 then
					write_address_t <= write_address_t - 1;
				end if;
			elsif arrow = "10" then -- Down arrow
				if write_address_t < 2320 then
					write_address_t <= write_address_t + 80;
				end if;
			elsif arrow = "11" then -- Right arrow
				if write_address_t < 2399 then
					write_address_t <= write_address_t + 1;
				end if;
			end if;
		elsif ascii_ready = '1' then
			if write_address_t < 2559 then
				increment_ram_address <= '1';
			end if;
		end if;
	end if;
	write_address <= std_logic_vector(to_unsigned(write_address_t, write_address'length));
end process;

end Behavioral;

