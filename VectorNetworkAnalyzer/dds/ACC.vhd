library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ACC is
	port
	(
		clk		: in	std_logic;
		nRst		: in	std_logic;
		enable	: in 	std_logic; -- '1' to disable
		clear		: in	std_logic;
		FTW		: in	std_logic_vector(31 downto 0);
		ACC_in	: in	std_logic_vector(31 downto 0);
		
		ACC_out	: out	std_logic_vector(31 downto 0)
	);
end ACC;

architecture Behavioral of ACC is

begin

	process(clk, nRst, clear, ACC_in, FTW, enable) 
	begin
		if(nRst = '0' or clear = '1') then
			ACC_out <= (others => '0');
		elsif(rising_edge(clk) and enable = '0') then
			ACC_out <= ACC_in + FTW;
		end if;
	end process;

end Behavioral;