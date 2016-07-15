----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:17:36 07/09/2016 
-- Design Name: 
-- Module Name:    KeyboardController - Behavioral 
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

entity KeyboardController is
    Port ( 
           clk : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
			  kbclk : in  STD_LOGIC;
           kbdata : in  STD_LOGIC;
           ledout : out  STD_LOGIC_VECTOR (7 downto 0);
           segmentout : out  STD_LOGIC_VECTOR (11 downto 0);
			  ascii_char : out STD_LOGIC_VECTOR (7 downto 0);
			  ascii_ready : out STD_LOGIC;
			  arrow_pressed : out STD_LOGIC;
			  arrow : out STD_LOGIC_VECTOR (1 downto 0));
end KeyboardController;

architecture Behavioral of KeyboardController is	
	signal scancode : STD_LOGIC_VECTOR (7 downto 0);
	signal ready : STD_LOGIC;
	signal key_pressed : STD_LOGIC;
begin

	eingabe : entity work.Eingabemodul_STK port map (clk, RESET, kbclk, kbdata, scancode, ready);
	ausgabe : entity work.Ausgabemodul_STK port map (scancode, ready, RESET, clk, ledout, segmentout, key_pressed);
	
	control_process : process
	begin
		if rising_edge(clk) then
			if key_pressed = '1' then
				ascii_ready <= '0';
				arrow_pressed <= '1';
				if scancode = X"75" then -- Up arrow
					arrow <= "00";
				elsif scancode = X"6B" then -- Left arrow
					arrow <= "01";
				elsif scancode = X"72" then -- Down arrow
					arrow <= "10";
				elsif scancode = X"74" then -- Right arrow
					arrow <= "11";
				else
					arrow_pressed <= '0';
					ascii_ready <= '1';
				end if;
			else
				ascii_ready <= '0';
				arrow_pressed <= '0';
			end if;
		end if;
	end process;
	
	converter : entity work.ScancodeToAscii port map (scancode, ascii_char);
	
end Behavioral;

