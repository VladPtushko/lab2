library ieee;
use ieee.std_logic_1164.all;
entity GSMRegistr_tester is
    port (
        WB_Addr : out std_logic_vector( 15 downto 0 );
        clk : out std_logic;
        WB_DataIn: out std_logic_vector( 15 downto 0 );
        nRst : out std_logic;
        WB_Sel: out std_logic_vector( 1 downto 0 );
        WB_STB : out std_logic;
        WB_WE: out std_logic;
		WB_Cyc		: out	std_logic;
		WB_CTI		: out	std_logic_vector(2 downto 0);
        
        rdreq : out STD_LOGIC
    );
end entity GSMRegistr_tester;

architecture rtl of GSMRegistr_tester is
	 constant clk_period: time := 16666667 fs;
    signal clk_r: std_logic := '0';

    procedure skiptime_clk(time_count: in integer) is
    begin
        count_time: for k in 0 to time_count-1 loop
            wait until rising_edge(clk_r); 
            wait for 200 ps; --need to wait for signal stability, value depends on the clk frequency. 
                        --For example, for clk period = 100 ns (10 MHz) it's ok to wait for 200 ps.
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
				
				skiptime_clk(10);
				
				-- Сброс
				nRst <= '0';
				skiptime_clk(5);
				nRst <= '1';
				
				skiptime_clk(10);
				
				--for address 0x0000
				WB_WE <= '1';
				WB_STB <= '1';
				WB_CTI <= "000";
				WB_Cyc <= '1';
				WB_DataIn <= "0110000010011100";
				WB_Addr <= (others => '0');
				WB_Sel <= "11";
				skiptime_clk(5);
				WB_DataIn <= "1000100000101001";
				WB_Cyc <= '1';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '1';
				WB_Sel <= "01";
				skiptime_clk(5);
				WB_DataIn <= "0010100100000000";
				WB_Cyc <= '1';
				WB_Addr <= (others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "10";
				skiptime_clk(10);
				
				--for 0x0200
				WB_WE <= '1';
				WB_STB <= '1';
				WB_CTI <= "001";
				WB_Cyc <= '1';
				WB_DataIn <= "0010100101011100";
				WB_Addr <= (9 => '1', others => '0');
				WB_Sel <= "01";
				
				skiptime_clk(5);
				
				WB_DataIn <= (others => '0');
				WB_Cyc <= '1';
				WB_Addr <= (9 => '1', others => '0');
				WB_WE <= '0';
				WB_STB <= '1';
				WB_Sel <= "10";
				
				skiptime_clk(10);
				--for 0x0202
				WB_DataIn <= "0010100101000100";
				WB_Cyc <= '1';
				WB_Addr <= (9,1 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "11";
				
				skiptime_clk(5);
				
				WB_DataIn <= "1010100101000100";
				WB_Cyc <= '1';
				WB_Addr <= (9,1 => '1', others => '0');
				WB_WE <= '0';
				WB_STB <= '1';
				WB_Sel <= "10";
				skiptime_clk(10);
				
				--for 0x0204
				WB_DataIn <= "0010100001011000";
				WB_Cyc <= '1';
				WB_Addr <= (9,2 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				
				skiptime_clk(5);
				
				WB_Cyc <= '1';
				WB_Addr <= (9,2 => '1', others => '0');
				WB_WE <= '0';
				WB_STB <= '1';
				WB_Sel <= "11";
				skiptime_clk(10);
				
				--for 0x0206
				WB_DataIn <= "0010101101011000";
				WB_Cyc <= '1';
				WB_Addr <= (9,2,1 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				
				skiptime_clk(5);
				
				WB_Cyc <= '1';
				WB_Addr <= (9,2,1 => '1', others => '0');
				WB_WE <= '0';
				WB_STB <= '1';
				WB_Sel <= "11";
				skiptime_clk(10);
				
				--for 0x0208
				WB_DataIn <= "0011101001001001";
				WB_Cyc <= '1';
				WB_Addr <= (9,3 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				
				skiptime_clk(5);
				
				WB_Cyc <= '1';
				WB_Addr <= (9,3 => '1', others => '0');
				WB_WE <= '0';
				WB_STB <= '1';
				WB_Sel <= "11";
				skiptime_clk(10);
				
				--for 0x020A
				WB_DataIn <= "1100101001110010";
				WB_Cyc <= '1';
				WB_Addr <= (9,3,1 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				
				skiptime_clk(5);
				
				WB_Cyc <= '1';
				WB_Addr <= (9,3,1 => '1', others => '0');
				WB_WE <= '0';
				WB_STB <= '1';
				WB_Sel <= "11";
				skiptime_clk(10);
				
				--for 0x020C
				WB_DataIn <= "0011000001010001";
				WB_Cyc <= '1';
				WB_Addr <= (9,3,2 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				
				skiptime_clk(5);
				
				WB_Cyc <= '1';
				WB_Addr <= (9,3,2 => '1', others => '0');
				WB_WE <= '0';
				WB_STB <= '1';
				WB_Sel <= "11";
				skiptime_clk(100);
		end process;	

end architecture;
