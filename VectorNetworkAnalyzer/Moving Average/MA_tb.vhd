library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity moving_average_tb is
end entity moving_average_tb;

architecture sim of moving_average_tb is
	signal i_clk		: std_logic;
	signal i_nRst		: std_logic;
	signal i_data		: std_logic_vector(10-1 downto 0);
	signal MANumber	: std_logic_vector(32-1 downto 0);
	signal FilterCoeff: std_logic_vector(16-1 downto 0);
	signal o_data		: std_logic_vector(10-1 downto 0);
	
	component MA is
		port (
			i_clk			: in	std_logic;
			i_nRst		: in	std_logic;
			i_data		: in	std_logic_vector(10-1 downto 0);
			MANumber		: in	std_logic_vector(32-1 downto 0);
			FilterCoeff	: in	std_logic_vector(16-1 downto 0);
			o_data		: out	std_logic_vector(10-1 downto 0)
		);
	end component;
	
	component moving_average_tester is
		port (
			i_clk			: out	std_logic;
			i_nRst		: out	std_logic;
			i_data		: out	std_logic_vector(10-1 downto 0);
			MANumber		: out std_logic_vector(32-1 downto 0);
			FilterCoeff	: out	std_logic_vector(16-1 downto 0)
		);
	end component;
	
begin
	moving_average_i : entity work.MA
	port map (
		i_clk			=> i_clk,
		i_nRst		=> i_nRst,		
		i_data		=> i_data,
		MANumber		=> MANumber,
		FilterCoeff	=> FilterCoeff,
		o_data		=> o_data
	);
	
	moving_average_tester_i : entity work.moving_average_tester 
	port map (
		i_clk			=> i_clk,
		i_nRst		=> i_nRst,		
		i_data		=> i_data,
		MANumber		=> MANumber,
		FilterCoeff	=> FilterCoeff
	);
	
end architecture;
	
	