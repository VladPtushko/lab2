library ieee;
use ieee.std_logic_1164.all;

entity FGen is
	port(
		ACC_out		: in	std_logic_vector(31 downto 0);
		
		fADC			: out	std_logic;
		fDataFlow	: out	std_logic
	);
end FGen;

architecture Behavioral of FGen is

begin
	
	fADC <= ACC_out(31);
	fDataFlow <= ACC_out(30);

end Behavioral;
