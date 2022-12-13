library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

entity modulator_modulation_tb is
end;

architecture bench of modulator_modulation_tb is
    component modulator_lut
        port (
        address : in std_logic_vector(5 downto 0);
        clock : in STD_LOGIC;
        nRst : in std_logic;
        Amplitude : out std_logic_vector(15 downto 0);
        StartPhase : out std_logic_vector(15 downto 0)
      );
    end component;
    

  component modulator_modulation
      port (
      clk : in std_logic;
      nRst : in std_logic;
      SymbolFrequency : in std_logic_vector(31 downto 0);
      DataPort : in std_logic_vector(9 downto 0);
      lut_address : out std_logic_vector(5 downto 0);
      ModulationMode : in std_logic_vector(1 downto 0);
      Mode : in std_logic;
      performConvert: out std_logic
    );
  end component;

  component modulator_modulation_tester
    port (
    clk : out std_logic;
    nRst : out std_logic;
    SymbolFrequency : out std_logic_vector(31 downto 0);
    DataPort : out std_logic_vector(15 downto 0);
    ModulationMode : out std_logic_vector(1 downto 0);
    Mode : out std_logic
    );
    end component;

    component modulator_8b10
      port (
      clk : in std_logic;
      nRst : in std_logic;
      performConvert : in std_logic;
      DataPort : in std_logic_vector(15 downto 0);
      CodedData : out std_logic_vector(9 downto 0)
    );
  end component;
  



  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal clk : std_logic;
  signal nRst : std_logic;
  signal SymbolFrequency : std_logic_vector(31 downto 0);
  signal DataPort : std_logic_vector(9 downto 0);
  signal lut_address : std_logic_vector(5 downto 0);
  signal ModulationMode : std_logic_vector(1 downto 0);
  signal Mode : std_logic;
  signal Amplitude:  std_logic_vector(15 downto 0);
  signal     StartPhase:  std_logic_vector(15 downto 0);
  signal performConvert:  std_logic;


  signal DataIn: std_logic_vector(15 downto 0);
begin

  modulator_modulation_inst : modulator_modulation
    port map (
      clk => clk,
      nRst => nRst,
      SymbolFrequency => SymbolFrequency,
      DataPort => DataPort,
      lut_address => lut_address,
      ModulationMode => ModulationMode,
      Mode => Mode,
      performConvert => performConvert
    );

    modulator_modulation_tester_inst : modulator_modulation_tester
  port map (
    clk => clk,
    nRst => nRst,
    SymbolFrequency => SymbolFrequency,
    DataPort => DataIn,
    ModulationMode => ModulationMode,
    Mode => Mode
  );

  modulator_lut_inst : modulator_lut
  port map (
    address => lut_address,
    clock => clk,
    nRst => nRst,
    Amplitude => Amplitude,
    StartPhase => StartPhase
  );

  

  modulator_8b10_inst : modulator_8b10
  port map (
    clk => clk,
    nRst => nRst,
    performConvert => performConvert,
    DataPort => DataIn,
    CodedData => DataPort
  );


end;
