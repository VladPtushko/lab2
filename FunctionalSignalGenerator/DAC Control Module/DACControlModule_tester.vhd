library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use std.env.finish;

entity DACControlModule_tester is 
	port (
		Clk: out std_logic;
		nRst: out std_logic;
		DAC_I_sig: out std_logic_vector(9 downto 0); 
		DAC_Q_sig: out std_logic_vector(9 downto 0);
		Rst_For_DAC: out std_logic;
		Power_Down: out std_logic
	);
end entity DACControlModule_tester;

architecture a_DACControlModule_tester of DACControlModule_tester is
	signal Clk_r: std_logic := '0';
	
	procedure skiptime_Clk(time_count: in integer) is
    begin
        count_time: for k in 0 to time_count-1 loop
            wait until falling_edge(Clk_r); 
            wait for 200 fs; --need to wait for signal stability, value depends on the Clk frequency. 
                        --For example, for Clk period = 100 ns (10 MHz) it's ok to wait for 200 ps.
        end loop count_time ;
   end;
	
begin
	Clk <= Clk_r;
	Clk_r <= not Clk_r after 10 ns;
	
	tester_process: process
	begin
		DAC_I_sig <= "1111100000";
		DAC_Q_sig <= "0000011111";
      Rst_For_DAC <= '0';
		Power_Down <= '0';
		
      nRst <= '0';
      skiptime_Clk(6);
      nRst <= '1';
		
		skiptime_Clk(20);
		
		Rst_For_DAC <= '1';
		skiptime_Clk(12);
		
		Rst_For_DAC <= '0';
		Power_Down <= '1';
		skiptime_Clk(6);
		
		Rst_For_DAC <= '1';
		Power_Down <= '1';
		skiptime_Clk(6);
        
		nRst <= '0';
		skiptime_Clk(6);
		
		report "Calling 'finish'";
      finish;
	end process;

end architecture;	
		