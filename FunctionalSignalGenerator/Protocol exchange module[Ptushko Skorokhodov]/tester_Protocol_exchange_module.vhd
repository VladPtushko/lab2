library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity tester_Protocol_exchange_module is
Port
	(
Clk, nRst:  out std_logic;
 --??????? Fifo
 q_input : out std_logic_vector (15 downto 0);
 usedw_input_fi : out std_logic_vector (10 downto 0);
 rdreq_output : in std_logic;
 --??????? Fifo
    usedw_input_fo : out std_logic_vector (10 downto 0);
    data_output : in std_logic_vector (15 downto 0);
    wrreq_output : in std_logic;
--WISHBONE
    WB_Addr : in std_logic_vector (15 downto 0);
    WB_DataOut : in std_logic_vector (15 downto 0);
    WB_DataIn_0 : out std_logic_vector (15 downto 0);
    WB_DataIn_1 : out std_logic_vector (15 downto 0);
    WB_DataIn_2 : out std_logic_vector (15 downto 0);
    WB_DataIn_3 : out std_logic_vector (15 downto 0);
    WB_WE : in std_logic;--?????? ?????????? ??????
    WB_Sel : in std_logic_vector (1 downto 0);--Select
    WB_STB : in std_logic;--???????????? ??????
    WB_Cyc_0 : in std_logic;--???????? ?????? ???????? ??????????
    WB_Cyc_1 : in std_logic;
    WB_Cyc_2 : in std_logic;
    WB_Cyc_3 : in std_logic;
    WB_Ack : out std_logic;--????????????? ???????? ?????????? ????????? ???????? ??????
    WB_CTI : in std_logic_vector (2 downto 0)-- ?000? ? ??????? ????; ??????

	);
end entity;

architecture rlt of tester_Protocol_exchange_module is
	signal TbClock: std_logic := '1';
	signal rst: std_logic := '1';
	

	
	--FIFO
	signal sig_q_input: std_logic_vector (15 downto 0):="0000000000000000";
	signal read_fb0: std_logic_vector(15 downto 0) := "0000000101000001";
	signal read_fb1: std_logic_vector(15 downto 0) := "0000000110001001";
	signal package_1: std_logic_vector(15 downto 0) := "1111111111111111";
	signal addr_cor: std_logic_vector(15 downto 0) := "0000000000000000";
	signal addr_incor: std_logic_vector(15 downto 0) := "1111111111111111";
	signal sig_usedw_output_fi:std_logic_vector (10 downto 0):="00000000011";
	signal sig_usedw_output_fo:std_logic_vector (10 downto 0):="00000000011";
	
	--WISHBONE
	signal ack: std_logic := '1';
	signal package_data_1: std_logic_vector(15 downto 0) := "1111111111111111";
	signal package_data_2: std_logic_vector(15 downto 0) := "0000000011111111";
	signal package_data_3: std_logic_vector(15 downto 0) := "0000000000000000";

	constant TbPeriod : time := 100 ps;
	signal TbSimEnded : std_logic := '0';
	begin
		TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
		Clk <= TbClock;
		
		
		process is
				
			begin
			q_input <= addr_cor;
			usedw_input_fi <= sig_usedw_output_fi;
			usedw_input_fo <= sig_usedw_output_fo;
			nRst <= not rst;
			wait for 100 ps;
			nRst <=  rst;
			wait for 300 ps;
			q_input <= read_fb0;
			wait for 100 ps;
			q_input <= addr_incor;
			wait for 100 ps;
			q_input <= addr_cor;
			wait for 1000 ps;
			WB_Ack <= ack;
			WB_DataIn_0 <= package_data_1;
			wait for 100 ps;
			WB_Ack <= not ack;
			wait for 100 ps;
			WB_Ack <= ack;
			WB_DataIn_0 <= package_data_2;
			wait for 100 ps;
			WB_Ack <= not ack;
			wait for 100 ps;
			WB_Ack <= ack;
			WB_DataIn_0 <= package_data_3;
			wait for 100 ps;
			WB_Ack <= not ack;
			wait for 100 * TbPeriod;
			TbSimEnded <= '1';
 			wait;
		end process;
	end architecture;
	
