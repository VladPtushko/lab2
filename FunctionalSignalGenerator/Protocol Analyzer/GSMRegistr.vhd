library ieee;
use ieee.std_logic_1164.all;

entity GSMRegister is
	port
	(
		clk	: in	std_logic;
		nRst	: in	std_logic;
		
		--Wishbone
		WB_Addr		: in	std_logic_vector( 15 downto 0 );
		WB_DataOut	: out	std_logic_vector( 15 downto 0 );
		WB_DataIn	: in	std_logic_vector( 15 downto 0 );
		WB_WE			: in 	std_logic;
		WB_Sel		: in 	std_logic_vector( 1 downto 0 );
		WB_STB		: in 	std_logic;
		WB_Cyc		: in	std_logic;
		WB_Ack		: out std_logic;
		WB_CTI		: in	std_logic_vector(2 downto 0);

		PRT_O						: out 	std_logic_vector( 15 downto 0 ); --данные для кодирования и модуляции
		Amplitude_OUT			: out 	std_logic_vector( 15 downto 0);
		StartPhase_OUT			: out 	std_logic_vector( 15 downto 0);
		CarrierFrequency_OUT	: out 	std_logic_vector(31 downto 0);
		SymbolFrequency_OUT	: out 	std_logic_vector( 31 downto 0);
		DataPort_OUT			: out 	std_logic_vector( 15 downto 0);--идет в FIFO
		wrreq						: out 	std_logic
	);
end entity GSMRegister;
architecture Behavior of GSMRegister is
	signal QH_r: std_logic_vector( 7 downto 0 );
	signal QL_r: std_logic_vector( 7 downto 0 );
	signal Amplitude_r: std_logic_vector( 15 downto 0 );
	signal Start_Phase_r: std_logic_vector( 15 downto 0 );
	signal WB_DataOut_r: std_logic_vector(15 downto 0);
	signal Carrier_Frequency_r: std_logic_vector( 31 downto 0 );
	signal Symbol_Frequency_r: std_logic_vector( 31 downto 0 );
	signal DataPort_r: std_logic_vector( 15 downto 0 ); -- пойдет в ФИФО
	signal Ack_r: std_logic;
	signal wrreq_r: std_logic;
	signal wrreq_dop_r: std_logic; 
begin
		
		process(clk,nRst)
		begin
			if (nRst = '0') then
				wrreq_dop_r <= '0';
			elsif (rising_edge(clk)) then
				if (wrreq_dop_r = '1') then
					wrreq_dop_r <= '0';
				else
					wrreq_dop_r <= wrreq_r;
				end if;
			end if;
		end process;
		
		process(clk,nRst, WB_STB, WB_WE, WB_Cyc)
		begin
			if (nRst = '0') then
				QH_r <= x"00";
				QL_r <= x"00";
				Amplitude_r <= x"0000";
				Start_Phase_r <= x"0000";
				Carrier_Frequency_r <= x"00000000";
				Symbol_Frequency_r <= x"00000000";
				DataPort_r <= x"0000";
				wrreq_r <= '0';
				Ack_r <= '0';
				WB_DataOut_r <= "0000000000000000";
			elsif (rising_edge(clk)) then
			
				if ((WB_STB and WB_Cyc) = '1') then
					if(Ack_r = '0') then
						Ack_r <= '1';
					else
						Ack_r <= '0';
					end if;
				else
					Ack_r <= '0';
				end if;
			if (WB_Cyc = '1') then 
				if(WB_WE = '1' and WB_STB = '1') then
					if(WB_Addr = x"0000") then
						if(WB_Sel(1) = '1')then
							QH_r <= WB_DataIn( 15 downto 8 );
						else
							QH_r <= QH_r;
						end if;
						if(WB_Sel(0) = '1') then
							QL_r <= WB_DataIn( 7 downto 0 );
						else
							QL_r <= QL_r;
						end if;
					elsif(WB_Addr = x"0200") then
						Amplitude_r <= WB_DataIn;
					elsif(WB_Addr = x"0202") then
						Start_Phase_r <= WB_DataIn;
					elsif(WB_Addr = x"0204") then
						Carrier_Frequency_r( 31 downto 16 ) <= WB_DataIn;
					elsif(WB_Addr = x"0206") then
						Carrier_Frequency_r( 15 downto 0 ) <= WB_DataIn;
					elsif(WB_Addr = x"0208") then
						Symbol_Frequency_r( 31 downto 16 ) <= WB_DataIn;
					elsif(WB_Addr = x"020A") then
						Symbol_Frequency_r( 15 downto 0 ) <= WB_DataIn;
					elsif(WB_Addr = x"020C") then
						DataPort_r <= WB_DataIn;
						wrreq_r <= '1';
					end if;
				elsif(WB_WE = '0' and WB_STB = '1') then
					if(WB_Addr = x"0000") then
						WB_DataOut_r( 15 downto 8 ) <= QH_r;
						WB_DataOut_r( 7 downto 0 ) <= QL_r;
					elsif(WB_Addr = x"0200") then
						WB_DataOut_r <= Amplitude_r;
					elsif(WB_Addr = x"0202") then
						WB_DataOut_r <= Start_Phase_r;
					elsif(WB_Addr = x"0204") then
						WB_DataOut_r <= Carrier_Frequency_r( 31 downto 16 );
					elsif(WB_Addr = x"0206") then
						WB_DataOut_r <= Carrier_Frequency_r( 15 downto 0 );
					elsif(WB_Addr = x"0208") then
						WB_DataOut_r <= Symbol_Frequency_r( 31 downto 16 );
					elsif(WB_Addr = x"020A") then
						WB_DataOut_r <= Symbol_Frequency_r( 15 downto 0 );
					elsif(WB_Addr = x"020C") then
						WB_DataOut_r <= DataPort_r;
					end if;
				end if;
			end if;
			end if;
		end process;
 	PRT_O( 15 downto 8 ) <= QH_r;
	PRT_O( 7 downto 0 ) <= QL_r;
	Amplitude_OUT <= Amplitude_r;
	StartPhase_OUT <= Start_Phase_r;
	CarrierFrequency_OUT <= Carrier_Frequency_r;
	SymbolFrequency_OUT <= Symbol_Frequency_r;
	DataPort_OUT <= DataPort_r;
	wrreq <= wrreq_dop_r;
	WB_Ack <= Ack_r;
	WB_DataOut <= WB_DataOut_r;
end architecture Behavior;
