library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity demultiplexer_tb is
end entity demultiplexer_tb;

architecture a_demultiplexer_tb of demultiplexer_tb is
    signal Clk_ADC : std_logic;
    signal Clk_DataFlow : std_logic;
    signal nRst : std_logic;
    signal ReceiveDataMode : std_logic;
    signal ADC_SigIn : std_logic_vector(9 downto 0);
    signal ISigOut : std_logic_vector(9 downto 0);
    signal QSigOut : std_logic_vector(9 downto 0);
    signal DataStrobe : std_logic;

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

    component demultiplexer_tester
        port (
        Clk_ADC : out std_logic;
        Clk_DataFlow : out std_logic;
        nRst : out std_logic;
        ReceiveDataMode : out std_logic;
        ADC_SigIn : out std_logic_vector(9 downto 0)
      );
    end component;
    
begin
    demultiplexer_i : entity work.demultiplexer
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

    demultiplexer_tester_i : entity work.demultiplexer_tester
    port map (
        Clk_ADC => Clk_ADC,
        Clk_DataFlow => Clk_DataFlow,
        nRst => nRst,
        ReceiveDataMode => ReceiveDataMode,
        ADC_SigIn => ADC_SigIn
    );
end architecture;