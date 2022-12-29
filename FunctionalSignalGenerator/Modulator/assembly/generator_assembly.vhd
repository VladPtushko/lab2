library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

entity generator_assembly2 is
    port (
        clk   : in std_logic;
        nRst : in std_logic;

        WB_Addr: in std_logic_vector( 15 downto 0 );
        WB_Ack: out std_logic;
        WB_DataIn: in std_logic_vector( 15 downto 0 );
        WB_DataOut: out std_logic_vector( 15 downto 0 );
        WB_Sel: in std_logic_vector( 1 downto 0 );
        WB_STB: in std_logic;
        WB_WE: in std_logic;
        WB_Cyc		: in	std_logic;
        WB_CTI		: in	std_logic_vector(2 downto 0);

        DAC_I_s: out std_logic_vector(9 downto 0);
        DAC_Q_s: out std_logic_vector(9 downto 0)
    );    
end;

architecture a_generator_assembly of generator_assembly2 is
    signal Amplitude : std_logic_vector(15 downto 0);
    signal StartPhase : std_logic_vector(15 downto 0);
    signal CarrierFrequency : std_logic_vector(31 downto 0);
    signal SymbolFrequency : std_logic_vector(31 downto 0);
    signal DataPort : std_logic_vector(15 downto 0);
    signal rdreq : std_logic;
    signal DDS_en_r : std_logic;
    
    signal PRT_O : std_logic_vector( 15 downto 0 );
    
    signal empty : STD_LOGIC;
    signal full : STD_LOGIC;
    
    signal usedw : STD_LOGIC_VECTOR (9 DOWNTO 0);
begin
    modulator_inst : entity work.modulator
    port map (
      clk => clk,
      nRst => nRst,
      ModulationMode => PRT_O(2 downto 1),
      Mode => PRT_O(0),
      Amplitude => Amplitude,
      StartPhase => StartPhase,
      SymbolFrequency => SymbolFrequency,
      DataPort => DataPort,
      rdreq => rdreq,
      DDS_en => DDS_en_r,
      empty => empty
    );

    generator_top_inst : entity work.generator_top
    port map (
        clk => clk,
        nRst => nRst,
        DDS_en_s => DDS_en_r,
        DDS_mode_s => PRT_O(4 downto 3),
        DDS_amplitude_s => Amplitude,
        DDS_frequency_s => CarrierFrequency,
        DDS_start_phase_s => StartPhase,
        DAC_I_s => DAC_I_s,
        DAC_Q_s => DAC_Q_s
    );

    GSMRegistr_top_inst : entity work.GSMRegistr_top
    port map (
    WB_Addr => WB_Addr,
    WB_Ack => WB_Ack,
    Clk => Clk,
    WB_DataIn => WB_DataIn,
    WB_DataOut => WB_DataOut,
    nRst => nRst,
    WB_Sel => WB_Sel,
    WB_STB => WB_STB,
    WB_WE => WB_WE,
    WB_Cyc => WB_Cyc,
    WB_CTI => WB_CTI,
    PRT_O => PRT_O,
    CarrierFrequency_OUT => CarrierFrequency,
    SymbolFrequency_OUT => SymbolFrequency,
    rdreq => rdreq,
    empty => empty,
    full => full,
    q => DataPort,
    usedw => usedw
    );
end;