library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity Geterodine_module_tb is
end entity Geterodine_module_tb;

architecture a_Geterodine_module_tb of Geterodine_module_tb is
     signal   Clk  :  std_logic;
      signal  nRst:  std_logic;
      signal  ReceiveDataMode:  std_logic;
		signal    DataStrobe:  std_logic;
     signal   ISig_In:  std_logic_vector(9 downto 0);
		signal    QSig_In:  std_logic_vector(9 downto 0);
		signal    FS_IncrDecr:  std_logic_vector(1 downto 0);
      signal  IData_Out:  std_logic_vector(9 downto 0);
      signal  QData_Out:  std_logic_vector(9 downto 0);
       signal DataValid:  std_logic;
  
  
  
    component Geterodine_module 
	 port( Clk   : in std_logic;
        nRst: in std_logic;
        ReceiveDataMode: in std_logic;
		  DataStrobe: in std_logic;

        ISig_In: in std_logic_vector(9 downto 0);
		  QSig_In: in std_logic_vector(9 downto 0);
		  
		  FS_IncrDecr: in std_logic_vector(1 downto 0);

        IData_Out: out std_logic_vector(9 downto 0);
        QData_Out: out std_logic_vector(9 downto 0);

        DataValid: out std_logic
		  );
		  end component;
        

    component Geterodine_module_tester
        port (
        FS_IncrDecr: out std_logic_vector(1 downto 0);
        ReceiveDataMode: out std_logic;
        ISig_In: out std_logic_vector(9 downto 0);
		    QSig_In: out std_logic_vector(9 downto 0);
			-- ISig_Out: out std_logic_vector(9 downto 0);
        Clk   : out std_logic;
        nRst: out std_logic;
        DataStrobe: out std_logic
      );
    end component;
   
	 
	 
	 
begin
	Geterodine_module_inst: Geterodine_module
	port map(
	
		  Clk => Clk,
		nRst => nRst,
		ReceiveDataMode => ReceiveDataMode,
		DataStrobe => DataStrobe,
		ISig_In => ISig_In,
		QSig_In => QSig_In,
		FS_IncrDecr => FS_IncrDecr,
		IData_Out => IData_Out,
		QData_Out => QData_Out,
		DataValid => DataValid
   
  );

    Geterodine_module_tester_i : entity work.Geterodine_module_tester
    port map (
        Clk => Clk,
        nRst => nRst,
        ISig_In => ISig_In,
        QSig_In => QSig_In,
        ReceiveDataMode => ReceiveDataMode,
        DataStrobe => DataStrobe,
        FS_IncrDecr => FS_IncrDecr
       
    );
end architecture;