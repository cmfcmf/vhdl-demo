----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:57:54 07/13/2016 
-- Design Name: 
-- Module Name:    UART_RXD - Behavioral 
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

entity UART_RXD is
	Port (
		clk : in STD_LOGIC;
		RESET : in STD_LOGIC;
		rxd : in STD_LOGIC;
		data : out STD_LOGIC_VECTOR (7 downto 0);
		data_ok : out STD_LOGIC
	);
end UART_RXD;

architecture Behavioral of UART_RXD is
signal reading_data : STD_LOGIC := '0';
signal current_bit : INTEGER := 0;
signal rxd_clk : STD_LOGIC := '0';
begin

bit_counter : entity work.Counter generic map (100000) port map (clk, RESET, reading_data, rxd_clk, open);

empfang : process
begin
	if RESET = '1' then
		data <= "00000000";
		data_ok <= '0';
		current_bit <= 0;
		reading_data <= '0';
	else
		if reading_data = '0' and falling_edge(rxd) then
			reading_data <= '1';
			data <= "00000000";
			current_bit <= 0;
		end if;
		if rising_edge(clk) and reading_data = '0' then
			data_ok <= '0';
		end if;
		if rising_edge(rxd_clk) then
			-- Ignore start bit.
			if current_bit > 0 then
				data(current_bit) <= rxd;
			end if;
			current_bit <= current_bit + 1;
			if current_bit = 9 then
				reading_data <= '0';
				data_ok <= '1';
			end if;
		end if;
	end if;
end process;



end Behavioral;

