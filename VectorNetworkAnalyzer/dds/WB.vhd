library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity WB is
	port
	(
		-- Управляющие
		clk	: in std_logic;
		nRst	: in std_logic;
		
		-- Wishbone сигналы
		WB_Addr		: in	std_logic_vector(15 downto 0);
--		WB_DataOut	: out	std_logic_vector(15 downto 0);
		WB_DataIn	: in	std_logic_vector(15 downto 0);
		WB_WE			: in	std_logic;
		WB_Sel		: in	std_logic_vector(1 downto 0);
		WB_STB		: in	std_logic;
		WB_Cyc		: in	std_logic;
		WB_Ack		: out	std_logic;
		WB_CTI		: in	std_logic_vector(2 downto 0);
		
		-- Получаемые сигналы
		clear		: out std_logic;
		enable	: out std_logic;
		ADC_FTW	: out std_logic_vector(31 downto 0)
	);
end WB;

architecture Behavioral of WB is

	constant ADC_FSC_OFF	: std_logic_vector := x"0000";
	constant ADC_FTW_OFF	: std_logic_vector := x"0001";

	signal ADC_FTW_r	: std_logic_vector(31 downto 0);
	signal clear_r		: std_logic;
	signal enable_r	: std_logic;
	
	-- Clear is '1' for 6 clock ticks
	signal clear_c		: std_logic_vector(2 downto 0);

begin

	clear		<= clear_r;
	enable	<= enable_r;
	ADC_FTW	<= ADC_FTW_r;
	
	WB_Ack <= WB_STB;
	
	process(clk, nRst, WB_STB, WB_WE, WB_Cyc)
	begin
		if (nRst = '0') then
			clear_r <= '0';
			clear_c <= (others => '0');
			enable_r <= '0';
			ADC_FTW_r <= (others => '0');
		elsif(rising_edge(clk)) then
			if(clear_r = '1') then
				if(clear_c = b"000") then
					clear_r <= '0';
				else
					clear_c <= clear_c - 1;
				end if;
			end if;
			
			if((WB_STB and WB_WE and WB_Cyc) = '1') then
				-- classic cycle
				for k in 0 to 1 loop -- for each 8-bit-word in WB_DataIn
					if(WB_Sel(k) = '1') then
						if(WB_Addr + k = ADC_FSC_OFF) then
							-- It is freq syn control
							-- Check if clear is now 1
							if(WB_DataIn(8*k) = '1') then
								clear_r <= '1';
								clear_c <= b"101";
							elsif(WB_DataIn(8*k) = '0') then
								clear_r <= '0';
							end if;
							enable_r<= WB_DataIn(8*k+1);
						elsif(WB_Addr + k = ADC_FTW_OFF) then
							-- It is 1st part off FTW
							ADC_FTW_r(7 downto 0) <= WB_DataIn(8*(k+1)-1 downto 8*k);
						elsif(WB_Addr + k = ADC_FTW_OFF + 1) then
							-- It is 2nd part off FTW
							ADC_FTW_r(15 downto 8) <= WB_DataIn(8*(k+1)-1 downto 8*k);
						elsif(WB_Addr + k = ADC_FTW_OFF + 2) then
							-- It is 3rd part off FTW
							ADC_FTW_r(23 downto 16) <= WB_DataIn(8*(k+1)-1 downto 8*k);
						elsif(WB_Addr + k = ADC_FTW_OFF + 3) then
							-- It is 4th part off FTW
							ADC_FTW_r(31 downto 24) <= WB_DataIn(8*(k+1)-1 downto 8*k);
						end if;
					end if;
				end loop;
			end if;
		end if;
	end process;

end Behavioral;










