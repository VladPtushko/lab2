library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity tester2_Protocol_exchange_module is
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

architecture rlt of tester2_Protocol_exchange_module is
	
	signal rst: std_logic := '1';
	

	
	--FIFO
	signal sig_q_input: std_logic_vector (15 downto 0):="0000000100000000";
	signal read_fb0: std_logic_vector(15 downto 0) := "0000000110000110";
	signal addr_cor: std_logic_vector(15 downto 0) := "0000000000000000";
	signal addr_incor: std_logic_vector(15 downto 0) := "1111111111111111";
	signal sig_usedw_output_5:std_logic_vector (10 downto 0):="00000000101";
	signal sig_usedw_output_4:std_logic_vector (10 downto 0):="00000000100";
	signal sig_usedw_output_3:std_logic_vector (10 downto 0):="00000000011";
	signal sig_usedw_output_zero:std_logic_vector (10 downto 0):="00000000000";
	signal sig_usedw_output_2:std_logic_vector (10 downto 0):="00000000010";
	signal sig_usedw_output_1:std_logic_vector (10 downto 0):="00000000001";
	
	--WISHBONE
	signal ack: std_logic := '1';
	signal package_data_1: std_logic_vector(15 downto 0) := "1111111111111111";
	signal package_data_2: std_logic_vector(15 downto 0) := "0000000000000000";

	signal Clk_r: std_logic := '1';

	procedure skiptime(time_count: in integer) is
    		begin
        		count_time: for k in 0 to time_count-1 loop
            		wait until falling_edge(Clk_r); 
            		wait for 50 ps; --need to wait for signal stability, value depends on the Clk frequency. 
                        --For example, for Clk period = 100 ns (10 MHz) it's ok to wait for 200 ps.
        	end loop count_time ;
    	end;

	
	begin
		Clk_r <= not Clk_r after 50 ps;
		Clk <= Clk_r;
		
		
		process is
				
			begin
			q_input <= addr_cor;
			usedw_input_fi <= sig_usedw_output_zero;
			usedw_input_fo <= sig_usedw_output_zero;
			nRst <= not rst;
			WB_Ack <= not ack;
			skiptime(1);
			nRst <=  rst;
			usedw_input_fi <= sig_usedw_output_3;
			skiptime(3);
			q_input <= read_fb0;
			skiptime(1);
			q_input <= addr_incor;
			skiptime(1);
			q_input <= sig_q_input;
			skiptime(5);
			q_input <= addr_incor;
			skiptime(2);
			WB_Ack <= ack;
			skiptime(1);
			WB_Ack <= not ack;
			skiptime(1);
			q_input <= addr_cor;
			skiptime(2);
			WB_Ack <= ack;
			skiptime(1);
			WB_Ack <= not ack;
			skiptime(1);
			q_input <= addr_incor;
			skiptime(2);
			WB_Ack <= ack;
			skiptime(1);
			WB_Ack <= not ack;
			skiptime(2);
			skiptime(100);
 			wait;
		end process;
	end architecture;
	