library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DACControlModule_tb is
end entity DACControlModule_tb;

architecture a_DACControlModule_tb of DACControlModule_tb is
	signal Clk: std_logic;
	signal nRst: std_logic;
	signal DAC_I_sig: std_logic_vector(9 downto 0); 
	signal DAC_Q_sig: std_logic_vector(9 downto 0); 
	signal Rst_For_DAC: std_logic; 
	signal Power_Down: std_logic; 
	signal DAC_Clk: std_logic;
	signal DAC_Rst: std_logic;	
	signal DAC_Write: std_logic;
	signal DAC_Select: std_logic;
	signal DAC_Data: std_logic_vector(9 downto 0);
	
	
	component DACControlModule
		port (
			Clk: in std_logic;
			nRst: in std_logic;
			DAC_I_sig: in std_logic_vector(9 downto 0); 
			DAC_Q_sig: in std_logic_vector(9 downto 0);
			Rst_For_DAC: in std_logic;
			Power_Down: in std_logic;
			DAC_Clk: out std_logic;
			DAC_Rst: out std_logic;	
			DAC_Write: out std_logic;
			DAC_Select: out std_logic;
			DAC_Data: out std_logic_vector(9 downto 0)
		);
	end component;
	
	
	component DACControlModule_tester
		port (
			Clk: out std_logic;
			nRst: out std_logic;
			DAC_I_sig: out std_logic_vector(9 downto 0); 
			DAC_Q_sig: out std_logic_vector(9 downto 0);
			Rst_For_DAC: out std_logic;
			Power_Down: out std_logic
		);
	end component;
	
	
	begin
		 DACControlModule_i : entity work.DACControlModule
		 port map (
			  Clk => Clk,
			  nRst => nRst,
			  DAC_I_sig => DAC_I_sig, 
			  DAC_Q_sig => DAC_Q_sig,
			  Rst_For_DAC => Rst_For_DAC,
			  Power_Down => Power_Down,
			  DAC_Clk => DAC_Clk,
			  DAC_Rst => DAC_Rst,	
			  DAC_Write => DAC_Write,
			  DAC_Select => DAC_Select,
			  DAC_Data => DAC_Data
		 );

		 DACControlModule_tester_i : entity work.DACControlModule_tester
		 port map (
			  Clk => Clk,
			  nRst => nRst,
			  DAC_I_sig => DAC_I_sig, 
			  DAC_Q_sig => DAC_Q_sig,
			  Rst_For_DAC => Rst_For_DAC,
			  Power_Down => Power_Down
		 );
end architecture;