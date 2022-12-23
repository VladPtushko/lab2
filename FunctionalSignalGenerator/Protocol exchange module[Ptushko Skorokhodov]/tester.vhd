library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity tester is
Port
	(
Clk, nRst:  out std_logic;
 --??????? Fifo
 q_input : out std_logic_vector (15 downto 0);
 usedw_input : out std_logic_vector (10 downto 0);
 rdreq_output : in std_logic;
 --??????? Fifo
    data_output : in std_logic_vector (15 downto 0);
    wrreq_output : in std_logic
	);
end entity;

architecture rlt of tester is
	signal TbClock: std_logic := '1';
	signal rst: std_logic := '1';
	
	signal sig_q_input: std_logic_vector (15 downto 0):="0000000000000000";
	signal read_fb0: std_logic_vector(15 downto 0) := "0000000101000001";
	signal read_fb1: std_logic_vector(15 downto 0) := "0000000110001001";
	signal package_1: std_logic_vector(15 downto 0) := "1111111111111111";
	signal addr_cor: std_logic_vector(15 downto 0) := "0000000000000000";
	signal addr_incor: std_logic_vector(15 downto 0) := "1111111111111111";
	signal sig_usedw_output:std_logic_vector (10 downto 0):="00000000011";
	constant TbPeriod : time := 100 ps;
	signal TbSimEnded : std_logic := '0';
	begin
		TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
		Clk <= TbClock;
		
		
		process is
				
			begin
			q_input <= sig_q_input;
			usedw_input <= sig_usedw_output;
			nRst <= not rst;
			wait for 100 ps;
			nRst <=  rst;
			wait for 200 ps;
			q_input <= package_1;
			wait for 100 ps;
			
			 wait for 100 * TbPeriod;
			TbSimEnded <= '1';
 			wait;
		end process;
	end architecture;
	
