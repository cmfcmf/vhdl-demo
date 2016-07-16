----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:48:14 07/15/2016 
-- Design Name: 
-- Module Name:    MemoryModule - Behavioral 
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

entity MemoryModule is
Port (
	clk : in STD_LOGIC;
	RESET : in STD_LOGIC;
	ascii_ready : in STD_LOGIC;
	ascii_char : in STD_LOGIC_VECTOR (7 downto 0)
);
end MemoryModule;

architecture Behavioral of MemoryModule is

signal cr_read_address : STD_LOGIC_VECTOR (11 downto 0);
signal cr_read_enable : STD_LOGIC := '0';
signal cr_read_output : STD_LOGIC_VECTOR(7 downto 0);
signal cr_write_address : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";
signal cr_write_enable : STD_LOGIC := '0';
signal cr_input : STD_LOGIC_VECTOR(7 downto 0);

signal nc_read_address : STD_LOGIC_VECTOR (9 downto 0);
signal nc_read_enable : STD_LOGIC := '0';
signal nc_read_output : STD_LOGIC_VECTOR(35 downto 0);
signal nc_write_address : STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
signal nc_write_enable : STD_LOGIC := '0';
signal nc_input : STD_LOGIC_VECTOR(35 downto 0);

signal lc_read_address : STD_LOGIC_VECTOR (9 downto 0);
signal lc_read_enable : STD_LOGIC := '0';
signal lc_read_output : STD_LOGIC_VECTOR(35 downto 0);
signal lc_write_address : STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
signal lc_write_enable : STD_LOGIC := '0';
signal lc_input : STD_LOGIC_VECTOR(35 downto 0);

signal ea_read_address : STD_LOGIC_VECTOR (9 downto 0);
signal ea_read_enable : STD_LOGIC := '0';
signal ea_read_output : STD_LOGIC_VECTOR(35 downto 0);
signal ea_write_address : STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
signal ea_write_enable : STD_LOGIC := '0';
signal ea_input : STD_LOGIC_VECTOR (35 downto 0);

signal ea_pointer : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";
signal current_char_pointer : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";

signal is_initialized : STD_LOGIC := '0';
begin
   -----------------------------------------------------------------------
   --  READ_WIDTH | BRAM_SIZE | READ Depth  | RDADDR Width |            --
   -- WRITE_WIDTH |           | WRITE Depth | WRADDR Width |  WE Width  --
   -- ============|===========|=============|==============|============--
   --    37-72    |  "36Kb"   |      512    |     9-bit    |    8-bit   --
   --    19-36    |  "36Kb"   |     1024    |    10-bit    |    4-bit   --
   --    19-36    |  "18Kb"   |      512    |     9-bit    |    4-bit   --
   --    10-18    |  "36Kb"   |     2048    |    11-bit    |    2-bit   --
   --    10-18    |  "18Kb"   |     1024    |    10-bit    |    2-bit   --
   --     5-9     |  "36Kb"   |     4096    |    12-bit    |    1-bit   --
   --     5-9     |  "18Kb"   |     2048    |    11-bit    |    1-bit   --
   --     3-4     |  "36Kb"   |     8192    |    13-bit    |    1-bit   --
   --     3-4     |  "18Kb"   |     4096    |    12-bit    |    1-bit   --
   --       2     |  "36Kb"   |    16384    |    14-bit    |    1-bit   --
   --       2     |  "18Kb"   |     8192    |    13-bit    |    1-bit   --
   --       1     |  "36Kb"   |    32768    |    15-bit    |    1-bit   --
   --       1     |  "18Kb"   |    16384    |    14-bit    |    1-bit   --
   -----------------------------------------------------------------------

character_ram : entity work.RAM 
	generic map (12, 8, 1) 
	port map (clk, RESET, cr_read_address, cr_read_enable, cr_read_output, cr_write_address, cr_write_enable, cr_input);

next_character_ram : entity work.RAM 
	generic map (10, 36, 4) 
	port map (clk, RESET, nc_read_address, nc_read_enable, nc_read_output, nc_write_address, nc_write_enable, nc_input);
	
last_character_ram : entity work.RAM 
	generic map (10, 36, 4) 
	port map (clk, RESET, lc_read_address, lc_read_enable, lc_read_output, lc_write_address, lc_write_enable, lc_input);

empty_addresses_ram : entity work.RAM
	generic map (10, 36, 4) 
	port map (clk, RESET, ea_read_address, ea_read_enable, ea_read_output, ea_write_address, ea_write_enable, ea_input);

write_char : process
variable write_state : STD_LOGIC_VECTOR (1 downto 0) := "00";
variable next_free_spaces : STD_LOGIC_VECTOR (35 downto 0);
variable next_free_space : STD_LOGIC_VECTOR (11 downto 0);
variable next_char_positions : STD_LOGIC_VECTOR (35 downto 0);
variable next_char_position : STD_LOGIC_VECTOR (11 downto 0);
variable new_next_pointers : STD_LOGIC_VECTOR (35 downto 0);
variable temp : INTEGER;
begin
	if RESET = '1' then
		write_state := "00";
	elsif rising_edge(clk) then
		if ascii_ready = '1' and write_state = "00" then
			ea_read_address <= ea_pointer (9 downto 0);
			ea_read_enable <= '1';
			
			nc_read_address <= current_char_pointer (9 downto 0);
			nc_read_enable <= '1';
			
			write_state := "01";
		elsif write_state = "01" then
			next_free_spaces := ea_read_output;
			if ea_pointer (11 downto 10) = "00" then
				next_free_space := next_free_spaces (35 downto 24);
			elsif ea_pointer (11 downto 10) = "01" then
				next_free_space := next_free_spaces (23 downto 12);
			else
				next_free_space := next_free_spaces (11 downto 0);
			end if;
			ea_read_enable <= '0';
			
			if ea_pointer (11 downto 10) = "10" then
				temp := to_integer(unsigned(ea_pointer (9 downto 0)));
				ea_pointer <= "00" & std_logic_vector(to_unsigned(temp + 1, 10));
			else
				temp := to_integer(unsigned(ea_pointer (11 downto 10)));
				ea_pointer <= std_logic_vector(to_unsigned(temp + 1, 2)) & (ea_pointer (9 downto 0));
			end if;
			
			cr_write_enable <= '1';
			cr_write_address <= next_free_space;
			cr_input <= ascii_char;
			
			next_char_positions := nc_read_output;
			if current_char_pointer (11 downto 10) = "00" then
				next_char_position := next_char_positions (35 downto 24);
			elsif current_char_pointer (11 downto 10) = "01" then
				next_char_position := next_char_positions (23 downto 12);
			else
				next_char_position := next_char_positions (11 downto 0);
			end if;
			nc_read_enable <= '0';
			
			nc_write_enable <= '1';
			nc_write_address <= current_char_pointer (9 downto 0);
			
			if current_char_pointer (11 downto 10) = "00" then
				new_next_pointers := next_free_space & next_char_positions (23 downto 0);
			elsif current_char_pointer (11 downto 10) = "01" then
				new_next_pointers := next_char_positions (35 downto 24) & next_free_space & next_char_positions (11 downto 0);
			else
				new_next_pointers := next_char_positions (35 downto 12) & next_free_space;
			end if;
			nc_input <= new_next_pointers;
			
			write_state := "10";
		elsif write_state = "10" then
			nc_write_enable <= '0';
		end if;
	end if;
end process;

init_empty_address_ram : process
variable counter : INTEGER := 0;
begin
	if RESET = '1' then
		is_initialized <= '0';
		counter := 0;
	elsif rising_edge(clk) and is_initialized = '0' then
		ea_write_address <= std_logic_vector(to_unsigned(counter, ea_write_address'length));
		ea_write_enable <= '1';
		ea_input <= std_logic_vector(to_unsigned(counter * 3, 12)) & std_logic_vector(to_unsigned(counter * 3 + 1, 12)) & std_logic_vector(to_unsigned(counter * 3 + 2, 12));
		
		counter := counter + 1;
	
		if counter >= 800 then
			is_initialized <= '1';
		end if;
	end if;
end process;

end Behavioral;

