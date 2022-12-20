library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity Geterodine_module is
        port(
		    WB_ADDR_IN: in std_logic_vector( 15 downto 0 );
        WB_ACK_OUT: out std_logic;
        WB_DATA_IN_0: in std_logic_vector( 15 downto 0 );
		  WB_DATA_IN_1: in std_logic_vector( 15 downto 0 );
		  WB_DATA_IN_2: in std_logic_vector( 15 downto 0 );
		  WB_DATA_IN_3: in std_logic_vector( 15 downto 0 );
        WB_DATA_OUT: out std_logic_vector( 15 downto 0 );
        WB_SEL_IN: in std_logic_vector( 1 downto 0 );
        WB_STB_IN: in std_logic;
        WB_WE: out std_logic;
	     WB_Cyc_0: out std_logic;
		  WB_Cyc_1: out std_logic;
		  WB_Cyc_2: out std_logic;
		  WB_Cyc_3: out std_logic;
		  WB_Ack: out std_logic;
		  WB_CTI: out std_logic_vector( 2 downto 0 );
		  
		  
        Clk   : in std_logic;
        nRst: in std_logic;
        ReceiveDataMode: in std_logic;
		  DataStrobe: in std_logic;

        ISig_In: in std_logic_vector(9 downto 0);
		  QSig_In: in std_logic_vector(9 downto 0);
		  
		  FS_IncrDecr: in std_logic_vector(1 downto 0);

        IData_Out: out std_logic_vector(9 downto 0);
        QData_Out: out std_logic_vector(9 downto 0);

        DataValid: out std_logic;
		  
		    i_coeff_0: in  std_logic_vector( 9 downto 0);
          i_coeff_1: in  std_logic_vector( 9 downto 0);
          i_coeff_2: in  std_logic_vector( 9 downto 0);
          i_coeff_3: in  std_logic_vector( 9 downto 0)	  
    );
end entity;

architecture geterodine_module_arch of Geterodine_module is

     signal I_temp : std_logic_vector(9 downto 0);
     signal Q_temp : std_logic_vector(9 downto 0);



        
      component separator is
    port (
		  
        Clk   : in std_logic;
        nRst: in std_logic;
        ReceiveDataMode: in std_logic;
		  DataStrobe: in std_logic;

        ISig_In: in std_logic_vector(9 downto 0);
		  QSig_In: in std_logic_vector(9 downto 0);
		  
		  

        IData_Out: out std_logic_vector(9 downto 0);
        QData_Out: out std_logic_vector(9 downto 0);

        DataValid: out std_logic
    );
end component;


      component fir_filter_4 is
    port (
      i_clk        : in  std_logic;
      i_rstb       : in  std_logic;
      -- coefficient
      i_coeff_0    : in  std_logic_vector( 9 downto 0);
      i_coeff_1    : in  std_logic_vector( 9 downto 0);
      i_coeff_2    : in  std_logic_vector( 9 downto 0);
      i_coeff_3    : in  std_logic_vector( 9 downto 0);
      -- data input
      i_data       : in  std_logic_vector( 9 downto 0);
      -- filtered data 
      o_data       : out std_logic_vector( 9 downto 0));
end component;

begin


    separate : separator port map(
		  
        Clk => Clk,
        nRst => nRst,
        ReceiveDataMode => ReceiveDataMode,
		  DataStrobe => DataStrobe,

        ISig_In => ISig_In,
		  QSig_In => QSig_In,
		  
		  

        IData_Out => I_temp,
        QData_Out => Q_temp,

        DataValid => DataValid
    );
	 
	 
	 
	 FIR1 : fir_filter_4 port map(
	    
		i_clk => Clk,    
      i_rstb => nRst,
      -- coefficient
      i_coeff_0 => i_coeff_0,
      i_coeff_1 => i_coeff_1,  
      i_coeff_2 => i_coeff_2,  
      i_coeff_3 => i_coeff_3, 
      -- data input
      i_data   => I_temp,  
      -- filtered data 
      o_data   => IData_Out  
	 
      );
		
		
		FIR2 : fir_filter_4 port map(
	    
		i_clk  => Clk,    
      i_rstb => nRst,
      -- coefficient
      i_coeff_0 => i_coeff_0,
      i_coeff_1 => i_coeff_1,  
      i_coeff_2 => i_coeff_2,  
      i_coeff_3 => i_coeff_3, 
       -- data input
      i_data   => Q_temp,  
      -- filtered data 
      o_data   => QData_Out  
      );



end geterodine_module_arch;







       

		
		
		
		
		
		
		
		
		