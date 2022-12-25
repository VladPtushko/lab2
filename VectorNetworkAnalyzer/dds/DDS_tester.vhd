library ieee;
use ieee.std_logic_1164.all;

entity DDS_tester is 
	port (
		clk	: out std_logic;
		nRst	: out std_logic;
		WB_Addr		: out	std_logic_vector(15 downto 0);
		WB_DataIn	: out	std_logic_vector(15 downto 0);
		WB_WE			: out	std_logic;
		WB_Sel		: out	std_logic_vector(1 downto 0);
		WB_STB		: out	std_logic;
		WB_Cyc		: out	std_logic;
		WB_CTI		: out	std_logic_vector(2 downto 0)
	);
end entity DDS_tester;

architecture a_DDS_tester of DDS_tester is 
	constant clk_period: time := 16666667 fs;
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
		clk <= clk_r;
		
		tester_process: process 
			begin 
				WB_Addr <= (others => '0');
				WB_DataIn <= (others => '0');
				WB_WE  <= '0';
				WB_Sel <= (others => '0');
				WB_STB <= '0';
				WB_Cyc <= '0';
				WB_CTI <= (others => '0');
				nRst <= '1';
				
				skiptime_clk(5);
				
				-- Сброс
				nRst <= '0';
				skiptime_clk(2);
				nRst <= '1';
				
				skiptime_clk(3);
				
				-- Ввод FTW
				WB_WE <= '1';
				WB_STB <= '1';
				WB_CTI <= "000";
				WB_Cyc <= '1';
				WB_DataIn <= (11 => '1', others => '0');
				WB_Addr <= (0 => '1', 1 => '1', others => '0');
				WB_Sel <= "11";
				skiptime_clk(2);
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				
				-- Работа синтезатора
				skiptime_clk(88);
				
				-- Ввод clear = '1'
				WB_WE <= '1';
				WB_STB <= '1';
				WB_CTI <= "000";
				WB_Cyc <= '1';
				WB_DataIn <= (0 => '1', others => '0');
				WB_Addr <= (others => '0');
				WB_Sel <= "01";
				skiptime_clk(1);
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				
				-- Синтезатор не работает 100 ms затем продолжает работу
				skiptime_clk(63);
				
				-- Увеличение частотного слова
				WB_WE <= '1';
				WB_STB <= '1';
				WB_CTI <= "000";
				WB_Cyc <= '1';
				WB_DataIn <= (13 => '1', others => '0');
				WB_Addr <= (0 => '1', 1 => '1', others => '0');
				WB_Sel <= "11";
				skiptime_clk(2);
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				
				skiptime_clk(88);
				
				-- Ввод enable = '1'
				WB_WE <= '1';
				WB_STB <= '1';
				WB_CTI <= "000";
				WB_Cyc <= '1';
				WB_DataIn <= (1 => '1', others => '0');
				WB_Addr <= (others => '0');
				WB_Sel <= "01";
				skiptime_clk(2);
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				
				skiptime_clk(2);
				
				-- Мастер считывает с раба
				WB_WE <= '0';
				WB_STB <= '1';
				WB_CTI <= "000";
				WB_Cyc <= '1';
				WB_Addr <= (others => '0');
				WB_Sel <= "01";
				skiptime_clk(2);
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				
				skiptime_clk(5);
				
				WB_WE <= '0';
				WB_STB <= '1';
				WB_CTI <= "000";
				WB_Cyc <= '1';
				WB_Addr <= x"0003";
				WB_Sel <= "11";
				skiptime_clk(2);
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				
				skiptime_clk(100);
		end process;	

end architecture;