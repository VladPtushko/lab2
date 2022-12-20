library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fir_filter_test is
port (
  i_clk                   : in  std_logic;
  i_rstb                  : in  std_logic;
  i_pattern_sel           : in  std_logic;  -- '0'=> delta; '1'=> step
  i_start_generation      : in  std_logic;
  i_read_request          : in  std_logic;
  o_data_buffer           : out std_logic_vector( 9 downto 0); -- to seven segment
  o_test_add              : out std_logic_vector( 4 downto 0)); -- test read address
end fir_filter_test;
architecture rtl of fir_filter_test is
constant C_COEFF_0    : std_logic_vector( 7 downto 0):= std_logic_vector(to_signed(-10,8));
constant C_COEFF_1    : std_logic_vector( 7 downto 0):= std_logic_vector(to_signed(110,8));
constant C_COEFF_2    : std_logic_vector( 7 downto 0):= std_logic_vector(to_signed(127,8));
constant C_COEFF_3    : std_logic_vector( 7 downto 0):= std_logic_vector(to_signed(-20,8));
component fir_test_data_generator
port (
  i_clk                   : in  std_logic;
  i_rstb                  : in  std_logic;
  i_pattern_sel           : in  std_logic;  -- '0'=> delta; '1'=> step
  i_start_generation      : in  std_logic;
  o_data                  : out std_logic_vector( 7 downto 0); -- to FIR 
  o_write_enable          : out std_logic);  -- to the output buffer
end component;
component fir_filter_4 
port (
  i_clk        : in  std_logic;
  i_rstb       : in  std_logic;
  -- coefficient
  i_coeff_0    : in  std_logic_vector( 7 downto 0);
  i_coeff_1    : in  std_logic_vector( 7 downto 0);
  i_coeff_2    : in  std_logic_vector( 7 downto 0);
  i_coeff_3    : in  std_logic_vector( 7 downto 0);
  -- data input
  i_data       : in  std_logic_vector( 7 downto 0);
  -- filtered data 
  o_data       : out std_logic_vector( 9 downto 0));
end component;
component fir_output_buffer 
port (
  i_clk                   : in  std_logic;
  i_rstb                  : in  std_logic;
  i_write_enable          : in  std_logic;
  i_data                  : in  std_logic_vector( 9 downto 0); -- from FIR 
  i_read_request          : in  std_logic;
  o_data                  : out std_logic_vector( 9 downto 0); -- to seven segment
  o_test_add              : out std_logic_vector( 4 downto 0)); -- test read address
end component;
signal w_write_enable          : std_logic;
signal w_data_test             : std_logic_vector( 7 downto 0);
signal w_data_filter           : std_logic_vector( 9 downto 0);
begin
u_fir_test_data_generator : fir_test_data_generator
port map(
  i_clk                   => i_clk                   ,
  i_rstb                  => i_rstb                  ,
  i_pattern_sel           => i_pattern_sel           ,
  i_start_generation      => i_start_generation      ,
  o_data                  => w_data_test             ,
  o_write_enable          => w_write_enable          );
u_fir_filter_4 : fir_filter_4 
port map(
  i_clk        => i_clk        ,
  i_rstb       => i_rstb       ,
  -- coefficient
  i_coeff_0    => C_COEFF_0    ,
  i_coeff_1    => C_COEFF_1    ,
  i_coeff_2    => C_COEFF_2    ,
  i_coeff_3    => C_COEFF_3    ,
  -- data input
  i_data       => w_data_test  ,
  -- filtered data 
  o_data       => w_data_filter);
u_fir_output_buffer : fir_output_buffer 
port map(
  i_clk                   => i_clk                   ,
  i_rstb                  => i_rstb                  ,
  i_write_enable          => w_write_enable          ,
  i_data                  => w_data_filter           ,
  i_read_request          => i_read_request          ,
  o_data                  => o_data_buffer           ,
  o_test_add              => o_test_add              );
end rtl;