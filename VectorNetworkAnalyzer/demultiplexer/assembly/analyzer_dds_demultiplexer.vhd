library ieee;
use ieee.std_logic_1164.all;

entity analyzer_dds_demultiplexer is
  port(
    clk : in std_logic;
    nRst : in std_logic;
    WB_Addr : in std_logic_vector(15 downto 0);
    WB_DataIn : in std_logic_vector(15 downto 0);
    WB_WE : in std_logic;
    WB_Sel : in std_logic_vector(1 downto 0);
    WB_STB : in std_logic;
    WB_Cyc : in std_logic;
    WB_Ack : out std_logic;
    WB_CTI : in std_logic_vector(2 downto 0);

    ReceiveDataMode : std_logic;
    ADC_SigIn : std_logic_vector(9 downto 0);  

    IData_Out: out std_logic_vector(9 downto 0);
    QData_Out: out std_logic_vector(9 downto 0);

    DataValid: out std_logic;
	 
    Gain_s : out std_logic;
    OutputBusSelect_s : out std_logic;
    Standby_s : out std_logic;
    PowerDown_s : out std_logic;
    OffsetCorrect_s : out std_logic;
    OutputFormat_s : out std_logic
  );
end entity analyzer_dds_demultiplexer;

architecture a_analyzer_dds_demultiplexer of analyzer_dds_demultiplexer is
    signal Clk_ADC : std_logic;
    signal Clk_DataFlow : std_logic;

    signal ISigOut : std_logic_vector(9 downto 0);
    signal QSigOut : std_logic_vector(9 downto 0);
    signal DataStrobe : std_logic;

    
    signal FS_IncrDecr : std_logic_vector(1 downto 0);    
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