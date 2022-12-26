library ieee;
use ieee.std_logic_1164.all;
entity GSMRegistr_tester is
    port (
        WB_Addr : out std_logic_vector( 15 downto 0 );
        -- WB_Ack_OUT : out std_logic;
        clk : out std_logic;
        WB_DataIn: out std_logic_vector( 15 downto 0 );
        -- WB_Data_OUT : out std_logic_vector( 15 downto 0 );
        nRst : out std_logic;
        WB_Sel: out std_logic_vector( 1 downto 0 );
        WB_STB : out std_logic;
        WB_WE: out std_logic;
		  WB_Cyc		: out	std_logic;
		  WB_CTI		: out	std_logic_vector(2 downto 0);
        -- PRT_O : out std_logic_vector( 15 downto 0 );
        -- Amplitude_OUT : out std_logic_vector( 15 downto 0);
        -- StartPhase_OUT : out std_logic_vector( 15 downto 0);
        -- CarrierFrequency_OUT : out std_logic_vector(31 downto 0);
        -- SymbolFrequency_OUT : out std_logic_vector( 31 downto 0);
        rdreq : out STD_LOGIC
        -- empty : out STD_LOGIC;
        -- full : out STD_LOGIC;
        -- q : out STD_LOGIC_VECTOR (15 DOWNTO 0);
        -- usedw : out STD_LOGIC_VECTOR (9 DOWNTO 0)  
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
				
				skiptime_clk(5);
				
				-- Сброс
				nRst <= '0';
				skiptime_clk(2);
				nRst <= '1';
				
				skiptime_clk(3);
				
				--
				WB_WE <= '1';
				WB_STB <= '1';
				WB_CTI <= "000";
				WB_Cyc <= '1';
				WB_DataIn <= "0000000010011100";
				WB_Addr <= (others => '0');
				WB_Sel <= "11";
				skiptime_clk(2);
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
				--
				WB_WE <= '1';
				WB_STB <= '1';
				WB_CTI <= "000";
				WB_Cyc <= '1';
				WB_DataIn <= (0 => '1', others => '0');
				WB_Addr <= (9 => '1', others => '0');
				WB_Sel <= "01";
				skiptime_clk(1);
				WB_DataIn <= (others => '0');
				WB_Cyc <= '0';
				WB_Addr <= (others => '0');
				WB_WE <= '0';
				WB_STB <= '0';
				WB_Sel <= "00";
		end process;	

end architecture;