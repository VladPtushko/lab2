library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity Geterodine_module_tb is
end entity Geterodine_moduler_tb;

architecture a_Geterodine_module_tb of Geterodine_moduler_tb is
         WB_ADDR_IN:  std_logic_vector( 15 downto 0 );
        WB_ACK_OUT:  std_logic;
        WB_DATA_IN_0:  std_logic_vector( 15 downto 0 );
		    WB_DATA_IN_1:  std_logic_vector( 15 downto 0 );
		    WB_DATA_IN_2:  std_logic_vector( 15 downto 0 );
		    WB_DATA_IN_3:  std_logic_vector( 15 downto 0 );
        WB_DATA_OUT:  std_logic_vector( 15 downto 0 );
        WB_SEL_IN:  std_logic_vector( 1 downto 0 );
        WB_STB_IN:  std_logic;
        WB_WE:  std_logic;
	      WB_Cyc_0:  std_logic;
		    WB_Cyc_1:  std_logic;
		    WB_Cyc_2:  std_logic;
		    WB_Cyc_3:  std_logic;
		    WB_Ack:  std_logic;
		    WB_CTI:  std_logic_vector( 2 downto 0 );
        Clk   :  std_logic;
        nRst:  std_logic;
        ReceiveDataMode:  std_logic;
		    DataStrobe:  std_logic;
        ISig_In:  std_logic_vector(9 downto 0);
		    QSig_In:  std_logic_vector(9 downto 0);
		    FS_IncrDecr:  std_logic_vector(1 downto 0);
        IData_Out:  std_logic_vector(9 downto 0);
        QData_Out:  std_logic_vector(9 downto 0);
        DataValid:  std_logic;
  

    component fir_filter_4
        port (
       i_clk        : in  std_logic;
       i_rstb       : in  std_logic;
       i_data       : in  std_logic_vector( 9 downto 0);
  -- filtered data 
       o_data       : out std_logic_vector( 9 downto 0));
      );
    end component;
        

    component Geterodine_module_tester
        port (
        FS_IncrDecr: out std_logic_vector(1 downto 0);
        ReceiveDataMode: out std_logic;
        ISig_In: out std_logic_vector(9 downto 0);
		    QSig_In: out std_logic_vector(9 downto 0);
        Clk   : out std_logic;
        nRst: out std_logic;
        DataStrobe: out std_logic;
      );
    end component;
    
begin
    fir_filter_4_inst_I : fir_filter_4
    port map (
      i_clk => Clk,
      i_rstb => nRst,
      i_data => ISig_In,
      o_data => ISigOut,
      i_FS_IncrDecr => FS_IncrDecr,
    
     
    );
    fir_filter_4_inst_Q : fir_filter_4
    port map (
      i_clk => Clk_ADC,
      i_rstb => nRst,
      i_data => QSig_In,
      o_data => QSigOut,
      i_FS_IncrDecr => FS_IncrDecr,
    
     
    );
  

    demultiplexer_tester_i : entity work.Geterodine_module_tester
    port map (
        Clk => Clk,
        nRst => nRst,
        ISig_In => ISig_In
        QSig_In => QSig_In
        ReceiveDataMode => ReceiveDataMode,
        DataStrobe => DataStrobe
        FS_IncrDecr => FS_IncrDecr
       
    );
end architecture;