library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

use std.env.finish;
use std.env.stop;

entity generator_tester is
    port(
        clk               : out  std_logic := '0';
        nRst              : out  std_logic := '0';
        DDS_en_s          : out  std_logic := '0';
        DDS_mode_s        : out  std_logic_vector(1 downto 0) := (others => '0');
        DDS_amplitude_s   : out  std_logic_vector(15 downto 0) := (others => '1');
        DDS_frequency_s   : out  std_logic_vector(31 downto 0) := (others => '0');
        DDS_start_phase_s : out  std_logic_vector(15 downto 0) := (others => '0')
    );
end entity;

architecture a_generator_tester of generator_tester is
    signal clock_r:std_logic := '0';
begin
    clock_r <= not clock_r after 10 ns;
    clk <= clock_r;


    process
    begin
        nRst <= '1' after 15 ns;

        DDS_frequency_s <= "00000001000000000000001111111111" after 16 ns;
        DDS_en_s <= '1' after 17 ns;
        DDS_mode_s <= "00" after 30 ns;
        

        -- for k in 1048276-256 to 1048276+256 loop
        --     DDS_frequency_s <= conv_std_logic_vector(k * 102400, DDS_frequency_s'length);
        --     wait for 1000 ns;
        -- end loop;

        -- -- DDS_start_phase_s <= X"0001" after 5 ns;

        -- for k in 1048276-256 to 1048276+256 loop
        --     DDS_frequency_s <= conv_std_logic_vector(k * 102400, DDS_frequency_s'length);
        --     wait for 1000 ns;
        -- end loop;


        -- for k in 0 to 512 loop
        --     DDS_start_phase_s <= conv_std_logic_vector(k * 1000, DDS_start_phase_s'length);
        --     wait for 1000 ns;
        -- end loop;

        DDS_start_phase_s <=    X"00F1" after 3135 ns,
                                X"FFF1" after 8635 ns,
                                X"00F1" after 12145 ns,
                                X"FFFF" after 13145 ns
                            ;

        for k in 0 to 11 loop
            DDS_amplitude_s <= conv_std_logic_vector(k * 1000, DDS_amplitude_s'length);
            wait for 1000 ns;
        end loop;

        

        for k in 12 to 32 loop
            DDS_amplitude_s <= conv_std_logic_vector(k * 1000, DDS_amplitude_s'length);
            wait for 1000 ns;
        end loop;

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
