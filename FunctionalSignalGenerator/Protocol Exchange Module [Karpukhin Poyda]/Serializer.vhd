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
	
	signal state_r: integer range -1 to 19 := -1;
	-- -1 = NOT READING
	-- 0 = READING FROM FIFO TO q_input + sending FIRST BIT
	-- 1-8 = BITS[7:0]
	-- 9 = LAST BIT FIRST BYTE
	-- 10 = FIRST BIT SECOND BYTE
	-- 11-18 = BITS[15:7]
	-- 19 = LAST BIT SECOND BYTE
	
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
	
	process(clk, FT2232H_FSCTS)
	begin
	
		if rising_edge(clk) then
			-- OPENING FOR READING
			if CONV_INTEGER(unsigned(usedw_count)) > 0 and state_r = -1 then
				rdreq_input_r <= '1';
			else
				rdreq_input_r <= '0';
			end if;
			
			-- INCREMENT STATE
			if state_r = 19 then
				state_r <= -1;
			elsif state_r = 0 then
				state_r <= 1;
			elsif state_r /= -1 and FT2232H_FSCTS = '0' then
				state_r <= state_r + 1;
			end if;
			
			-- DETECTING COUNT INCREASING WHEN NOT READING
			if  CONV_INTEGER(unsigned(usedw_count)) > 0 and state_r = -1 then
				state_r <= 0;
			end if;
			
			-- FSDI
			if state_r /= -1 then
			
				if state_r = 0 then
					fsdi_r <= '0';
				elsif state_r >= 1 and state_r <= 8 then
					fsdi_r <= q_input_r(state_r - 1);
				elsif state_r = 9 then
					fsdi_r <= '1';

				elsif state_r = 10 then
					fsdi_r <= '0';
				elsif state_r >= 11 and state_r <= 18 then
					fsdi_r <= q_input_r(state_r - 3);
				elsif state_r = 19 then
					fsdi_r <= '1';
				end if;
			
			else
				fsdi_r <= '1';

			end if;
			
			
			
		end if;
	
	end process;

end Serializer_arch;