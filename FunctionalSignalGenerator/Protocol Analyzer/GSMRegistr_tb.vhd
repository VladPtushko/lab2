library ieee;
use ieee.std_logic_1164.all;

entity GSMRegistr_top_tb is
end;

architecture bench of GSMRegistr_top_tb is

  component GSMRegistr_top
      port (
      WB_Addr: in std_logic_vector( 15 downto 0 );
      WB_Ack : out std_logic;
      clk : in std_logic;
      WB_DataIn : in std_logic_vector( 15 downto 0 );
      WB_DataOut : out std_logic_vector( 15 downto 0 );
      nRst : in std_logic;
      WB_Sel: in std_logic_vector( 1 downto 0 );
      WB_STB : in std_logic;
      WB_WE : in std_logic;
      WB_Cyc: in std_logic;
      WB_CTI: in std_logic_vector(2 downto 0);
      PRT_O : out std_logic_vector( 15 downto 0 );
      Amplitude_OUT : out std_logic_vector( 15 downto 0);
      StartPhase_OUT : out std_logic_vector( 15 downto 0);
      CarrierFrequency_OUT : out std_logic_vector(31 downto 0);
      SymbolFrequency_OUT : out std_logic_vector( 31 downto 0);
      rdreq : in STD_LOGIC;
      empty : out STD_LOGIC;
      full : out STD_LOGIC;
      q : out STD_LOGIC_VECTOR (15 DOWNTO 0);
      usedw : out STD_LOGIC_VECTOR (9 DOWNTO 0)
    );
  end component;

  component GSMRegistr_tester
    port (
        WB_Addr: out std_logic_vector( 15 downto 0 );
        clk : out std_logic;
        WB_DataIn : out std_logic_vector( 15 downto 0 );
        nRst : out std_logic;
        WB_Sel: out std_logic_vector( 1 downto 0 );
        WB_STB : out std_logic;
        WB_WE : out std_logic;
	WB_Cyc: out std_logic;
        rdreq : out STD_LOGIC
    );
    end component;


  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics

  -- Ports
  signal WB_CTI: std_logic_vector(2 downto 0); 
  signal WB_Addr: std_logic_vector( 15 downto 0 );
  signal WB_Ack : std_logic;
  signal clk : std_logic;
  signal WB_DataIn : std_logic_vector( 15 downto 0 );
  signal WB_DataOut : std_logic_vector( 15 downto 0 );
  signal nRst : std_logic;
  signal WB_Sel: std_logic_vector( 1 downto 0 );
  signal WB_STB : std_logic;
  signal WB_WE : std_logic;
  signal WB_Cyc : STD_LOGIC;
  signal PRT_O : std_logic_vector( 15 downto 0 );
  signal Amplitude_OUT : std_logic_vector( 15 downto 0);
  signal StartPhase_OUT : std_logic_vector( 15 downto 0);
  signal CarrierFrequency_OUT : std_logic_vector(31 downto 0);
  signal SymbolFrequency_OUT : std_logic_vector( 31 downto 0);
  signal rdreq : STD_LOGIC;
  signal empty : STD_LOGIC;
  signal full : STD_LOGIC;
  signal q : STD_LOGIC_VECTOR (15 DOWNTO 0);
  signal usedw : STD_LOGIC_VECTOR (9 DOWNTO 0);

begin

  
  GSMRegistr_top_inst : GSMRegistr_top
    port map (
      WB_Addr=> WB_Addr,
      WB_Ack => WB_Ack,
      clk => clk,
      WB_DataIn => WB_DataIn,
      WB_DataOut => WB_DataOut,
      nRst => nRst,
      WB_Sel=> WB_Sel,
      WB_STB => WB_STB,
      WB_WE => WB_WE,
      WB_Cyc => WB_Cyc,
      WB_CTI => WB_CTI,
      PRT_O => PRT_O,
      Amplitude_OUT => Amplitude_OUT,
      StartPhase_OUT => StartPhase_OUT,
      CarrierFrequency_OUT => CarrierFrequency_OUT,
      SymbolFrequency_OUT => SymbolFrequency_OUT,
      rdreq => rdreq,
      empty => empty,
      full => full,
      q => q,
      usedw => usedw
    );

    GSMRegistr_tester_inst : GSMRegistr_tester
    port map (
        WB_Addr=> WB_Addr,
        clk => clk,
        WB_DataIn => WB_DataIn,
        nRst => nRst,
        WB_Sel=> WB_Sel,
        WB_STB => WB_STB,
        WB_WE => WB_WE,
	WB_Cyc => WB_Cyc,
        rdreq => rdreq
    );


end;
