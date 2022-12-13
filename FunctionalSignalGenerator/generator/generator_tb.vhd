library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity generator_tb is
end entity;

architecture a_generator_tb of generator_tb is
    signal clk               : std_logic;
    signal nRst              : std_logic;
    signal DDS_en_s          : std_logic;
    signal DDS_mode_s        : std_logic_vector(1 downto 0);
    signal DDS_amplitude_s   : std_logic_vector(15 downto 0);
    signal DDS_frequency_s   : std_logic_vector(31 downto 0);
    signal DDS_start_phase_s : std_logic_vector(15 downto 0);
    signal DAC_I_s           : std_logic_vector(9 downto 0);
    signal DAC_Q_s           : std_logic_vector(9 downto 0);
    signal MainPhase_s       : std_logic_vector(9 downto 0);
    signal ShiftedPhase_s    : std_logic_vector(9 downto 0);
    signal SIN_I_s           : std_logic_vector(9 downto 0);
    signal SIN_Q_s           : std_logic_vector(9 downto 0);

    component generator_top
    port (
      clk               : in  std_logic;
      nRst              : in  std_logic;
      DDS_en_s          : in  std_logic;
      DDS_mode_s        : in  std_logic_vector(1 downto 0);
      DDS_amplitude_s   : in  std_logic_vector(15 downto 0);
      DDS_frequency_s   : in  std_logic_vector(31 downto 0);
      DDS_start_phase_s : in  std_logic_vector(15 downto 0);
      DAC_I_s           : out std_logic_vector(9 downto 0);
      DAC_Q_s           : out std_logic_vector(9 downto 0)
    );
    end component generator_top;

    component generator_tester
    port (
      clk               : out std_logic := '0';
      nRst              : out std_logic := '1';
      DDS_en_s          : out std_logic := '0';
      DDS_mode_s        : out std_logic_vector(1 downto 0) := (others => '0');
      DDS_amplitude_s   : out std_logic_vector(15 downto 0) := (others => '0');
      DDS_frequency_s   : out std_logic_vector(31 downto 0) := (others => '0');
      DDS_start_phase_s : out std_logic_vector(15 downto 0) := (others => '0')
    );
    end component generator_tester;

begin
    generator_top_i : generator_top
    port map (
      clk               => clk,
      nRst              => nRst,
      DDS_en_s          => DDS_en_s,
      DDS_mode_s        => DDS_mode_s,
      DDS_amplitude_s   => DDS_amplitude_s,
      DDS_frequency_s   => DDS_frequency_s,
      DDS_start_phase_s => DDS_start_phase_s,
      DAC_I_s           => DAC_I_s,
      DAC_Q_s           => DAC_Q_s
    );


    generator_tester_i : generator_tester
    port map (
      clk               => clk,
      nRst              => nRst,
      DDS_en_s          => DDS_en_s,
      DDS_mode_s        => DDS_mode_s,
      DDS_amplitude_s   => DDS_amplitude_s,
      DDS_frequency_s   => DDS_frequency_s,
      DDS_start_phase_s => DDS_start_phase_s
    );


end architecture;
