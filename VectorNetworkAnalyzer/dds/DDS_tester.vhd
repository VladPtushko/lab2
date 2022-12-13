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
	constant clk_period: time := 16 ns;
	signal clk_reg: std_logic := '1';

	procedure skiptime_clk(time_count: in integer) is
    begin
        count_time: for k in 0 to time_count-1 loop
            wait until falling_edge(clk_reg); 
            wait for 200 fs; --need to wait for signal stability, value depends on the Clk frequency. 
                        --For example, for Clk period = 100 ns (10 MHz) it's ok to wait for 200 ps.
        end loop count_time ;
    end;
	
	begin 
		clk_reg <= not clk_reg after clk_period/2;
		clk <= clk_reg;
		
		tester_process: process 
			begin 
				wait for 100 ns;
				nRst <= '0';
				
				skiptime_clk(2); 
				
				-- Ввод FTW
				nRst <= '1';
				WB_DataIn <= (12 => '1', others => '0');
				WB_Cyc <= '1';
				WB_Addr <= (0 => '1', 1 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "11";
				WB_CTI <= "000";
				
				skiptime_clk(2);
				
				-- Остановка ввода
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				
				-- Работа синтезатора
				wait for 1500 ns;
				
				-- Ввод clear = '1'
				WB_DataIn <= (0 => '1', others => '0');
				WB_Cyc <= '1';
				WB_Addr <= (others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				
				wait for clk_period;
				
				-- Остановка ввода
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				
				wait for 100 ns;
				
				-- Ввод clear = '0'
				WB_DataIn <= (others => '0');
				WB_Cyc <= '1';
				WB_Addr <= (others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				
				wait for clk_period;
				
				-- Остановка ввода
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				WB_CTI <= "000";
				
				wait for 1000 ns;
				
				-- Ввод enable = '1'
				nRst <= '1';
				WB_DataIn <= (1 => '1', others => '0');
				WB_Cyc <= '1';
				WB_Addr <= (others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				WB_CTI <= "000";
				
				skiptime_clk(2);
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				WB_CTI <= "000";
				
				wait for 2000 ns;
		end process;	

end architecture;