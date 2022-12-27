library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

entity tb_ProtocolExchangeModule is
end entity;

architecture tb_ProtocolExchangeModule_arch of tb_ProtocolExchangeModule is
	signal clk: std_logic := '1';
	signal FT2232H_FSCTS: std_logic;
	signal FT2232H_FSDO: std_logic; 
	signal nRst: std_logic := '1';
	signal FT2232H_FSCLK: std_logic;
	signal FT2232H_FSDI: std_logic;
	
	signal data_input: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal rdreq_output: STD_LOGIC;
	signal wrreq_input: STD_LOGIC;
	signal q_output: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal usedw_input_count: STD_LOGIC_VECTOR (10 DOWNTO 0);
	signal usedw_output_count: STD_LOGIC_VECTOR (10 DOWNTO 0);
	
 
begin
	i_Module : entity work.ProtocolExchangeModule(ProtocolExchangeModule_arch)
	port map (
		FT2232H_FSCTS => FT2232H_FSCTS, 
		Clk => clk, 
		FT2232H_FSDO => FT2232H_FSDO, 
		nRst => nRst,
		FT2232H_FSCLK => FT2232H_FSCLK, 
		FT2232H_FSDI => FT2232H_FSDI,
		data_input => data_input,
		rdreq_output => rdreq_output,
		wrreq_input => wrreq_input,
		q_output => q_output,
		usedw_input_count => usedw_input_count, 
		usedw_output_count => usedw_output_count
	);
	
	i_tb_Module : entity work.tester(test_arch)
	port map (
		FT2232H_FSCTS => FT2232H_FSCTS,
		Clk => clk, 
		FT2232H_FSDO => FT2232H_FSDO, 
		nRst => nRst,
		FT2232H_FSCLK => FT2232H_FSCLK, 
		FT2232H_FSDI => FT2232H_FSDI,
		data_input => data_input,
		rdreq_output => rdreq_output,
		wrreq_input => wrreq_input,
		q_output => q_output,
		usedw_input_count => usedw_input_count, 
		usedw_output_count => usedw_output_count
	);
	

end;