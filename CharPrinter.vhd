----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:46:53 07/14/2016 
-- Design Name: 
-- Module Name:    CharPrinter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CharPrinter is
	 Generic (
		 screen_width : INTEGER;
		 screen_height : INTEGER
	 );
    Port ( clk : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
			  pixel_clk : in STD_LOGIC;
           x : in INTEGER; -- actual pixel x coordinate
			  y : in INTEGER; -- actual pixel y coordinate
			  set_pixel : out STD_LOGIC; -- whether or not to draw the pixel.
			  read_address : out STD_LOGIC_VECTOR (11 downto 0);
			  read_output  : in STD_LOGIC_VECTOR (7 downto 0);
			  read_enable : out STD_LOGIC
	 );
end CharPrinter;

architecture Behavioral of CharPrinter is
signal char_column : STD_LOGIC_VECTOR (31 downto 0);
signal char_row : STD_LOGIC_VECTOR (31 downto 0);
signal char_row_shifted : STD_LOGIC_VECTOR (4 downto 0);
signal char_column_shifted : STD_LOGIC_VECTOR (6 downto 0);

signal state : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal t : INTEGER;
begin

char_column <= std_logic_vector(to_unsigned(x, char_column'length));
char_row <= std_logic_vector(to_unsigned(y, char_row'length));
char_row_shifted <= char_row (8 downto 4);
char_column_shifted <= char_column (9 downto 3);

t <= (to_integer(unsigned(char_row_shifted)) * 80) + to_integer(unsigned(char_column_shifted));
read_address <= std_logic_vector(to_unsigned(t, read_address'length));

font_rom : entity work.VgaCharacterRom port map (clk, RESET, read_output, char_column (2 downto 0), char_row (3 downto 0), '1', set_pixel);

print : process
begin
	if RESET = '1' then
		state <= "00";
		read_enable <= '0';
	elsif rising_edge(clk) then
		if state = "01" or pixel_clk = '1' then		
			read_enable <= '0';
			state <= "10";
		elsif state = "00" then
			read_enable <= '1';
			state <= "01";
		elsif state = "10" then
			read_enable <= '0';
			state <= "11";
		else
			read_enable <= '0';
			state <= "00";
		end if;
	end if;
end process;

end Behavioral;

