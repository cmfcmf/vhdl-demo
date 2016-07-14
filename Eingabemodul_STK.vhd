----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:41:23 06/30/2016 
-- Design Name: 
-- Module Name:    Eingabemodul_STK - Behavioral 
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

entity Eingabemodul_STK is
    Port ( clk : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           kbclk : in  STD_LOGIC;
           kbdata : in  STD_LOGIC;
           scancode : out  STD_LOGIC_VECTOR (7 downto 0);
           ready : out  STD_LOGIC);
end Eingabemodul_STK;

architecture Behavioral of Eingabemodul_STK is
signal Ausgabe_STW : STD_LOGIC_VECTOR (3 downto 0);
signal Eingabe_STW : STD_LOGIC_VECTOR (1 downto 0);
begin

	opw : entity work.Eingabemodul_OPW port map (kbclk, kbdata, RESET, clk, Ausgabe_STW, Eingabe_STW, scancode, ready);
	stw : entity work.Eingabemodul_STW port map (Eingabe_STW, Ausgabe_STW);

end Behavioral;

