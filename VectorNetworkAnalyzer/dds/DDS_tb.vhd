library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity DDS_tb is
end entity DDS_tb;

architecture sim of DDS_tb is
	signal clk		: std_logic;
	signal nRst		: std_logic;
	
	signal DataFlow_Clk : std_logic;
	signal ADC_Clk	: std_logic;

	signal WB_Addr			: std_logic_vector(15 downto 0);
	signal WB_DataIn		: std_logic_vector(15 downto 0);
	signal WB_DataOut		: std_logic_vector(15 downto 0);
	signal WB_WE			: std_logic;
	signal WB_Sel			: std_logic_vector(1 downto 0);
	signal WB_STB			: std_logic;
	signal WB_Cyc			: std_logic;
	signal WB_Ack			: std_logic;
	signal WB_CTI			: std_logic_vector(2 downto 0);
	
	component DDS is
		port (
		-- Входные сигналы
		clk	: in std_logic;
		nRst	: in std_logic;
		
		-- Сигналы WISHBONE
		WB_Addr		: in	std_logic_vector(15 downto 0);
		WB_DataOut	: out	std_logic_vector(15 downto 0);
		WB_DataIn	: in	std_logic_vector(15 downto 0);
		WB_WE			: in	std_logic;
		WB_Sel		: in	std_logic_vector(1 downto 0);
		WB_STB		: in	std_logic;
		WB_Cyc		: in	std_logic;
		WB_Ack		: out	std_logic;
		WB_CTI		: in	std_logic_vector(2 downto 0);
		
		-- Выходные сигналы
		DataFlow_Clk	: out std_logic;
		ADC_Clk			: out std_logic
	);
	end component;
	
	component DDS_tester is
		port (
		clk	: out std_logic;
		nRst	: out std_logic;
		WB_Addr		: out	std_logic_vector(15 downto 0);
		WB_DataIn	: out	std_logic_vector(15 downto 0);
		WB_WE			: out	std_logic;
		WB_Sel		: out	std_logic_vector(1 downto 0);
		WB_STB		: out	std_logic;
		WB_Cyc		: out	std_logic;
		WB_CTI		: out	std_logic_vector(2 downto 0)
		);
	end component;
	
begin
	DDS_i : entity work.DDS
	port map (
		clk => clk,
		nRst => nRst,
		WB_Addr => WB_Addr,
		WB_DataOut => WB_DataOut,
		WB_DataIn => WB_DataIn,
		WB_WE => WB_WE,
		WB_Sel => WB_Sel,
		WB_Cyc => WB_Cyc,
		WB_Ack => WB_Ack,
		WB_CTI => WB_CTI,
		WB_STB => WB_STB,
		DataFlow_Clk => DataFlow_Clk,
		ADC_Clk => ADC_Clk
	);
	
	DDS_tester_i : entity work.DDS_tester 
	port map (
	clk => clk,
	nRst => nRst,
	WB_Addr => WB_Addr,
	WB_DataIn => WB_DataIn,
	WB_WE => WB_WE,
	WB_Sel => WB_Sel,
	WB_Cyc => WB_Cyc,
	WB_STB => WB_STB,
	WB_CTI => WB_CTI,
	WB_Ack => WB_Ack
	);
	
end architecture;
	
	