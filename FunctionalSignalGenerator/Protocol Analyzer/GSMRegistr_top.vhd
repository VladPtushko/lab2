library ieee;
use ieee.std_logic_1164.all;


entity GSMRegistr_top is
    port (
        WB_Addr_IN: in std_logic_vector( 15 downto 0 );
        WB_Ack_OUT: out std_logic;
        Clk: in std_logic;
        WB_Data_IN: in std_logic_vector( 15 downto 0 );
        WB_Data_OUT: out std_logic_vector( 15 downto 0 );
        nRst: in std_logic;
        WB_Sel_IN: in std_logic_vector( 1 downto 0 );
        WB_STB_IN: in std_logic;
        WB_WE_IN: in std_logic;
	WB_Cyc		: in	std_logic;
	WB_CTI		: in	std_logic_vector(2 downto 0);
    
        PRT_O: out std_logic_vector( 15 downto 0 ); --данные для кодирования и модуляции
        Amplitude_OUT: out std_logic_vector( 15 downto 0);
        StartPhase_OUT: out std_logic_vector( 15 downto 0);
        CarrierFrequency_OUT: out std_logic_vector(31 downto 0);
        SymbolFrequency_OUT: out std_logic_vector( 31 downto 0);
        
        
		rdreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
    );
end entity GSMRegistr_top;

architecture rtl of GSMRegistr_top is
    component GSMRegister
        port (
        WB_Addr_IN : in std_logic_vector( 15 downto 0 );
        WB_Ack_OUT : out std_logic;
        Clk : in std_logic;
        WB_Data_IN : in std_logic_vector( 15 downto 0 );
        WB_Data_OUT : out std_logic_vector( 15 downto 0 );
        nRst : in std_logic;
        WB_Sel_IN : in std_logic_vector( 1 downto 0 );
        WB_STB_IN : in std_logic;
        WB_WE_IN : in std_logic;
	WB_Cyc		: in	std_logic;
	WB_CTI		: in	std_logic_vector(2 downto 0);
        PRT_O : out std_logic_vector( 15 downto 0 );
        Amplitude_OUT : out std_logic_vector( 15 downto 0);
        StartPhase_OUT : out std_logic_vector( 15 downto 0);
        CarrierFrequency_OUT : out std_logic_vector(31 downto 0);
        SymbolFrequency_OUT : out std_logic_vector( 31 downto 0);
        DataPort_OUT : out std_logic_vector( 15 downto 0);
        wrreq : out std_logic
      );
    end component;

    component GSMRegistr_FIFO
        port (
        clock : in STD_LOGIC;
        data : in STD_LOGIC_VECTOR (15 DOWNTO 0);
        rdreq : in STD_LOGIC;
        wrreq : in STD_LOGIC;
        empty : out STD_LOGIC;
        full : out STD_LOGIC;
        q : out STD_LOGIC_VECTOR (15 DOWNTO 0);
        usedw : out STD_LOGIC_VECTOR (9 DOWNTO 0)
      );
    end component;
    
    signal wrreq : std_logic;
    signal DataPort_r: std_logic_vector( 15 downto 0 );
begin
    GSMRegister_inst : GSMRegister
        port map (
            WB_Addr_IN => WB_Addr_IN,
            WB_Ack_OUT => WB_Ack_OUT,
            Clk => Clk,
            WB_Data_IN => WB_Data_IN,
            WB_Data_OUT => WB_Data_OUT,
            nRst => nRst,
            WB_Sel_IN => WB_Sel_IN,
            WB_STB_IN => WB_STB_IN,
            WB_WE_IN => WB_WE_IN,
	    WB_Cyc => WB_Cyc,
	    WB_CTI => WB_CTI,
            PRT_O => PRT_O,
            Amplitude_OUT => Amplitude_OUT,
            StartPhase_OUT => StartPhase_OUT,
            CarrierFrequency_OUT => CarrierFrequency_OUT,
            SymbolFrequency_OUT => SymbolFrequency_OUT,
            DataPort_OUT => DataPort_r,
            wrreq => wrreq
        );

    GSMRegistr_FIFO_inst : GSMRegistr_FIFO
        port map (
            clock => clk,
            data => DataPort_r,
            rdreq => rdreq,
            wrreq => wrreq,
            empty => empty,
            full => full,
            q => q,
            usedw => usedw
        );
end architecture;
