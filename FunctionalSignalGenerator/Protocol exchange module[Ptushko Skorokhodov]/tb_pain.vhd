library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity tb_pain is
end;

architecture tb_pain_arch of tb_pain is
	signal Clk: std_logic := '1';
	signal nRst: std_logic := '1';
	 --??????? Fifo
	signal q_input :  std_logic_vector (15 downto 0);
   signal usedw_input :  std_logic_vector (10 downto 0);
   signal rdreq_output :  std_logic;
    --??????? Fifo
   signal data_output :  std_logic_vector (15 downto 0);
   signal wrreq_output : std_logic;
	begin
		i_Module : entity work.pain(rtl)
		port map(
					Clk => Clk,
					nRst => nRst,
					q_input => q_input,
					usedw_input => usedw_input,
					rdreq_output => rdreq_output,
					data_output => data_output,
					wrreq_output => wrreq_output
				);
		i_tb_Module : entity work.tester(rlt)
		port map(
					Clk => Clk,
					nRst => nRst,
					q_input => q_input,
					usedw_input => usedw_input,
					rdreq_output => rdreq_output,
					data_output => data_output,
					wrreq_output => wrreq_output
				);
end architecture;
