library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity separator is
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
end entity;








architecture separator_arch of separator is



    
    signal I_temp : std_logic_vector(9 downto 0);
    signal Q_temp : std_logic_vector(9 downto 0);

	 
	 
	 
	 
	 
	 
begin
    IData_Out <= I_temp;
    QData_Out <= Q_temp;

    DataValid <= DataStrobe;


    SignalSeparation: process (nRst, Clk)
    begin
        if(DataStrobe = '0') then 
		     I_temp <= (others => '0');
			  Q_temp <= (others => '0');
		  elsif (ReceiveDataMode = '1') then
		     I_temp <= ISig_in;
			  Q_temp <= QSig_in;
		  elsif (ReceiveDataMode = '0') then
		      I_temp <= ISig_in; 
				Q_temp <= (others => '0');
		  end if;	
    end process;
	 
	 
	 
	 

end separator_arch;