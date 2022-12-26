library ieee;
use ieee.std_logic_1164.all;

entity moving_average_tester is 
	port (
		i_clk			: out	std_logic;
		i_nRst		: out std_logic;
		i_data		: out	std_logic_vector(10-1 downto 0);
		MANumber		: out	std_logic_vector(32-1 downto 0);
		FilterCoeff	: out	std_logic_vector(16-1 downto 0)
	);
end entity moving_average_tester;

architecture a_moving_average_tester of moving_average_tester is 
	constant clk_period: time := 16 ns;
	signal clk_r: std_logic := '1';

	procedure skiptime_clk(time_count: in integer) is
	begin
		count_time: for k in 0 to time_count-1 loop
			wait until falling_edge(clk_r); 
			wait for 200 fs;
		end loop count_time ;
	end;
	
	begin 
		clk_r <= not clk_r after clk_period / 2;
		i_clk <= clk_r;
		
		tester_process: process 
			begin 
				wait for 100 ns;
				
				-- Сброс
				i_nRst <= '0';
				skiptime_clk(2);
				i_nRst <= '1';
				
				-- Вот
				
		end process;	

end architecture;