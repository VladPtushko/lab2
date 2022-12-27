library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity ma_tb is
end entity ma_tb;

architecture sim of ma_tb is
	signal i_clk_r			: std_logic;
	signal i_nRst_r		: std_logic;
	signal IData_In_r		: std_logic_vector(10-1 downto 0);
	signal QData_In_r		: std_logic_vector(10-1 downto 0);
	signal MANumber_r		: std_logic_vector(5-1 downto 0);
	signal IData_Out_r		: std_logic_vector(10-1 downto 0);
	signal QData_out_r		: std_logic_vector(10-1 downto 0);
	
	component MA is
		port (
			i_clk			: in	std_logic;
			i_nRst		: in	std_logic;
			IData_In		: in	std_logic_vector(10-1 downto 0);
			QData_In		: in	std_logic_vector(10-1 downto 0);
			MANumber		: in	std_logic_vector(5-1 downto 0);
			IData_Out		: out	std_logic_vector(10-1 downto 0);
			QData_out		: out	std_logic_vector(10-1 downto 0)
		);
	end component;
	
	component ma_tester is
		port (
			i_clk			: out	std_logic;
			i_nRst		: out	std_logic;
			IData_In		: out	std_logic_vector(10-1 downto 0);
			QData_In		: out	std_logic_vector(10-1 downto 0);
			MANumber		: out std_logic_vector(5-1 downto 0)
		);
	end component;
	
begin
	ma_i : entity work.MA
	port map (
		i_clk			=> i_clk_r,
		i_nRst		=> i_nRst_r,		
		IData_In		=> IData_In_r,		
		QData_In		=> QData_In_r,
		MANumber		=> MANumber_r,
		IData_Out		=> IData_Out_r,
		QData_out		=> QData_out_r
	);
	
	ma_tester_i : entity work.ma_tester 
	port map (
		i_clk			=> i_clk_r,
		i_nRst		=> i_nRst_r,		
		IData_In		=> IData_In_r,	
		QData_In		=> QData_In_r,
		MANumber		=> MANumber_r
	);
	
end architecture;
	
	
