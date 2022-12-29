library ieee;
use ieee.std_logic_1164.all;

entity tb is
end entity tb;

architecture a_analyzer_dds_demultiplexer_tb of tb is
    signal clk : std_logic;
    signal nRst : std_logic;
    signal WB_Addr : std_logic_vector(15 downto 0);
    signal WB_DataOut : std_logic_vector(15 downto 0);
    signal WB_DataIn : std_logic_vector(15 downto 0);
    signal WB_WE : std_logic;
    signal WB_Sel : std_logic_vector(1 downto 0);
    signal WB_STB : std_logic;
    signal WB_Cyc : std_logic;
    signal WB_Ack : std_logic;
    signal WB_CTI : std_logic_vector(2 downto 0);
    signal DataFlow_Clk : std_logic;
    signal ADC_Clk : std_logic;

    
    signal Clk_ADC : std_logic;
    signal Clk_DataFlow : std_logic;
    signal ReceiveDataMode : std_logic;
    signal ADC_SigIn : std_logic_vector(9 downto 0);
    signal ISigOut : std_logic_vector(9 downto 0);
    signal QSigOut : std_logic_vector(9 downto 0);
    signal DataStrobe : std_logic;
    signal Gain_s : std_logic;
    signal OutputBusSelect_s : std_logic;
    signal Standby_s : std_logic;
    signal PowerDown_s : std_logic;
    signal OffsetCorrect_s : std_logic;
    signal OutputFormat_s : std_logic;
  
    signal FS_IncrDecr : std_logic_vector(1 downto 0);
    signal IData_Out : std_logic_vector(9 downto 0);
    signal QData_Out : std_logic_vector(9 downto 0);
    signal DataValid : std_logic; 
begin

    demultiplexer_top_inst : entity work.demultiplexer_top
  port map (
    Clk_ADC => Clk_ADC,
    Clk_DataFlow => Clk_DataFlow,
    nRst => nRst,
    ReceiveDataMode => ReceiveDataMode,
    ADC_SigIn => ADC_SigIn,
    ISigOut => ISigOut,
    QSigOut => QSigOut,
    DataStrobe => DataStrobe,
    Gain_s => Gain_s,
    OutputBusSelect_s => OutputBusSelect_s,
    Standby_s => Standby_s,
    PowerDown_s => PowerDown_s,
    OffsetCorrect_s => OffsetCorrect_s,
    OutputFormat_s => OutputFormat_s
  );

  DDS_inst : entity work.DDS
  port map (
    clk => clk,
    nRst => nRst,
    WB_Addr => WB_Addr,
    WB_DataIn => WB_DataIn,
    WB_WE => WB_WE,
    WB_Sel => WB_Sel,
    WB_STB => WB_STB,
    WB_Cyc => WB_Cyc,
    WB_Ack => WB_Ack,
    WB_CTI => WB_CTI,
    DataFlow_Clk => Clk_DataFlow,
    ADC_Clk => Clk_ADC
  );

 DDS_tester_i : entity work.DDS_tester 
	port map (
	clk => clk,
	nRst => nRst,
	WB_Addr => WB_Addr,
	WB_DataIn => WB_DataIn,
	WB_WE => WB_WE,
	WB_Sel => WB_Sel,
	WB_Cyc => WB_Cyc,
	WB_STB => WB_STB,
	WB_CTI => WB_CTI,
	WB_Ack => WB_Ack
	);

 i_analyzer_dds_demultiplexer_tester : entity work.analyzer_dds_demultiplexer_tester
 port map (
   Clk_ADC => Clk_ADC,
   Clk_DataFlow => Clk_DataFlow,
   nRst => nRst,
   ReceiveDataMode => ReceiveDataMode,
   ADC_SigIn => ADC_SigIn
 );

  Geterodine_module_inst : entity work.Geterodine_module
  port map (
    Clk => Clk,
    nRst => nRst,
    ReceiveDataMode => ReceiveDataMode,
    DataStrobe => DataStrobe,
    ISig_In => ISigOut,
    QSig_In => QSigOut,
    FS_IncrDecr => FS_IncrDecr,
    IData_Out => IData_Out,
    QData_Out => QData_Out,
    DataValid => DataValid
  );





end architecture;