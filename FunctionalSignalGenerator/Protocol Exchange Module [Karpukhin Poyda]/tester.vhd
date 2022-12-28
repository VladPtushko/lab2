library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

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
	signal empty_16_bits_r: std_logic_vector(15 downto 0) := "0000000000000000";
	signal package_1_r: std_logic_vector(15 downto 0) := "1111000011110000";
	signal package_2_r: std_logic_vector(15 downto 0) := "0000111100001111";
	signal package_3_r: std_logic_vector(15 downto 0) := "0011001100110011";
	signal package_4_r: std_logic_vector(15 downto 0) := "1100110011001100";
	signal package_5_r: std_logic_vector(15 downto 0) := "0001111000011110";
	
	signal sig_clk_r: std_logic := '1';
	signal fsdo_r: std_logic;
	signal rst_r: std_logic := '0';
	signal fscts_r: std_logic := '1';
	
	signal sig_data_input_r: STD_LOGIC_VECTOR (15 DOWNTO 0) := "0000000000000000";
	signal sig_wrreq_input_r: STD_LOGIC := '0';
	

	constant clockFrequencyHz_r : integer := 500;
	constant clockPeriod_r: time := 1000 ms / clockFrequencyHz_r;
	
	 
begin

	
	clk <= sig_clk_r;
	sig_clk_r <= not sig_clk_r after clockPeriod_r / 2;
	
	FT2232H_FSDO <= fsdo_r;
	FT2232H_FSCTS <= fscts_r;
	nRst <= not rst_r;	
	
	data_input <= sig_data_input_r;
	wrreq_input <= sig_wrreq_input_r;
	
	process is
		procedure send_to_serial(signal pack_r: in  std_logic_vector(15 downto 0);
											signal serial_r: out std_logic) is
		begin
			serial_r <= '0';
			wait for clockPeriod_r;
			
			for i in 0 to 15 loop
				serial_r <= pack_r(i);
				wait for clockPeriod_r;
			end loop;
			
			serial_r <= '1'; -- LAST BIT
			wait for clockPeriod_r;
		end procedure;
		
		procedure send_to_deserialized(signal pack_r: in  std_logic_vector(15 downto 0)) is
		begin
			sig_wrreq_input_r <= '1';
			sig_data_input_r <= pack_r;
			
			wait for clockPeriod_r;
			sig_wrreq_input_r <= '0';
		end procedure;
	begin
		wait for 2 * clockPeriod_r;
		
		rdreq_output <= '0';
		
		send_to_serial(package_1_r, fsdo_r);
		send_to_serial(package_3_r, fsdo_r);
		rdreq_output <= '1';
		
		wait for 2 * clockPeriod_r;
		rdreq_output <= '0';
		
		wait for 50 ms;
		
		fscts_r <= '1';
		
		send_to_deserialized(package_2_r);
		send_to_deserialized(package_5_r);
		
		wait for 4 * clockPeriod_r;
		
		fscts_r <= '0';
		
		
		
		wait for 1000 ms;
	end process;

end;