library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity tb_Protocol_exchange_module is
end;

architecture tb_Protocol_exchange_module_arch of tb_Protocol_exchange_module is
   signal Clk: std_logic := '1';
   signal nRst: std_logic := '1';
	 --??????? Fifo
   signal q_input :  std_logic_vector (15 downto 0);
   signal usedw_input_fi :  std_logic_vector (10 downto 0);
   signal rdreq_output :  std_logic;
    --??????? Fifo
   signal usedw_input_fo :  std_logic_vector (10 downto 0);
   signal data_output :  std_logic_vector (15 downto 0);
   signal wrreq_output : std_logic;
   --WISHBONE
   signal WB_Addr :  std_logic_vector (15 downto 0);
   signal WB_DataOut : std_logic_vector (15 downto 0);
   signal WB_DataIn_0 : std_logic_vector (15 downto 0);
   signal WB_DataIn_1 : std_logic_vector (15 downto 0);
   signal WB_DataIn_2 : std_logic_vector (15 downto 0);
   signal WB_DataIn_3 : std_logic_vector (15 downto 0);
   signal WB_WE :  std_logic;--?????? ?????????? ??????
   signal WB_Sel :  std_logic_vector (1 downto 0);--Select
   signal WB_STB :  std_logic;--???????????? ??????
   signal WB_Cyc_0 :  std_logic;--???????? ?????? ???????? ??????????
   signal WB_Cyc_1 :  std_logic;
   signal WB_Cyc_2 :  std_logic;
   signal WB_Cyc_3 :  std_logic;
   signal WB_Ack :  std_logic;--????????????? ???????? ?????????? ????????? ???????? ??????
   signal WB_CTI :  std_logic_vector (2 downto 0);-- ?000? ? ??????? ????; ??????

	begin
		i_Module : entity work.Protocol_exchange_module(rtl)
		port map(
					Clk => Clk,
					nRst => nRst,
					q_input => q_input,
					usedw_input_fi => usedw_input_fi,
					rdreq_output => rdreq_output,
					usedw_input_fo => usedw_input_fo,
					data_output => data_output,
					wrreq_output => wrreq_output,
					WB_Addr => WB_Addr,
					WB_DataOut => WB_DataOut,
					WB_DataIn_0 => WB_DataIn_0,
					WB_DataIn_1 => WB_DataIn_1,
					WB_DataIn_2 => WB_DataIn_2,
					WB_DataIn_3 => WB_DataIn_3,
					WB_WE => WB_WE,
					WB_Sel => WB_Sel,
					WB_STB => WB_STB,
					WB_Cyc_0 => WB_Cyc_0,
					WB_Cyc_1 => WB_Cyc_1,
					WB_Cyc_2 => WB_Cyc_1,
					WB_Cyc_3 => WB_Cyc_3,
					WB_Ack => WB_Ack,
					WB_CTI => WB_CTI


				);
		i_tb_Module : entity work.tester_Protocol_exchange_module(rlt)
		port map(
					Clk => Clk,
					nRst => nRst,
					q_input => q_input,
					usedw_input_fi => usedw_input_fi,
					rdreq_output => rdreq_output,
					usedw_input_fo => usedw_input_fo,
					data_output => data_output,
					wrreq_output => wrreq_output,
					WB_Addr => WB_Addr,
					WB_DataOut => WB_DataOut,
					WB_DataIn_0 => WB_DataIn_0,
					WB_DataIn_1 => WB_DataIn_1,
					WB_DataIn_2 => WB_DataIn_2,
					WB_DataIn_3 => WB_DataIn_3,
					WB_WE => WB_WE,
					WB_Sel => WB_Sel,
					WB_STB => WB_STB,
					WB_Cyc_0 => WB_Cyc_0,
					WB_Cyc_1 => WB_Cyc_1,
					WB_Cyc_2 => WB_Cyc_1,
					WB_Cyc_3 => WB_Cyc_3,
					WB_Ack => WB_Ack,
					WB_CTI => WB_CTI
					
				);
end architecture;
