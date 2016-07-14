----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:08:28 06/30/2016 
-- Design Name: 
-- Module Name:    Eingabemodul_OPW - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Eingabemodul_OPW is
    Port ( kbclk : in  STD_LOGIC;
           kbdata : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           Y : in  STD_LOGIC_VECTOR (3 downto 0);
           X : out  STD_LOGIC_VECTOR (1 downto 0);
           scancode : out  STD_LOGIC_VECTOR (7 downto 0);
			  ready : out STD_LOGIC);
end Eingabemodul_OPW;

architecture Behavioral of Eingabemodul_OPW is

signal Dclk : STD_LOGIC_VECTOR (1 downto 0);
signal Qclk : STD_LOGIC_VECTOR (1 downto 0);
signal DScan : STD_LOGIC_VECTOR (10 downto 0);
signal QScan : STD_LOGIC_VECTOR (10 downto 0);
signal Dcnt : STD_LOGIC_VECTOR (3 downto 0);
signal Qcnt : STD_LOGIC_VECTOR (3 downto 0);
signal DEMUX : STD_LOGIC_VECTOR (1 downto 0);

begin

bitregistersync_kbclk : entity work.DRegister generic map (2) port map (clk, RESET, '1', Dclk, Qclk);
bitregister_keyboard_data_loader : entity work.DRegister generic map (11) port map (clk, RESET, '1', DScan, QScan);
bitregister_counter : entity work.DRegister generic map (4) port map (clk, RESET, '1', Dcnt, Qcnt);

sync_kbclk : process (kbclk, RESET, qclk)
	begin
		Dclk <= kbclk & Qclk(1);
		X(0) <= not(Qclk(1)) and Qclk(0);
end process sync_kbclk;

keyboard_data_loader : process (Y, kbdata, clk, RESET, qscan)
	begin
		case Y(0) is
			when '0' => DScan <= QScan;
			when others => Dscan <= kbdata & QScan (10 downto 1);
		end case;
		scancode <= QScan (8 downto 1);
end process keyboard_data_loader;

counter : process (Y, clk, RESET, Qcnt, DEMUX)
	begin
		DEMUX <= Y(2) & Y(1);
		case DEMUX is
			when "00" => Dcnt <= Qcnt;
			when "01" => Dcnt <= "0000";
			when others => Dcnt <= Qcnt + "0001";
		end case;
		if Qcnt = "1011" then
			X(1) <= '1';
		else 
			X(1) <= '0';
		end if;
end process counter;

ready <= Y(3);

end Behavioral;