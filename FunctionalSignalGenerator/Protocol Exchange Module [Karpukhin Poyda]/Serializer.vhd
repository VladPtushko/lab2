library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

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
	signal fsdi_r: std_logic := '1';
	
	signal rdreq_input_r: std_logic := '0';
	signal q_input_r: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
	signal usedw_count: std_logic_vector(10 downto 0) := "00000000000";
	
	signal input_number_count: integer range -1 to 17 := -1;
	-- -1 = NOT READING
	-- 0 = READING FROM FIFO TO q_input + sending FIRST BIT
	-- 1-16 = BITS[15:0]
	-- 17 = LAST BIT
	
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
	FT2232H_FSDI <= fsdi_r;
	usedw_input_count <= usedw_count;
	
	input_fifo: fifo port map (
			clock => clk,
			data => data_input,
			
			wrreq => wrreq_input,
			rdreq => rdreq_input_r,
			q => q_input_r,
			usedw => usedw_count
	);
	
	process(clk)
	begin
	
		if rising_edge(clk, FT2232H_FSCTS) then
		
			-- OPENING FOR READING
			if CONV_INTEGER(unsigned(usedw_count)) > 0 and input_number_count = -1 then
				rdreq_input_r <= '1';
			else
				rdreq_input_r <= '0';
			end if;
			
			-- FSDI
			if input_number_count /= -1 then
			
				if input_number_count = 0 then
					fsdi_r <= '0';
				elsif input_number_count <= 16 then
					fsdi_r <= q_input_r(input_number_count - 1);
					
				elsif input_number_count = 17 then
					fsdi_r <= '1';
				end if;
			
			else
				fsdi_r <= '1';

			end if;
			
			-- INCREMENT COUNTER
			if input_number_count = 17 then
				input_number_count <= -1;
			elsif input_number_count /= -1 and (FT2232H_FSCTS = '0' or falling_edge(FT2232H_FSCTS)) then
				input_number_count <= input_number_count + 1;
			end if;
			
			
			-- DETECTING COUNT INCREASING WHEN NOT READING
			if  CONV_INTEGER(unsigned(usedw_count)) > 0 and input_number_count = -1 then
				input_number_count <= 0;
			end if;
			
		end if;
	
	end process;

end Serializer_arch;