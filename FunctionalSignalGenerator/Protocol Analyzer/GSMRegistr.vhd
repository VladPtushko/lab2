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
 
	signal Carrier_Frequency_r: std_logic_vector( 31 downto 0 );
	signal Symbol_Frequency_r: std_logic_vector( 31 downto 0 );
	signal DataPort_r: std_logic_vector( 15 downto 0 ); -- пойдет в ФИФО
	signal Ack_r: std_logic;
	signal wrreq_r: std_logic;

begin
		
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
				
			elsif (rising_edge(clk)) then
				if(wrreq_r = '1') then
					wrreq_r <= '0';
				end if;
				
				if ((WB_STB and WB_Cyc) = '1') then 
					if(Ack_r = '1') then
						Ack_r <= '0';
					else
						if(WB_Addr = x"0000") then
							if(WB_WE = '1' and WB_Sel(1) = '1') then
								QH_r <= WB_DataIn( 15 downto 8 );
							else
								QH_r <= QH_r;
							end if;
							if (WB_WE = '1' and WB_Sel(0) = '1') then
								QL_r <= WB_DataIn( 7 downto 0 );
							else
								QL_r <= QL_r;
							end if;
							if (WB_WE = '0') then
								WB_DataOut( 15 downto 8 ) <= QH_r;
								WB_DataOut( 7 downto 0 ) <= QL_r;
							end if;
						elsif(WB_Addr = x"0200") then
							if(WB_WE = '1') then
								Amplitude_r <= WB_DataIn(15 downto 0);
							elsif(WB_WE = '0') then
								WB_DataOut <= Amplitude_r;
							end if;
						elsif(WB_Addr = x"0202") then
							if(WB_WE = '1') then
								Start_Phase_r <= WB_DataIn(15 downto 0);
							elsif (WB_WE = '0') then
								WB_DataOut <= Start_Phase_r;
							end if;
						elsif(WB_Addr = x"0204") then 
							if(WB_WE = '1') then
								Carrier_Frequency_r (31 downto 16) <= WB_DataIn(15 downto 0);
							elsif (WB_WE = '0') then
								WB_DataOut <= Carrier_Frequency_r (31 downto 16);
							end if;
						elsif(WB_Addr = x"0206") then 
							if(WB_WE = '1') then
								Carrier_Frequency_r (15 downto 0) <= WB_DataIn(15 downto 0);
							elsif (WB_WE = '0') then
								WB_DataOut <= Carrier_Frequency_r (15 downto 0);
							end if;
						elsif(WB_Addr = x"0208") then
							if(WB_WE = '1') then
								Symbol_Frequency_r (31 downto 16) <= WB_DataIn(15 downto 0);
							elsif (WB_WE = '0') then
								WB_DataOut <= Symbol_Frequency_r (31 downto 16);
							end if;
						elsif(WB_Addr = x"020A") then
							if(WB_WE = '1') then
								Symbol_Frequency_r (15 downto 0) <= WB_DataIn(15 downto 0);
							elsif (WB_WE = '0') then
								WB_DataOut <= Symbol_Frequency_r (15 downto 0);
							end if;
						elsif(WB_Addr = x"020C") then
							if(WB_WE = '1') then
								DataPort_r <= WB_DataIn(15 downto 0);
								wrreq_r <= '1';
							elsif (WB_WE = '0') then
								WB_DataOut <= DataPort_r;
							end if;
						end if;
					end if;
						
				else
					Ack_r <= '0';
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
	wrreq <= wrreq_r;
	WB_Ack <= Ack_r;
end architecture Behavior;
