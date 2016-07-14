----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:03:37 07/09/2016 
-- Design Name: 
-- Module Name:    Ausgabemodul_STK - Behavioral 
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

entity Ausgabemodul_STK is
    Port ( scancode : in  STD_LOGIC_VECTOR (7 downto 0);
           ready : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           ledout : out  STD_LOGIC_VECTOR (7 downto 0);
           segmentout : out  STD_LOGIC_VECTOR (11 downto 0);
			  actual_char_read : out STD_LOGIC);
end Ausgabemodul_STK;

architecture Behavioral of Ausgabemodul_STK is
signal E0 : STD_LOGIC;
signal F0 : STD_LOGIC;
signal CE : STD_LOGIC;
signal ready_int : STD_LOGIC;
begin

	stw : entity work.Ausgabemodul_STW port map (RESET, ready_int, E0, F0, clk, CE);
	opw : entity work.Ausgabemodul_OPW port map (scancode, ready, RESET, clk, CE, segmentout, ledout, ready_int, E0, F0);

	actual_char_read <= CE;
end Behavioral;

