library ieee;
use ieee.std_logic_1164.all;

entity GSMRegister is
port(
WB_ADDR_IN: in std_logic_vector( 15 downto 0 );
WB_ACK_OUT: out std_logic;
Clk: in std_logic;
WB_DATA_IN: in std_logic_vector( 15 downto 0 );
WB_DATA_OUT: out std_logic_vector( 15 downto 0 );
nRst: in std_logic;
WB_SEL_IN: in std_logic_vector( 1 downto 0 );
WB_STB_IN: in std_logic;
WB_WE_IN: in std_logic;

PRT_O: out std_logic_vector( 15 downto 0 )
 );
end entity GSMRegister;
architecture Behavior of GSMRegister is
 signal QH_r: std_logic_vector( 7 downto 0 );
 signal QL_r: std_logic_vector( 7 downto 0 );
 signal Amplitude_r: std_logic_vector( 15 downto 0 );
 signal Start_Phase_r: std_logic_vector( 15 downto 0 );
 signal Carrier_Frequency_r: std_logic_vector( 31 downto 0 );
 signal Symbol_Frequency_r: std_logic_vector( 31 downto 0 );
 signal DataPort_r: std_logic_vector( 15 downto 0 );

begin
 process(Clk,nRst)
	begin
		if (nRst = '0') then
			QH_r <= x"00";
			QL_r <= x"00";
			Amplitude_r <= x"0000";
			Start_Phase_r <= x"0000";
			Carrier_Frequency_r <= x"00000000";
			Symbol_Frequency_r <= x"00000000";
			DataPort_r <= x"0000";
		elsif (rising_edge(Clk)) then
			if(WB_ADDR_IN = x"0000") then
				if(WB_STB_IN and WB_WE_IN and WB_SEL_IN(1)) = '1')
					QH_r <= WB_DATA_IN( 15 downto 8 );
				else
					QH_r <= QH_r;
				end if;
				if (WB_STB_IN and WB_WE_IN and WB_SEL_IN(0)) = '1')
					QL_r <= WB_DATA_IN( 7 downto 0 );
				else
					QL_r <= QL_r;
				end if;
			elsif(WB_ADDR_IN = x"0200") then
				if(WB_STB_IN and WB_WE_IN) then
					Amplitude_r <= WB_DATA_IN(15 downto 0);
				end if;
			elsif(WB_ADDR_IN = x"0202") then
				if(WB_STB_IN and WB_WE_IN) then
					Start_Phase_r <= WB_DATA_IN(15 downto 0);
				end if;
			elsif(WB_ADDR_IN = x"0204") then --непонятно как заносить данные большего размера чем дата ин
				if(WB_STB_IN and WB_WE_IN) then
					Carrier_Frequency_r <= WB_DATA_IN(15 downto 0);
				end if;
			elsif(WB_ADDR_IN = x"0208") then--непонятно как заносить данные большего размера чем дата ин
				if(WB_STB_IN and WB_WE_IN) then
					Symbol_Frequency_r <= WB_DATA_IN(15 downto 0);
				end if;
			elsif(WB_ADDR_IN = x"020C") then--DATA_PORT для FIFO
				if(WB_STB_IN and WB_WE_IN) then
					DataPort_r <= WB_DATA_IN(15 downto 0);
				end if;
			end if;
		end if;
	end process;

 WB_ACK_OUT <= WB_STB_IN;
 WB_DATA_OUT( 15 downto 8 ) <= QH_r;
 WB_DATA_OUT( 7 downto 0 ) <= QL_r;
 PRT_O( 15 downto 8 ) <= QH_r;
 PRT_O( 7 downto 0 ) <= QL_r;
end architecture Behavior;
