----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:14:18 07/12/2016 
-- Design Name: 
-- Module Name:    Test - Behavioral 
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

entity Test is
    Port (
		clk : in STD_LOGIC;
		RESET : in STD_LOGIC;
		-- VGA
		h_sync : out STD_LOGIC;
		v_sync : out STD_LOGIC;
		R : out STD_LOGIC_VECTOR (3 downto 0);
		G : out STD_LOGIC_VECTOR (3 downto 0);
		B : out STD_LOGIC_VECTOR (3 downto 0);
		-- Debug
		led : out STD_LOGIC;
	   ledout : out  STD_LOGIC_VECTOR (7 downto 0);
	   segmentout : out  STD_LOGIC_VECTOR (11 downto 0);
		-- Keyboard
	   kbclk : in  STD_LOGIC;
	   kbdata : in  STD_LOGIC;
		-- VGA Color Control
		set_color : in STD_LOGIC);
end Test;

architecture Behavioral of Test is

signal pixel_clk : STD_LOGIC;
signal displ_ena : STD_LOGIC;
signal column : INTEGER;
signal row : INTEGER;
signal char_column: STD_LOGIC_VECTOR(15 downto 0);
signal char_row: STD_LOGIC_VECTOR(15 downto 0);
signal ascii_char : STD_LOGIC_VECTOR (7 downto 0);
signal ascii_ready : STD_LOGIC;

signal read_address : STD_LOGIC_VECTOR (11 downto 0);
signal read_enable : STD_LOGIC := '0';
signal read_output : STD_LOGIC_VECTOR(7 downto 0);

signal write_address : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";
signal write_enable : STD_LOGIC := '0';
signal input : STD_LOGIC_VECTOR(7 downto 0);

signal write_to_ram_state : STD_LOGIC := '0';
signal set_pixel : STD_LOGIC := '0';

signal arrow_pressed : STD_LOGIC;
signal arrow : STD_LOGIC_VECTOR (1 downto 0);
signal cursor_blink_count : INTEGER;
signal rgb : STD_LOGIC_VECTOR (11 downto 0) := "111111111111";
signal write_pixel : STD_LOGIC;
begin

-- # VGA
pixel_clock : entity work.Counter generic map (4) port map (clk, RESET, '1', pixel_clk, open);

vga_module : entity work.vga_module 
	generic map (96, 48, 640, 16, 2, 29, 480, 10) 
	port map (pixel_clk, RESET, h_sync, v_sync, displ_ena, column, row);

character_ram : entity work.RAM generic map (12, 8, 1) port map (clk, RESET, read_address, read_enable, read_output, write_address, write_enable, input);

-- # RAM --> Font --> VGA --> Blink
-- Read the currently visible character from RAM, check for it's font representation and 
-- whether or not the current pixel is visible.
char_printer : entity work.CharPrinter 
	generic map (640, 480) 
	port map (clk, RESET, pixel_clk, column, row, set_pixel, read_address, read_output, read_enable);

cursor_blink : entity work.Counter generic map (100000000) port map (clk, RESET, '1', open, cursor_blink_count);

write_pixel <= not set_pixel when (write_address = read_address and cursor_blink_count < 50000000) else set_pixel;

rgb_generator : process
begin
	if RESET = '1' then
		R <= "0000";
		G <= "0000";
		B <= "0000";
	elsif rising_edge(clk) and pixel_clk = '1' then
		if displ_ena = '1' and write_pixel = '1' then
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
		end if;
	end if;
end process;


keyboard : entity work.KeyboardController port map (clk, RESET, kbclk, kbdata, open, segmentout, ascii_char, ascii_ready, arrow_pressed, arrow);

cursor_controller : entity work.CursorController port map (clk, RESET, arrow, arrow_pressed, write_address, ascii_ready);

char_to_ram_writer : process 
begin
	input <= ascii_char;
	if rising_edge(clk) then
		if write_to_ram_state = '1' then
			-- write_address <= std_logic_vector(unsigned(write_address) + 1);
			write_to_ram_state <= '0';
			write_enable <= '0';
		end if;
		if write_to_ram_state = '0' and ascii_ready = '1' then
			write_enable <= '1';
			write_to_ram_state <= '1';
		end if;
	end if;
end process;

led <= '1';
ledout <= write_address (7 downto 0);

end Behavioral;
