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
		h_sync : out STD_LOGIC;
		v_sync : out STD_LOGIC;
		R : out STD_LOGIC_VECTOR (3 downto 0);
		G : out STD_LOGIC_VECTOR (3 downto 0);
		B : out STD_LOGIC_VECTOR (3 downto 0);
		clk : in STD_LOGIC;
		RESET : in STD_LOGIC;
		rxd : in STD_LOGIC;
		led : out STD_LOGIC;
	   kbclk : in  STD_LOGIC;
	   kbdata : in  STD_LOGIC;
	   ledout : out  STD_LOGIC_VECTOR (7 downto 0);
	   segmentout : out  STD_LOGIC_VECTOR (11 downto 0));
end Test;

architecture Behavioral of Test is

signal pixel_clk : STD_LOGIC;
signal displ_ena : STD_LOGIC;
signal output_test : STD_LOGIC_VECTOR (7 downto 0);
signal column : INTEGER;
signal row : INTEGER;
signal char_column: STD_LOGIC_VECTOR(15 downto 0);
signal char_row: STD_LOGIC_VECTOR(15 downto 0);
signal uart_data : STD_LOGIC_VECTOR(7 downto 0);
signal uart_data_ok : STD_LOGIC;
signal ascii_char : STD_LOGIC_VECTOR (7 downto 0);
signal ascii_ready : STD_LOGIC;


signal read_address : STD_LOGIC_VECTOR (11 downto 0);
signal read_enable : STD_LOGIC := '0';
signal read_output : STD_LOGIC_VECTOR(7 downto 0);

signal write_address : STD_LOGIC_VECTOR (11 downto 0);
signal write_enable : STD_LOGIC := '0';
signal input : STD_LOGIC_VECTOR(7 downto 0);

signal write_to_ram_state : STD_LOGIC := '0';
signal tmp : STD_LOGIC_VECTOR (31 downto 0);
signal set_pixel : STD_LOGIC := '0';
begin

pixel_clock : entity work.Counter generic map (4) port map (clk, RESET, '1', pixel_clk, open);

vga_module : entity work.vga_module 
	generic map (96, 48, 640, 16, 2, 29, 480, 10) 
	port map (pixel_clk, RESET, h_sync, v_sync, displ_ena, column, row);

character_ram : entity work.RAM port map (clk, RESET, read_address, read_enable, read_output, write_address, write_enable, input);

char_printer : entity work.CharPrinter 
	generic map (640, 480) 
	port map (clk, RESET, pixel_clk, column, row, set_pixel, read_address, read_output, read_enable);

rgb_generator : process
begin
	if RESET = '1' then
		R <= "0000";
		G <= "0000";
		B <= "0000";
	elsif rising_edge(pixel_clk) then
		if displ_ena = '1' and set_pixel = '1' then
			R <= "1111";
			G <= "1111";
			B <= "1111";
		else
			R <= "0000";
			G <= "0000";
			B <= "0000";
		end if;
	end if;
end process;

led <= '1';

keyboard : entity work.KeyboardController port map (clk, RESET, kbclk, kbdata, open, segmentout, ascii_char, ascii_ready);

char_to_ram_writer : process 
begin
	input <= ascii_char;
	if rising_edge(clk) then
		if write_to_ram_state = '1' then
			write_address <= std_logic_vector(unsigned(write_address) + 1);
			write_to_ram_state <= '0';
			write_enable <= '0';
		end if;
		if write_to_ram_state = '0' and ascii_ready = '1' then
			write_enable <= '1';
			write_to_ram_state <= '1';
		end if;
	end if;
end process;

ledout <= write_address (7 downto 0);

end Behavioral;
