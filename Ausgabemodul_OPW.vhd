----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:29:41 07/09/2016 
-- Design Name: 
-- Module Name:    Ausgabemodul_OPW - Behavioral 
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

entity Ausgabemodul_OPW is
    Port ( scancode : in  STD_LOGIC_VECTOR (7 downto 0);
           ready_in : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           CE : in  STD_LOGIC;
           segmentout : out  STD_LOGIC_VECTOR (11 downto 0);
           ledout : buffer STD_LOGIC_VECTOR (7 downto 0);
           ready_out : out  STD_LOGIC;
           E0 : buffer STD_LOGIC;
           F0 : buffer STD_LOGIC);
end Ausgabemodul_OPW;

architecture Behavioral of Ausgabemodul_OPW is

signal E0_or_F0 : STD_LOGIC;
signal nach_scancode_mul : STD_LOGIC_VECTOR (7 downto 0);
signal segmentcode : STD_LOGIC_VECTOR (6 downto 0);
signal segmentcode_buffer_1 : STD_LOGIC_VECTOR (6 downto 0);
signal segmentcode_buffer_2 : STD_LOGIC_VECTOR (6 downto 0);
signal segmentcode_buffer_3 : STD_LOGIC_VECTOR (6 downto 0);
signal segmentcode_buffer_4 : STD_LOGIC_VECTOR (6 downto 0);
signal count : STD_LOGIC_VECTOR (13 downto 0);
signal count_inc : STD_LOGIC_VECTOR (13 downto 0);
signal segment : STD_LOGIC_VECTOR (1 downto 0);
begin

E0 <= '1' when scancode = "11100000" else '0';
F0 <= '1' when scancode = "11110000" else '0';
ready_out <= ready_in;

E0_or_F0 <= E0 or F0;

nach_scancode_mul <= scancode when (ready_in = '1' and E0_or_F0 = '0') else ledout;

nach_scancode_register : entity work.DRegister generic map (8) port map (clk, RESET, '1', nach_scancode_mul, ledout);

segmentcode <= "1000000" when scancode = "01000101" else -- 0
					"1111001" when scancode = "00010110" else 
					"0100100" when scancode = "00011110" else 
					"0110000" when scancode = "00100110" else 
					"0011001" when scancode = "00100101" else -- 4
					"0010010" when scancode = "00101110" else 
					"0000010" when scancode = "00110110" else 
					"1111000" when scancode = "00111101" else 
					"0000000" when scancode = "00111110" else
					"0010000" when scancode = "01000110" else -- 9
					"0001000" when scancode = "00011100" else -- A
					"0000011" when scancode = "00110010" else
					"1000110" when scancode = "00100001" else
					"0100001" when scancode = "00100011" else
					"0000110" when scancode = "00100100" else
					"0001110" when scancode = "00101011" else
					"1000001";

segment_buffer_1 : entity work.DRegister generic map (7) port map (clk, RESET, CE, segmentcode, segmentcode_buffer_1);
segment_buffer_2 : entity work.DRegister generic map (7) port map (clk, RESET, CE, segmentcode_buffer_1, segmentcode_buffer_2);
segment_buffer_3 : entity work.DRegister generic map (7) port map (clk, RESET, CE, segmentcode_buffer_2, segmentcode_buffer_3);
segment_buffer_4 : entity work.DRegister generic map (7) port map (clk, RESET, CE, segmentcode_buffer_3, segmentcode_buffer_4);

segment <= count(13) & count(12);
segmentout <= 
	"0111" & "1" & segmentcode_buffer_4 when segment = "11" else
	"1011" & "1" & segmentcode_buffer_3 when segment = "10" else
	"1101" & "1" & segmentcode_buffer_2 when segment = "01" else
	"1110" & "1" & segmentcode_buffer_1 when segment = "00";

count_inc <= std_logic_vector(unsigned(count) + 1);

counter_register : entity work.DRegister generic map (14) port map (clk, RESET, '1', count_inc, count);

end Behavioral;

