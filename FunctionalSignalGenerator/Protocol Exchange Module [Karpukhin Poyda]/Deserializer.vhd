library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Deserializer is
    Port 
    ( 
			Clk, rst: in std_logic;
			FT2232H_FSDO: in std_logic;
			
			rdreq_output: IN STD_LOGIC;
			q_output: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			usedw_output_count: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
    );
end entity;

architecture Deserializer_arch of Deserializer is
	signal wrreq_r: std_logic := '0';
	signal data_output_r: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
	signal state_r: integer range -1 to 8 := -1;
	-- -1 - WAITING FOR FIRST BIT
	-- 0-7 - STORAGING SERIAL INPUT
	-- 8 - READING LAST BIT

	signal is_second_byte_r: std_logic := '0';
	
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

	output_fifo: fifo port map ( 
			clock => clk,
			data => data_output_r,
			wrreq => wrreq_r,
			
			rdreq => rdreq_output,
			q => q_output,
			usedw => usedw_output_count
	);
	
	
	process(FT2232H_FSDO, clk)
	begin
		if rising_edge(clk) and rst = '0' then
			
			-- STORAGING SERIAL INPUT
			if state_r >= 0 and state_r <= 7 then
				if is_second_byte_r = '0' then
					data_output_r(state_r) <= FT2232H_FSDO;
				else
					data_output_r(state_r + 8) <= FT2232H_FSDO;
				end if;
			end if;
			
			-- OPENING REQUEST TO WRITE TO FIFO 
			if state_r = 8 and is_second_byte_r = '1' then -- + THERE IS LAST BIT SKIP
				wrreq_r <= '1';
			else
				wrreq_r <= '0';
			end if;
			
			if state_r = 8 and is_second_byte_r = '1' then -- + THERE IS LAST BIT SKIP
				is_second_byte_r <= '0';
			elsif state_r = 8 and is_second_byte_r = '0' then 
				is_second_byte_r <= '1';
			end if;
			
			
			-- UPDATE STATE	
			if state_r = -1 and  FT2232H_FSDO ='0' then -- FIRST BIT IS 0
				state_r <= 0;
				
			elsif state_r = 8 then
				state_r <= -1;
					
			elsif state_r >= 0 and state_r <= 7 then
				state_r <= state_r + 1;
			end if;
			
	  end if;
	end process;
	

end Deserializer_arch;