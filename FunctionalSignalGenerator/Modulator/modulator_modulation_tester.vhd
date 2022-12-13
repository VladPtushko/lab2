library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
-- use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

use std.env.finish;
use std.env.stop;

entity modulator_modulation_tester is
    port (
        clk   : out std_logic := '0';
        nRst : out std_logic := '0';
        -- Amplitude: out std_logic_vector(15 downto 0); -- FROM LUT
        -- StartPhase: out std_logic_vector(15 downto 0);
        -- CarrierFrequency: in std_logic_vector(31 downto 0); -- PASSTHROW
        SymbolFrequency: out std_logic_vector(31 downto 0) := (others => '0') ;
        DataPort: out std_logic_vector(15 downto 0):= (others => '0');

        -- lut_address: out std_logic_vector(6 downto 0);

        ModulationMode: out std_logic_vector(1 downto 0):= (others => '0');
        Mode: out std_logic := '0' -- 0 - no modulation, 1 - modulation on
        -- SignalMode: out std_logic_vector; -- PASSTHROW
        -- nRstDDS  -- PASSTHROW
        -- Sync -- NOT USED

        
    );
end entity modulator_modulation_tester;

architecture a_modulator_modulation_tester of modulator_modulation_tester is
    signal clock_r:std_logic := '0';
begin

    
    clock_r <= not clock_r after 10 ns;
    clk <= clock_r;


    process
    begin
        nRst <= '0' after 1 ns, '1' after 15 ns;
        Mode <= '1' after 13 ns;

        SymbolFrequency <= X"010003FF" after 16 ns;
        -- DDS_en_s <= '1' after 17 ns;

        -- DataPort <= B"11" & X"FF";

        -- DataPort <= X"FFFF" after 0 ns,
        --             X"FEFE" after 3134 ns,
        --             B"1010101010101010" after 8634 ns;

        

        ModulationMode <=    "01" after 0 ns,
                                "10" after 3135 ns,
                                "00" after 8635 ns
                                -- "11" after 12145 ns
                            ;

        
       

        for k in 1 to 276 loop
            DataPort <= conv_std_logic_vector(k * 1000, DataPort'length);
            wait for 100 ns;
        end loop; 
            
            
            
        wait for 32000 ns;

        -- DDS_start_phase_s <= X"0001" after 5 ns;

        -- for k in 1048276-256 to 1048276+256 loop
        --     DDS_frequency_s <= conv_std_logic_vector(k * 102400, DDS_frequency_s'length);
        --     wait for 1000 ns;
        -- end loop;

        -- for k in 1048276-256 to 1048276+256 loop
        --     DDS_frequency_s <= conv_std_logic_vector(k * 102400, DDS_frequency_s'length);
        --     wait for 50 ns;
        -- end loop;


        -- for k in 0 to 512 loop
        --     DDS_start_phase_s <= conv_std_logic_vector(k * 1000, DDS_start_phase_s'length);
        --     wait for 1000 ns;
        -- end loop;

        

        
        -- DDS_start_phase_s <=    X"00F1" after 13135 ns,
        --     X"FFF1" after 17635 ns,
        --     X"00F1" after 27145 ns,
        --     X"FFFF" after 37145 ns
        -- ;

        -- wait for 40000 ns;

        -- DDS_frequency_s <= X"010003FF";

        -- for k in 0 to 256 loop
        --     DDS_amplitude_s <= conv_std_logic_vector(k * 256, DDS_amplitude_s'length);
        --     wait for 100 ns;
        -- end loop;

        

        -- for k in 12 to 32 loop
        --     DDS_amplitude_s <= conv_std_logic_vector(k * 1000, DDS_amplitude_s'length);
        --     wait for 1000 ns;
        -- end loop;

        

        -- DDS_amplitude_s <= X"FFFF" after 16 ns;
        --                     X"7FFF" after 10000 ns,
        --                     X"3FFF" after 20000 ns, 
        --                     X"1FFF" after 30000 ns,
        --                     X"0FFF" after 40000 ns
        --                     ;
        


        -- wait for 100 ns;
        report "Calling 'finish'";
        stop;
    end process;

end architecture;