library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity demodulator_decoder_top is
    port (
        clk: in std_logic;
        nRst: in std_logic;
        IData_In :in STD_LOGIC_VECTOR(9 downto 0):=(others => '0');
	    QData_In :in STD_LOGIC_VECTOR(9 downto 0):=(others => '0');
	    DataValid : in std_logic :='0';
	    DataStrobe : out std_logic :='0'; 
        delay :OUT unsigned(9 downto 0):=(others => '1');
        dataout : out std_logic_vector(7 downto 0)
    );
end entity;

architecture a_demodulator_decoder_top of demodulator_decoder_top is
    signal address_in_division_lut		:  STD_LOGIC_VECTOR (8 DOWNTO 0);
    signal clock		:  STD_LOGIC  := '1';
    signal division_number		: STD_LOGIC_VECTOR (8 DOWNTO 0);
    signal modulation_mode : unsigned(1 downto 0) :=(others => '1');
	signal useful_information : STD_LOGIC_VECTOR(3 downto 0) :=(others => '0');

    component demodulator
        port(clk : in std_logic :='0';
	    nRst : in std_logic :='0';
	    IData_In :in STD_LOGIC_VECTOR(9 downto 0):=(others => '0');
	    QData_In :in STD_LOGIC_VECTOR(9 downto 0):=(others => '0');
	    DataValid : in std_logic :='0';
	    DataStrobe : out std_logic :='0';
	    address_in_division_lut		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0):=(others => '0');
	    clock		: OUT STD_LOGIC  := '1';
        division_number		: in STD_LOGIC_VECTOR (8 DOWNTO 0):=(others => '0');
	    modulation_mode :OUT unsigned(1 downto 0) :=(others => '1');
        delay :OUT unsigned(9 downto 0):=(others => '1');
	    useful_information :OUT STD_LOGIC_VECTOR(3 downto 0) :=(others => '0')
      );
    end component;
    

    component decoder_8b10b	 
        port(
            modulation_mode :OUT unsigned(1 downto 0) :=(others => '1');
            useful_information : in std_logic_vector(3 downto 0); --от Юры
            reset : in std_logic; --Active high reset
            clk : in std_logic;   --Clock to register output and disparity
            dataout : out std_logic_vector(7 downto 0) --Decoded output
        ); 
    end component; 

    component division_lut
        port (
            address_in_division_lut		: IN STD_LOGIC_VECTOR (8 DOWNTO 0):=(others => '0');
            clock		: IN STD_LOGIC  := '1';
            division_number		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0):=(others => '0')
        );
    end component division_lut;

begin
    demodulator_inst: demodulator
        port map(
            clk=>clk,
            nRst=>nRst,
            IData_In => IData_In,
            QData_In => QData_In,
            DataValid => DataValid,
            DataStrobe => DataStrobe,
            address_in_division_lut=>address_in_division_lut,
            clock=>clock,
            division_number=>division_number,
            modulation_mode => modulation_mode,
            useful_information => useful_information
        );
        decoder_8b10b_inst:  decoder_8b10b
        port map(
            clk  => clk,
            reset => nRst,
            dataout =>dataout,
	    modulation_mode => modulation_mode,
	    useful_information => useful_information
        );
        
    division_lut_inst: division_lut
        port map(
        address_in_division_lut=>address_in_division_lut,
        clock=>clock,
        division_number=>division_number
    );
end architecture;
