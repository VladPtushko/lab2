library ieee;
use ieee.std_logic_1164.all;

entity GSMRegister is
port(
WB_Addr_IN: in std_logic_vector( 15 downto 0 );
WB_Ack_OUT: out std_logic;
Clk: in std_logic;
WB_Data_IN: in std_logic_vector( 15 downto 0 );
WB_Data_OUT: out std_logic_vector( 15 downto 0 );
nRst: in std_logic;
WB_Sel_IN: in std_logic_vector( 1 downto 0 );
WB_STB_IN: in std_logic;
WB_WE_IN: in std_logic;

PRT_O: out std_logic_vector( 15 downto 0 ); --данные для кодирования и модуляции
Amplitude_OUT: out std_logic_vector( 15 downto 0);
StartPhase_OUT: out std_logic_vector( 15 downto 0);
CarrierFrequency_OUT: out std_logic_vector(31 downto 0);
SymbolFrequency_OUT: out std_logic_vector( 31 downto 0);
DataPort_OUT: out std_logic_vector( 15 downto 0) --идет в FIFO
 );
end entity GSMRegister;
architecture Behavior of GSMRegister is
 signal QH_r: std_logic_vector( 7 downto 0 );
 signal QL_r: std_logic_vector( 7 downto 0 );
 signal Amplitude_r: std_logic_vector( 15 downto 0 );
 signal Start_Phase_r: std_logic_vector( 15 downto 0 );
 
 signal Carrier_Frequency_r: std_logic_vector( 31 downto 0 );
 signal Symbol_Frequency_r: std_logic_vector( 31 downto 0 );
 signal DataPort_r: std_logic_vector( 15 downto 0 ); -- пойдет в ФИФО

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
			if(WB_Addr_IN = x"0000") then
				if(WB_STB_IN and WB_WE_IN and WB_Sel_IN(1)) = '1')
					QH_r <= WB_Data_IN( 15 downto 8 );
				else
					QH_r <= QH_r;
				end if;
				if (WB_STB_IN and WB_WE_IN and WB_Sel_IN(0)) = '1')
					QL_r <= WB_Data_IN( 7 downto 0 );
				else
					QL_r <= QL_r;
				end if;
				if (WB_WE_IN = '0')
					WB_Data_OUT( 15 downto 8 ) <= QH_r;
					WB_Data_OUT( 7 downto 0 ) <= QL_r;
				end if;
			elsif(WB_Addr_IN = x"0200") then
				if(WB_STB_IN and WB_WE_IN) then
					Amplitude_r <= WB_Data_IN(15 downto 0);
				end if;
				if (WB_WE_IN = '0')
					WB_Data_OUT <= Amplitude_r;
				end if;
			elsif(WB_Addr_IN = x"0202") then
				if(WB_STB_IN and WB_WE_IN) then
					Start_Phase_r <= WB_Data_IN(15 downto 0);
				end if;
				if (WB_WE_IN = '0')
					WB_Data_OUT <= Start_Phase_r;
				end if;
			elsif(WB_Addr_IN = x"0204") then 
				if(WB_STB_IN and WB_WE_IN) then
					Carrier_Frequency_r (31 downto 16) <= WB_Data_IN(15 downto 0);
				end if;
				if (WB_WE_IN = '0')
					WB_Data_OUT <= Carrier_Frequency_r (31 downto 16);
				end if;
			elsif(WB_Addr_IN = x"0206") then 
				if(WB_STB_IN and WB_WE_IN) then
					Carrier_Frequency_r (15 downto 0) <= WB_Data_IN(15 downto 0);
				end if;
				if (WB_WE_IN = '0')
					WB_Data_OUT <= Carrier_Frequency_r (15 downto 0);
				end if;
			elsif(WB_Addr_IN = x"0208") then
				if(WB_STB_IN and WB_WE_IN) then
					Symbol_Frequency_r (31 downto 16) <= WB_Data_IN(15 downto 0);
				end if;
				if (WB_WE_IN = '0')
					WB_Data_OUT <= Symbol_Frequency_r (31 downto 16);
				end if;
			elsif(WB_Addr_IN = x"020A") then
				if(WB_STB_IN and WB_WE_IN) then
					Symbol_Frequency_r (15 downto 0) <= WB_Data_IN(15 downto 0);
				end if;
				if (WB_WE_IN = '0')
					WB_Data_OUT <= Symbol_Frequency_r (15 downto 0);
				end if;
			elsif(WB_Addr_IN = x"020C") then
				if(WB_STB_IN and WB_WE_IN) then
					DataPort_r <= WB_Data_IN(15 downto 0);
				end if;
				if (WB_WE_IN = '0')
					WB_Data_OUT <= DataPort_r;
				end if;
			end if;
		end if;
	end process;

 WB_Ack_OUT <= WB_STB_IN;
 PRT_O( 15 downto 8 ) <= QH_r;
 PRT_O( 7 downto 0 ) <= QL_r;
 Amplitude_OUT <= Amplitude_r;
 StartPhase_OUT <= Start_Phase_r;
 CarrierFrequency_OUT <= Carrier_Frequency_r;
 SymbolFrequency_OUT <= Symbol_Frequency_r;
 DataPort_OUT <= DataPort_r;
end architecture Behavior;
