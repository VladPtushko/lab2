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

	signal reg_ADC_FTW: std_logic_vector(31 downto 0);
	signal reg_clear	: std_logic;
	signal reg_enable	: std_logic;

begin

	clear		<= reg_clear;
	enable	<= reg_enable;
	ADC_FTW	<= reg_ADC_FTW;
	
	WB_Ack <= WB_STB;
	
	process(clk, nRst, WB_STB, WB_WE, WB_Cyc)
	begin
		if (nRst = '0') then
			reg_clear <= '0';
			reg_enable <= '0';
			reg_ADC_FTW <= (others => '0');
		elsif(rising_edge(clk) and (WB_STB and WB_WE and WB_Cyc) = '1') then
			-- classic cycle
			for k in 0 to 1 loop -- for each 8-byte-word in WB_DataIn
				if(WB_Sel(k) = '1') then
					case (WB_Addr + k) is
						when ADC_FSC_OFF => 
							-- It is freq syn control
							reg_clear <= WB_DataIn(8*k);
							reg_enable<= WB_DataIn(8*k+1);
						when ADC_FTW_OFF =>
							-- It is 1st part off FTW
							reg_ADC_FTW(7 downto 0) <= WB_DataIn(8*(k+1)-1 downto 8*k);
						when ADC_FTW_OFF + 1 =>
							-- It is 2nd part off FTW
							reg_ADC_FTW(15 downto 8) <= WB_DataIn(8*(k+1)-1 downto 8*k);
						when ADC_FTW_OFF + 2 =>
							-- It is 3rd part off FTW
							reg_ADC_FTW(23 downto 16) <= WB_DataIn(8*(k+1)-1 downto 8*k);
						when ADC_FTW_OFF + 3 =>
							-- It is 4th part off FTW
							reg_ADC_FTW(31 downto 24) <= WB_DataIn(8*(k+1)-1 downto 8*k);
						when others =>
							null; -- nothing to do on other addresses
					end case;
				end if;
			end loop;
		end if;
	end process;

end Behavioral;










