library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
-- use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

use std.env.stop;

entity generator_assembly2_tester is
  port (
    WB_Addr : out std_logic_vector( 15 downto 0 );
    clk : out std_logic;
    WB_DataIn: out std_logic_vector( 15 downto 0 );
    nRst : out std_logic;
    WB_Sel: out std_logic_vector( 1 downto 0 );
    WB_STB : out std_logic;
    WB_WE: out std_logic;
    WB_Cyc		: out	std_logic;
    WB_CTI		: out	std_logic_vector(2 downto 0);
    
    rdreq : out STD_LOGIC
);
end;

architecture a_generator_assembly of generator_assembly2_tester is
  signal clock_r:std_logic := '0';
  signal data_counter: std_logic_vector(15 downto 0) := (others => '0') ;

  procedure skiptime(time_count: in integer) is
  begin
      count_time: for k in 0 to time_count-1 loop
          wait until falling_edge(clock_r); 
          wait for 200 ps; --need to wait for signal stability, value depends on the Clk frequency. 
                      --For example, for Clk period = 100 ns (10 MHz) it's ok to wait for 200 ps.
      end loop count_time ;
  end;

  
  signal DataIn: std_logic_vector(15 downto 0);

  procedure send_data (
    signal data:in std_logic_vector(15 downto 0);
    signal WB_Addr :out std_logic_vector( 15 downto 0 );
    signal WB_DataIn : out std_logic_vector( 15 downto 0 );
    signal WB_Sel :out std_logic_vector( 1 downto 0 );
    signal WB_STB : out std_logic;
    signal WB_WE :out std_logic;
    signal WB_Cyc :out std_logic
    ) is
  begin
    skiptime(1);
    WB_DataIn <= data;
    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',3 => '1',2 => '1', others => '0');
    WB_WE <= '1';
    WB_STB <= '1';
    WB_Sel <= "01";
    skiptime(1);
    WB_STB <= '0';
    
    skiptime(5);
    
    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',3 => '1',2 => '1', others => '0');
    WB_WE <= '0';
    WB_STB <= '1';
    WB_Sel <= "11";
    skiptime(1);
    WB_STB <= '0';
  end procedure;

  procedure send_carrier (
    signal data:in std_logic_vector(31 downto 0);
    signal WB_Addr :out std_logic_vector( 15 downto 0 );
    signal WB_DataIn : out std_logic_vector( 15 downto 0 );
    signal WB_Sel :out std_logic_vector( 1 downto 0 );
    signal WB_STB : out std_logic;
    signal WB_WE :out std_logic;
    signal WB_Cyc :out std_logic
    ) is
  begin
    skiptime(1);
    --for 0x0204
    WB_DataIn <= data(31 downto 16);
    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',2 => '1', others => '0');
    WB_WE <= '1';
    WB_STB <= '1';
    WB_Sel <= "01";
    skiptime(1);
    WB_STB <= '0';

    skiptime(5);

    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',2 => '1', others => '0');
    WB_WE <= '0';
    WB_STB <= '1';
    WB_Sel <= "11";
    skiptime(1);
    WB_STB <= '0';
    skiptime(10);

    --for 0x0206
    WB_DataIn <= data(15 downto 0);
    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',2 => '1',1 => '1', others => '0');
    WB_WE <= '1';
    WB_STB <= '1';
    WB_Sel <= "01";
    skiptime(1);
    WB_STB <= '0';

    skiptime(5);

    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',2 => '1',1 => '1', others => '0');
    WB_WE <= '0';
    WB_STB <= '1';
    WB_Sel <= "11";
    skiptime(1);
    WB_STB <= '0';
    skiptime(10);
  end procedure;

  procedure send_symbol (
    signal data:in std_logic_vector(31 downto 0);
    signal WB_Addr :out std_logic_vector( 15 downto 0 );
    signal WB_DataIn : out std_logic_vector( 15 downto 0 );
    signal WB_Sel :out std_logic_vector( 1 downto 0 );
    signal WB_STB : out std_logic;
    signal WB_WE :out std_logic;
    signal WB_Cyc :out std_logic
    ) is
  begin
    skiptime(1);
    WB_DataIn <= data(31 downto 16);
    --for 0x0208
    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',3 => '1', others => '0');
    WB_WE <= '1';
    WB_STB <= '1';
    WB_Sel <= "01";
    skiptime(1);
    WB_STB <= '0';
    
    skiptime(5);
    
    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',3 => '1', others => '0');
    WB_WE <= '0';
    WB_STB <= '1';
    WB_Sel <= "11";
    skiptime(1);
    WB_STB <= '0';
    skiptime(10);
    
    --for 0x020A
    WB_DataIn <= data(15 downto 0);
    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',3 => '1',1 => '1', others => '0');
    WB_WE <= '1';
    WB_STB <= '1';
    WB_Sel <= "01";
    skiptime(1);
    WB_STB <= '0';
    
    skiptime(5);
    
    WB_Cyc <= '1';
    WB_Addr <= (9 => '1',3 => '1',1 => '1', others => '0');
    WB_WE <= '0';
    WB_STB <= '1';
    WB_Sel <= "11";
    skiptime(1);
    WB_STB <= '0';
    skiptime(10);
  end procedure;

  procedure send_prt (
    signal data:in std_logic_vector(15 downto 0);
    signal WB_Addr :out std_logic_vector( 15 downto 0 );
    signal WB_DataIn : out std_logic_vector( 15 downto 0 );
    signal WB_Sel :out std_logic_vector( 1 downto 0 );
    signal WB_STB : out std_logic;
    signal WB_WE :out std_logic;
    signal WB_Cyc :out std_logic
    ) is
  begin
    skiptime(1);
    WB_DataIn <= data;

    --for address 0x0000
    WB_WE <= '1';
    WB_STB <= '1';
    -- WB_CTI <= "000";
    WB_Cyc <= '1';
    -- WB_DataIn <= "0110000010011100";
    WB_Addr <= (others => '0');
    WB_Sel <= "11";
    skiptime(1);
    WB_STB <= '0';
    skiptime(5);
    -- WB_DataIn <= "1000100000101001";
    WB_Cyc <= '1';
    WB_Addr <= (others => '0');
    WB_WE <= '0';
    WB_STB <= '1';
    WB_Sel <= "01";
    skiptime(1);
    WB_STB <= '0';
    skiptime(5);
    -- WB_DataIn <= "0010100100000000";
    WB_Cyc <= '1';
    WB_Addr <= (others => '0');
    WB_WE <= '1';
    WB_STB <= '1';
    WB_Sel <= "10";
    skiptime(1);
    WB_STB <= '0';
    skiptime(10);
  end procedure;



  -- signal clk : std_logic;
  -- signal nRst : std_logic;
  -- signal Sync : std_logic;
  signal SignalMode_r : std_logic_vector(1 downto 0) := (others => '0') ;
  signal ModulationMode_r : std_logic_vector(1 downto 0) := (others => '0');
  signal Mode_r : std_logic :=  '0';
  -- signal AmpErr : std_logic;
  signal CarrierFrequency_r : std_logic_vector(31 downto 0) := (others => '0');
  signal SymbolFrequency_r : std_logic_vector(31 downto 0) := (others => '0');
  signal DataPort_r : std_logic_vector(15 downto 0) := (others => '0');
  -- signal rdreq : std_logic;
  -- signal empty : std_logic;
  signal PRT_O : std_logic_vector( 15 downto 0 ) := (others => '0');

  
  procedure data_send(
    signal data_counter: inout std_logic_vector(15 downto 0);
    signal WB_Addr :out std_logic_vector( 15 downto 0 );
    signal WB_DataIn : out std_logic_vector( 15 downto 0 );
    signal WB_Sel :out std_logic_vector( 1 downto 0 );
    signal WB_STB : out std_logic;
    signal WB_WE :out std_logic;
    signal WB_Cyc :out std_logic
  ) is
  begin
    for i in 100 downto 0 loop
      data_counter <= data_counter + 1;
      skiptime(500);
      send_data(data_counter, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
  end loop;
  end procedure;
  
begin
  process(clock_r)
  begin
      if (rising_edge(clock_r)) then
          DataIn <= data_counter;
      end if;
  end process;


  clock_r <= not clock_r after 10 ns;
  clk <= clock_r;



  PRT_O(4 downto 3) <= SignalMode_r;
  PRT_O(2 downto 1) <= ModulationMode_r;
  PRT_O(0) <= Mode_r;

  process
  begin
      SignalMode_r <= "11";
      Mode_r <= '0';
      nRst <= '0';
      skiptime(1000);

      nRst <= '1';

      send_prt(PRT_O, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);

      

      CarrierFrequency_r <= X"010003FF";
      send_carrier(CarrierFrequency_r, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      SymbolFrequency_r <= X"010003FF";
      send_symbol(SymbolFrequency_r, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);


      Mode_r <= '0';
      ModulationMode_r <= "10";

      send_prt(PRT_O, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      skiptime(10);
      Mode_r <= '1';
      send_prt(PRT_O, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      data_send(data_counter, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      


      Mode_r <= '0';
      ModulationMode_r <= "01";
      send_prt(PRT_O, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      skiptime(10);
      Mode_r <= '1';
      send_prt(PRT_O, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      data_send(data_counter, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);


      Mode_r <= '0';
      ModulationMode_r <= "00";
      send_prt(PRT_O, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      skiptime(10);
      Mode_r <= '1';
      send_prt(PRT_O, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      data_send(data_counter, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
          

      
      data_send(data_counter, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      SymbolFrequency_r <= X"030003FF";
      send_carrier(CarrierFrequency_r, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);      
      data_send(data_counter, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);

      data_send(data_counter, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      SymbolFrequency_r <= X"7FFFFFFF";
      send_symbol(SymbolFrequency_r, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      data_send(data_counter, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);

      Mode_r <= '0';
      ModulationMode_r <= "11";
      send_prt(PRT_O, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      skiptime(10);
      Mode_r <= '1';
      send_prt(PRT_O, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);
      data_send(data_counter, WB_Addr, WB_DataIn, WB_Sel, WB_STB, WB_WE, WB_Cyc);

      stop;
  end process;
end;