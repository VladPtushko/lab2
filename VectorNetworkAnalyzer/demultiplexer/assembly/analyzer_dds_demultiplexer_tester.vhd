library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

use std.env.stop;

entity analyzer_dds_demultiplexer_tester is
    port (
        Clk_ADC   : in std_logic;
        Clk_DataFlow : in std_logic;
        nRst: in std_logic;
        ReceiveDataMode: out std_logic;

        ADC_SigIn: out std_logic_vector(9 downto 0)
    );
end entity analyzer_dds_demultiplexer_tester;

architecture a_analyzer_dds_demultiplexer_tester of analyzer_dds_demultiplexer_tester is
    -- signal Clk_ADC_r: std_logic := '0';
    -- signal Clk_Dataflow_r : std_logic := '0';

    procedure skiptime_Dataflow(time_count: in integer) is
    begin
        count_time: for k in 0 to time_count-1 loop
            wait until falling_edge(Clk_Dataflow); 
            wait for 200 ps; --need to wait for signal stability, value depends on the Clk frequency. 
                        --For example, for Clk period = 100 ns (10 MHz) it's ok to wait for 200 ps.
        end loop count_time ;
    end;

    procedure skiptime_ADC(time_count: in integer) is
    begin
        count_time: for k in 0 to time_count-1 loop
            wait until falling_edge(Clk_ADC); 
            wait for 200 ps; --need to wait for signal stability, value depends on the Clk frequency. 
                        --For example, for Clk period = 100 ns (10 MHz) it's ok to wait for 200 ps.
        end loop count_time ;
    end;
begin
    -- Clk_ADC <= Clk_ADC_r;
    -- Clk_DataFlow <= Clk_Dataflow_r;
    
    -- Clk_ADC_r <= not Clk_ADC_r after 20 ns;
    -- Clk_Dataflow_r <= not Clk_Dataflow_r after 10 ns;

    tester_process: process
    begin
        ADC_SigIn <= "0000000000";
        ReceiveDataMode <= '1';
        -- nRst <= '0';

        wait until nRst = '1';

        skiptime_Dataflow(1);

        -- nRst <= '1';
        
        for k in 1023 downto 1023-6 loop
            skiptime_Dataflow(1);
            ADC_SigIn <= conv_std_logic_vector(k, ADC_SigIn'length);
        end loop;
            
        ReceiveDataMode <= '0';

        for k in 1023 downto 1023-3 loop
            skiptime_ADC(1);
            ADC_SigIn <= conv_std_logic_vector(k, ADC_SigIn'length);
        end loop;

        skiptime_ADC(1);
        -- nRst <= '0';
        ReceiveDataMode <= '1';

        skiptime_ADC(1);
        -- nRst <= '1';

        for k in 1023 downto 1023-6 loop
            skiptime_Dataflow(1);
            ADC_SigIn <= conv_std_logic_vector(k, ADC_SigIn'length);
        end loop;
            
        ReceiveDataMode <= '0';

        for k in 1023 downto 1023-3 loop
            skiptime_ADC(1);
            ADC_SigIn <= conv_std_logic_vector(k, ADC_SigIn'length);
        end loop;
            
        stop;
    end process;
end architecture;