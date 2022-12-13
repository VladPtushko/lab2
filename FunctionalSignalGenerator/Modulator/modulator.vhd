library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

entity modulator is
    port (
        clk   : in std_logic;
        nRst : in std_logic;
        Amplitude : out std_logic_vector(15 downto 0);
        StartPhase : out std_logic_vector(15 downto 0);
        -- Frequency: out std_logic_vector(15 downto 0);
        SymbolFrequency: in std_logic_vector(31 downto 0);

        ModulationMode: in std_logic_vector(1 downto 0);
        Mode: in std_logic
    );
end entity modulator;

architecture a_modulator of modulator is
    signal DataPort : std_logic_vector(9 downto 0) := (others => '0');
    signal lut_address : std_logic_vector(5 downto 0);
    signal performConvert: std_logic;
    

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

  modulator_lut_inst : modulator_lut
  port map (
    address => lut_address,
    clock => clk,
    nRst => nRst,
    Amplitude => Amplitude,
    StartPhase => StartPhase
  );

    

end architecture;