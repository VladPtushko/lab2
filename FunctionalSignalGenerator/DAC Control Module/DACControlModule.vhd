library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DACControlModule is
	port (
			Clk: in std_logic;
			nRst: in std_logic;
			DAC_I_sig: in std_logic_vector(9 downto 0); --sinphase component of moduled harmonic signal
			DAC_Q_sig: in std_logic_vector(9 downto 0); --quadrature component of moduled harmonic signal
			
			Rst_For_DAC: in std_logic; --reset only for DAC
			Power_Down: in std_logic; --Turn off DAC.If DAC_Rst=1 during 4 clocks of DAC_Clk, DAC circuit turns off
			
			
			DAC_Clk: out std_logic;
			DAC_Rst: out std_logic;	
			DAC_Write: out std_logic;
			DAC_Select: out std_logic;
			DAC_Data: out std_logic_vector(9 downto 0)
		  );
end DACControlModule;


architecture Behavioral of DACControlModule is
	signal ClkReduceFreq_count: std_logic := '0';
	signal DAC_Select_buf_r: std_logic := '0';
	signal DAC_Rst_buf_r: std_logic := '0';
	signal DAC_Rst_count: std_logic_vector(3 downto 0) := (others=>'0');
	signal DAC_Clk_falling_r: std_logic := '0';
	signal Select_Enable_r: std_logic := '0';
	
	
begin
	
	process(Clk,nRst)
	begin
		if (nRst = '0') then
			DAC_Rst_Count <= "0000";
		elsif (rising_edge(Clk)) then
			if (DAC_Rst_buf_r='1') then
				DAC_Rst_count <= DAC_Rst_count + 1;
			elsif (DAC_Rst_buf_r='0' and DAC_Rst_count < "1000") then
				DAC_Rst_Count <= "0000";
			end if;
		end if;
	end process;
	
	
	process(Clk,nRst,Power_Down,DAC_Rst_count)  -- 80 MHz -> 40 MHz
	begin
		if (nRst='0' or Power_Down='1' or DAC_Rst_count >= "1000") then
			ClkReduceFreq_count <= '0';
		elsif (rising_edge(Clk)) then
			ClkReduceFreq_count <= not ClkReduceFreq_count;
		end if;
	end process;

	
	process(nRst,Rst_For_DAC)
	begin
		if (nRst='0' or Rst_For_DAC='1') then
			DAC_Rst_buf_r <= '1';
		else
			DAC_Rst_buf_r <= '0';
		end if;
	end process;
	
	
	
	process(Clk,nRst,Power_Down,DAC_Rst_count)
	begin
		if (nRst='0' or Power_Down='1' or DAC_Rst_count >= "1000") then
			DAC_Clk_falling_r <= '0';
			
		elsif (rising_edge(Clk)) then
			DAC_Clk_falling_r <= not DAC_Clk_falling_r;
			
		end if;
	
	end process;
	
	
	process(Clk,nRst,Power_Down,DAC_Rst_count,DAC_Rst_buf_r)
	begin
		if (nRst='0' or Power_Down='1' or DAC_Rst_count >= "1000" or DAC_Rst_buf_r='1') then
			Select_Enable_r <= '0';
			
		elsif(rising_edge(Clk)) then
			if (ClkReduceFreq_count='1') then
				Select_Enable_r <= '1';
			end if;
		end if;
	end process;
	
	
	process(Clk,nRst,Power_Down,DAC_Rst_count,DAC_Rst_buf_r)
	begin
		if (nRst='0' or Power_Down='1' or DAC_Rst_count >= "1000" or DAC_Rst_buf_r='1') then
			DAC_Data <= "0000000000";
			
		elsif (falling_edge(Clk)) then
			if (Select_Enable_r='1') then
				if (DAC_Select_buf_r='1') then
					DAC_Data <= DAC_I_sig;
				elsif (DAC_Select_buf_r='0') then
					DAC_Data <= DAC_Q_sig;
				end if;
			end if;
		end if;
	end process;
	
	
	process(Clk,nRst) 
	begin
	
		if (nRst='0') then
			DAC_Select_buf_r <= '0';
			
		elsif (rising_edge(Clk)) then
				if (DAC_Clk_falling_r = '1') then  --falling edge of DAC_Clk
					DAC_Select_buf_r <= not DAC_Select_buf_r;  --route to I DAC
				end if;
			
		end if;
	end process;
	
	
	
	DAC_signals_assignment : process(ClkReduceFreq_count,DAC_Rst_buf_r,DAC_Select_buf_r)
	begin
		DAC_Clk <= ClkReduceFreq_count;
		DAC_Rst <= DAC_Rst_buf_r;
		DAC_Write <= ClkReduceFreq_count;
		DAC_Select <= DAC_Select_buf_r;
	end process;
	
	
	
end Behavioral;