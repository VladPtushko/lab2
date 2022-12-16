library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tester is
Port 
	(
		Clk, nRst: out std_logic;
		FT2232H_FSCTS, FT2232H_FSDO: out std_logic;
		FT2232H_FSDI: in std_logic;
		
		FT2232H_FSCLK: in std_logic;
		data_input: out STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdreq_output: out STD_LOGIC;
		wrreq_input: out STD_LOGIC;
		q_output: in STD_LOGIC_VECTOR (15 DOWNTO 0);
		usedw_input_count, usedw_output_count: in STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
end entity;

architecture test_arch of tester is
	signal empty_16_bits: std_logic_vector(15 downto 0) := "0000000000000000";
	signal package_1: std_logic_vector(15 downto 0) := "1111000011110000";
	signal package_2: std_logic_vector(15 downto 0) := "0000111100001111";
	signal package_3: std_logic_vector(15 downto 0) := "0011001100110011";
	signal package_4: std_logic_vector(15 downto 0) := "1100110011001100";
	signal package_5: std_logic_vector(15 downto 0) := "0001111000011110";
	
	signal sig_clk: std_logic := '1';
	signal fsdo: std_logic := '1';
	signal rst: std_logic := '0';
	signal fscts: std_logic := '1';
	
	signal sig_data_input: STD_LOGIC_VECTOR (15 DOWNTO 0) := "0000000000000000";
	signal sig_wrreq_input: STD_LOGIC := '0';
	

	constant clockFrequencyHz : integer := 500;
	constant clockPeriod: time := 1000 ms / clockFrequencyHz;
	
	 
begin

	
	clk <= sig_clk;
	sig_clk <= not sig_clk after clockPeriod / 2;
	
	FT2232H_FSDO <= fsdo;
	FT2232H_FSCTS <= fscts;
	nRst <= not rst;	
	
	data_input <= sig_data_input;
	wrreq_input <= sig_wrreq_input;
	
	process is
		procedure send_to_serial(signal pack: in  std_logic_vector(15 downto 0);
											signal serial: out std_logic) is
		begin
			serial <= '0';
			wait for clockPeriod;
			
			for i in 0 to 15 loop
				serial <= pack(i);
				wait for clockPeriod;
			end loop;
			
			serial <= '0';
			wait for clockPeriod;
			serial <= '1';
			wait for clockPeriod;
		end procedure;
		
		procedure send_to_deserialized(signal pack: in  std_logic_vector(15 downto 0)) is
		begin
			sig_wrreq_input <= '1';
			sig_data_input <= pack;
			
			wait for clockPeriod;
			sig_wrreq_input <= '0';
		end procedure;
	begin
		rdreq_output <= '0';
		
		send_to_serial(package_1, fsdo);
		send_to_serial(package_3, fsdo);
		rdreq_output <= '1';
		
		wait for 2 * clockPeriod;
		rdreq_output <= '0';
		
		wait for 50 ms;
		
		fscts <= '1';
		
		send_to_deserialized(package_2);
		fscts <= '0';
		
		send_to_deserialized(package_5);
		
		wait for 1000 ms;
	end process;

end;