library ieee;
use ieee.std_logic_1164.all;

entity demultiplexer_top is
    port (
        Clk_ADC   : in std_logic;
        Clk_DataFlow : in std_logic;
        nRst: in std_logic;
        ReceiveDataMode: in std_logic;

        ADC_SigIn: in std_logic_vector(9 downto 0);

        ISigOut: out std_logic_vector(9 downto 0);
        QSigOut: out std_logic_vector(9 downto 0);

        DataStrobe: out std_logic;
        
        -- these ports should be directly wired to pins in the corresponding comments
        Gain_s: out std_logic; -- F13
        OutputBusSelect_s: out std_logic; -- F15
        Standby_s: out std_logic; -- F16
        PowerDown_s: out std_logic; -- D16
        OffsetCorrect_s: out std_logic; -- P1
        OutputFormat_s: out std_logic -- L2
    );
end entity demultiplexer_top;

architecture rtl of demultiplexer_top is
    component demultiplexer
        port (
        Clk_ADC : in std_logic;
        Clk_DataFlow : in std_logic;
        nRst : in std_logic;
        ReceiveDataMode : in std_logic;
        ADC_SigIn : in std_logic_vector(9 downto 0);
        ISigOut : out std_logic_vector(9 downto 0);
        QSigOut : out std_logic_vector(9 downto 0);
        DataStrobe : out std_logic
      );
    end component;
    component adc_control
        port (
        Clk_ADC : in std_logic;
        Clk_DataFlow : in std_logic;
        nRst : in std_logic;
        ReceiveDataMode : in std_logic;
        Gain_s : out std_logic;
        OutputBusSelect_s : out std_logic;
        Standby_s : out std_logic;
        PowerDown_s : out std_logic;
        OffsetCorrect_s : out std_logic;
        OutputFormat_s : out std_logic
      );
    end component;
    
begin
    demultiplexer_inst : demultiplexer
        port map (
            Clk_ADC => Clk_ADC,
            Clk_DataFlow => Clk_DataFlow,
            nRst => nRst,
            ReceiveDataMode => ReceiveDataMode,
            ADC_SigIn => ADC_SigIn,
            ISigOut => ISigOut,
            QSigOut => QSigOut,
            DataStrobe => DataStrobe
        );

    adc_control_inst : adc_control
        port map (
            Clk_ADC => Clk_ADC,
            Clk_DataFlow => Clk_DataFlow,
            nRst => nRst,
            ReceiveDataMode => ReceiveDataMode,
            Gain_s => Gain_s,
            OutputBusSelect_s => OutputBusSelect_s,
            Standby_s => Standby_s,
            PowerDown_s => PowerDown_s,
            OffsetCorrect_s => OffsetCorrect_s,
            OutputFormat_s => OutputFormat_s
        );

end architecture;