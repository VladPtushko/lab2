library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Serializer is
    Port 
    ( 
			Clk, rst: in std_logic;
			FT2232H_FSCTS: in std_logic;
			FT2232H_FSDI: out std_logic;
			
			data_input: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wrreq_input: IN STD_LOGIC;
			usedw_input_count: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
    );
end entity;

architecture Serializer_arch of Serializer is
	signal fsdi: std_logic := '1';
	
	signal empty_16_bits: std_logic_vector(15 downto 0) := "0000000000000000";
	
	signal rdreq_input: std_logic := '0';
	signal q_input: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
	signal q_input_ind: integer range 0 to 16 := 0;
	signal reading_input: std_logic := '0';
	signal usedw_count: std_logic_vector(10 downto 0) := "00000000000";
	
	signal prev_usedw_count: STD_LOGIC_VECTOR (10 DOWNTO 0) := "00000000000";

	
	component fifo is 
		port (
			clock: IN STD_LOGIC;
			data: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			rdreq: IN STD_LOGIC;
			wrreq: IN STD_LOGIC;
			q: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			usedw: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
		);
	end component;

begin
	FT2232H_FSDI <= fsdi;
	usedw_input_count <= usedw_count;
	
	input_fifo: fifo port map (
			clock => clk,
			data => data_input,
			
			wrreq => wrreq_input,
			rdreq => rdreq_input,
			q => q_input,
			usedw => usedw_count
	);
	
	process(clk)
	begin
	
		if rising_edge(clk) then
			if reading_input = '0' and rdreq_input = '0' and to_integer(unsigned(usedw_count)) > 0 then
				rdreq_input <= '1';
				reading_input <= '1';
				fsdi <= '1';
			
			elsif reading_input = '1' and rdreq_input = '1' and to_integer(unsigned(prev_usedw_count)) > 0 then
				rdreq_input <= '0';
				reading_input <= '1';
				q_input_ind <= 0;
				
				fsdi <= '0';
				
			elsif reading_input = '1' and FT2232H_FSCTS = '1' and q_input_ind = 0 then
				fsdi <= q_input(q_input_ind);
				q_input_ind <= q_input_ind + 1;
			
			elsif reading_input = '1' and FT2232H_FSCTS = '0' and q_input_ind <= 15 then
				fsdi <= q_input(q_input_ind);
				q_input_ind <= q_input_ind + 1;
			
			elsif reading_input = '1' and q_input_ind = 16 then
				fsdi <= '0';
				reading_input <= '0';
				q_input_ind <= 0;
					
			elsif reading_input = '0' then
				fsdi <= '1';
			end if;
--			
			prev_usedw_count <= usedw_count;
			
		end if;
	
	end process;

end Serializer_arch;