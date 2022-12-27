library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

entity ProtocolExchangeModule is
    Port 
    ( 
			Clk: in std_logic;
			nRst: in std_logic;
			FT2232H_FSCTS, FT2232H_FSDO: in std_logic;
			FT2232H_FSDI: out std_logic;
			FT2232H_FSCLK: out std_logic;
			
			data_input: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			rdreq_output: IN STD_LOGIC;
			wrreq_input: IN STD_LOGIC;
			q_output: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			usedw_input_count, usedw_output_count: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
    );
end entity;

architecture ProtocolExchangeModule_arch of ProtocolExchangeModule is
	signal rst_r: std_logic := '0';
	
	component Serializer is 
		port (
			Clk, rst: in std_logic;
			FT2232H_FSCTS: in std_logic;
			FT2232H_FSDI: out std_logic;
			
			data_input: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wrreq_input: IN STD_LOGIC;
			usedw_input_count: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
		);
	end component;
	
	component Deserializer is 
		port (
			Clk, rst: in std_logic;
			FT2232H_FSDO: in std_logic;
			
			rdreq_output: IN STD_LOGIC;
			q_output: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			usedw_output_count: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
		);
	end component;

begin
	FT2232H_FSCLK <= clk;
	rst_r <= not nRst;
	
	--- output
	ser: Serializer port map ( 
			Clk => clk, 
			rst => rst_r,
			FT2232H_FSCTS => FT2232H_FSCTS,
			FT2232H_FSDI => FT2232H_FSDI,
			
			data_input => data_input,
			wrreq_input => wrreq_input,
			usedw_input_count => usedw_input_count
	);
	
	--- input
	des: Deserializer port map (
			Clk => clk, 
			rst => rst_r,
			FT2232H_FSDO => FT2232H_FSDO,
			
			rdreq_output => rdreq_output,
			q_output => q_output,
			usedw_output_count => usedw_output_count
	);

end ProtocolExchangeModule_arch;