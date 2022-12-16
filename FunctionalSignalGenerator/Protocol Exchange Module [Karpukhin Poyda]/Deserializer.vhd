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
	signal wrreq: std_logic := '0';
	
	signal empty_16_bits: std_logic_vector(15 downto 0) := "0000000000000000";
	
	signal data_output: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
	signal filled_output: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
	signal data_ind: integer range 0 to 17 := 0;
	
	signal reading: std_logic := '0';
	
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
			data => data_output,
			wrreq => wrreq,
			
			rdreq => rdreq_output,
			q => q_output,
			usedw => usedw_output_count
	);
	
	
	process(FT2232H_FSDO, clk)
	begin
		if rising_edge(clk) and rst = '0' then
			
			if reading = '0' and FT2232H_FSDO ='0' then
				reading <= '1';
				data_ind <= 0;
				
			elsif reading = '1' and data_ind <= 15 then
				data_output(data_ind) <= FT2232H_FSDO;
				data_ind <= data_ind + 1;
				
				if data_ind = 15 then
					wrreq <= '1';
				end if;
				
			elsif reading = '1' and data_ind = 16 then	
				wrreq <= '0';
				data_ind <= 0;
				reading <= '0';
				
			end if;
	  end if;
	end process;
	

end Deserializer_arch;