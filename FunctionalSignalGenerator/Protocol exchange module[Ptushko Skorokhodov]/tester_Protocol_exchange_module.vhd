library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use std.env.stop;

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
	
	signal rst: std_logic := '1';
	signal fb: std_logic := '1';
	signal rFb: std_logic := '0';
	

	
	--FIFO
		
	signal read_fb1: std_logic_vector(15 downto 0) := "0000000110000001";
	signal read_fb2: std_logic_vector(15 downto 0) := "0000000101000010";
	signal read_fb3: std_logic_vector(15 downto 0) := "0000000110001011";
	signal read_fb4: std_logic_vector(15 downto 0) := "0000000110001100";
	signal read_fb5: std_logic_vector(15 downto 0) := "0000000110000101";
	signal read_fb6: std_logic_vector(15 downto 0) := "0000000110000110";
	signal read_fb7: std_logic_vector(15 downto 0) := "0000000101000001";
	
	signal read_addr1: std_logic_vector (15 downto 0):="0000000000000000";
	signal read_addr2: std_logic_vector (15 downto 0):="0000000100000000";
	signal read_addr3: std_logic_vector (15 downto 0):="0000001000000000";
	signal read_addr4: std_logic_vector (15 downto 0):="0000001100000000";
	signal read_addr5: std_logic_vector (15 downto 0):="0000000000000000";
	signal read_addr6: std_logic_vector (15 downto 0):="0000000000000000";
	signal read_addr7: std_logic_vector (15 downto 0):="1111111111111111";
	
	signal addr_cor: std_logic_vector(15 downto 0) := "0000000000000000";
	signal addr_incor: std_logic_vector(15 downto 0) := "1111111111111111";
	
	signal sig_usedw_output_6:std_logic_vector (10 downto 0):="00000000110";
	signal sig_usedw_output_5:std_logic_vector (10 downto 0):="00000000101";
	signal sig_usedw_output_4:std_logic_vector (10 downto 0):="00000000100";
	signal sig_usedw_output_3:std_logic_vector (10 downto 0):="00000000011";
	signal sig_usedw_output_2:std_logic_vector (10 downto 0):="00000000010";
	signal sig_usedw_output_1:std_logic_vector (10 downto 0):="00000000001";
	signal sig_usedw_output_zero:std_logic_vector (10 downto 0):="00000000000";
	
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
				procedure q_in(signal command: in  std_logic_vector(15 downto 0);signal address: in  std_logic_vector(15 downto 0)) is
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
						q_input <= command;
						usedw_input_fi <= sig_usedw_output_2;
						skiptime(1);
						q_input <= addr_incor;
						usedw_input_fi <= sig_usedw_output_1;
						skiptime(1);
						q_input <= address;
						usedw_input_fi <= sig_usedw_output_zero;
				end procedure;
				procedure command_read(signal command: in  std_logic_vector(15 downto 0);signal address: in  std_logic_vector(15 downto 0);signal FB: in std_logic) is
					begin
						q_in(command,address);
						usedw_input_fi <= sig_usedw_output_zero;
						skiptime(6);
						usedw_input_fo <= sig_usedw_output_1;
						skiptime(1);
						usedw_input_fo <= sig_usedw_output_2;
						skiptime(1);
						usedw_input_fo <= sig_usedw_output_3;
						if(FB = '1') then
							skiptime(3);
							usedw_input_fo <= sig_usedw_output_4;
							skiptime(1);
							usedw_input_fo <= sig_usedw_output_5;
							skiptime(1);
							usedw_input_fo <= sig_usedw_output_6;
							skiptime(3);
						else
							skiptime(2);
						end if;
						WB_Ack <= ack;
						WB_DataIn_0 <= package_data_1;
						skiptime(1);
						WB_Ack <= not ack;
						skiptime(1);
						WB_Ack <= ack;
						WB_DataIn_0 <= package_data_2;
						usedw_input_fo <= sig_usedw_output_4;
						skiptime(1);
						WB_Ack <= not ack;
						skiptime(1);
						WB_Ack <= ack;
						WB_DataIn_0 <= package_data_1;
						usedw_input_fo <= sig_usedw_output_5;
						skiptime(1);
						WB_Ack <= not ack;
						skiptime(1);
						usedw_input_fo <= sig_usedw_output_zero;
						skiptime(5);
				end procedure;
				procedure command_write(signal command: in  std_logic_vector(15 downto 0);signal address: in  std_logic_vector(15 downto 0);signal FB: in std_logic) is
					begin
						q_in(command,address);
						usedw_input_fi <= sig_usedw_output_3;
						if(FB = '1') then
							skiptime(6);
							usedw_input_fo <= sig_usedw_output_1;
							skiptime(1);
							usedw_input_fo <= sig_usedw_output_2;
							skiptime(1);
							usedw_input_fo <= sig_usedw_output_3;
							skiptime(2);
						else
							skiptime(5);
						end if;
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
						usedw_input_fo <= sig_usedw_output_zero;
						skiptime(5);
				end procedure;
				procedure addres_error(signal command: in  std_logic_vector(15 downto 0);signal address: in  std_logic_vector(15 downto 0)) is
					begin
						q_in(command,address);
						skiptime(6);
						usedw_input_fo <= sig_usedw_output_1;
						skiptime(1);
						usedw_input_fo <= sig_usedw_output_2;
						skiptime(1);
						usedw_input_fo <= sig_usedw_output_3;
						skiptime(8);
						usedw_input_fo <= sig_usedw_output_zero;
						skiptime(5);
				end procedure;
				
				
			begin
			rFb <= not fb;
			command_read(read_fb1,read_addr1, rFb); --?????? ???????????????? ?????? 0 cyc
			command_write(read_fb2,read_addr2, rFb); --?????? ???????????????? ?????? 1 cyc
			
			rFb <= fb;
			command_read(read_fb3,read_addr3, rFb);--?????? ?????? ?? ????? ?????/?????? (FIFO)  c FB 0 cyc
			command_write(read_fb4,read_addr4, rFb);--?????? ?????? ? ???? ?????/?????? (FIFO) c FB 2 cyc
			
			rFb <= not fb;
			command_read(read_fb5,read_addr5, rFb);--?????? ?????? ?? ?????? 0 cyc
			command_write(read_fb6,read_addr6, rFb);--?????? ?????? ? ?????? 0 cyc
			
			addres_error(read_fb7,read_addr7); -- ??????????? ????? 
			stop;
		end process;
	end architecture;
	
