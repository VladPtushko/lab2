library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

entity generator is
    port (
        clk: in std_logic;
        nRst: in std_logic;
        DDS_en_s: in std_logic;
        DDS_mode_s: in std_logic_vector(1 downto 0);
        DDS_amplitude_s: in std_logic_vector(15 downto 0);
        DDS_frequency_s: in std_logic_vector(31 downto 0);
        DDS_start_phase_s: in std_logic_vector(15 downto 0);

        DAC_I_s: out std_logic_vector(9 downto 0);
        DAC_Q_s: out std_logic_vector(9 downto 0);

        MainPhase_s: out std_logic_vector(9 downto 0); --фаза
        ShiftedPhase_s: out std_logic_vector(9 downto 0); --сдвинутая на 90
        SIN_I_s: in std_logic_vector(9 downto 0); --вх сигналы с генератора синуса
        SIN_Q_s: in std_logic_vector(9 downto 0) --сдвинутый синус
    );
end entity;

architecture a_generator of generator is
    -- signal dac_i_r: std_logic_vector(9 downto 0);
    -- signal dac_q_r: std_logic_vector(9 downto 0);
    signal MainAccumulator_counter: std_logic_vector(31 downto 0);
    signal ShiftedAccumulator_counter: std_logic_vector(31 downto 0);

    signal saw_i_r: std_logic_vector(9 downto 0);
    signal square_i_r: std_logic_vector(9 downto 0);

    -- constant SIN_WAVE:          std_logic_vector(1 downto 0) := "00";
    -- constant SAW_WAVE:          std_logic_vector(1 downto 0) := "01";
    -- constant SQUARE_WAVE:       std_logic_vector(1 downto 0) := "10";
    -- constant MODULATED_WAVE:    std_logic_vector(1 downto 0) := "11";

    -- signal ampl_SIN_I_s: std_logic_vector(25 downto 0);
    signal ampl_SIN_I_s_all: std_logic_vector(26 downto 0);
    signal ampl_SIN_I_s10: std_logic_vector(9 downto 0);

    signal ampl_SIN_Q_s_all: std_logic_vector(26 downto 0);
    signal ampl_SIN_Q_s10: std_logic_vector(9 downto 0);

    signal detect_change: std_logic_vector(15 downto 0);
    

    constant HALF_PI: unsigned(15 downto 0) := X"4000";
    constant ZERO: unsigned(15 downto 0) := X"0000";

    signal DDS_start_phase_r: std_logic_vector(15 downto 0);
begin
    saw_i_r <= MainAccumulator_counter(31 downto 31-9);

    ampl_SIN_I_s_all <= signed(SIN_I_s) * unsigned(DDS_amplitude_s);
    ampl_SIN_Q_s_all <= signed(SIN_q_s) * unsigned(DDS_amplitude_s);

    ampl_SIN_I_s10 <= ampl_SIN_I_s_all(25 downto 25 - 9);    
    ampl_SIN_Q_s10 <= ampl_SIN_Q_s_all(25 downto 25 - 9); 
    
    
    detect_change <= DDS_start_phase_s xor DDS_start_phase_r;

    

    with DDS_mode_s select DAC_I_s <=
            ampl_SIN_I_s10 when "00", --SIN_WAVE
            saw_i_r when "01", -- SAW_WAVE
            square_i_r when "10", -- SQUARE_WAVE
            ampl_SIN_I_s10 when "11", -- MODULATED_WAVE
            (others => '0') when others;
    
    with DDS_mode_s select DAC_Q_s <=
        ampl_SIN_Q_s10 when "11", -- MODULATED_WAVE
        (others => '0') when others;

    with MainAccumulator_counter(31) select square_i_r <=
        (others => '1') when '1',
        (others => '0') when others;


    MainPhase_s <= MainAccumulator_counter(31 downto 31-9);  
    ShiftedPhase_s <= ShiftedAccumulator_counter(31 downto 31-9);     

 

    accumulator_p:  process(nRst, clk, DDS_en_s)
    begin
       

        if (DDS_en_s = '1') then
            if (nRst = '0') then
                MainAccumulator_counter <= (others => '0');
                ShiftedAccumulator_counter <= (others => '0');
                DDS_start_phase_r <= (others => '0');
            elsif (rising_edge(clk)) then
                if (unsigned(detect_change) = ZERO) then
                    DDS_start_phase_r <= DDS_start_phase_s;
                    MainAccumulator_counter <= unsigned(MainAccumulator_counter) + unsigned(DDS_frequency_s);
                    ShiftedAccumulator_counter <= unsigned(ShiftedAccumulator_counter) + unsigned(DDS_frequency_s);
                else
                    DDS_start_phase_r <= DDS_start_phase_s;
                    MainAccumulator_counter(31 downto 31-15) <= DDS_start_phase_s;
                    MainAccumulator_counter(31-14 downto 0) <= (others => '0') ;
    
                    ShiftedAccumulator_counter(31 downto 31-15) <= unsigned(DDS_start_phase_s) + HALF_PI;
                    ShiftedAccumulator_counter(31-14 downto 0) <= (others => '0') ;
                end if;
            end if;
        end if;
        
                
        -- elsif (DDS_en_s = '1') then
        --     if ( unsigned(detect_change) = HALF_PI) then
        --         DDS_start_phase_r <= DDS_start_phase_s;
        --         MainAccumulator_counter(31 downto 31-15) <= DDS_start_phase_s;
        --         MainAccumulator_counter(31-14 downto 0) <= (others => '0') ;

        --         ShiftedAccumulator_counter(31 downto 31-15) <= unsigned(DDS_start_phase_s) + HALF_PI;
        --         ShiftedAccumulator_counter(31-14 downto 0) <= (others => '0') ;
        --     elsif (rising_edge(clk)) then
        --         DDS_start_phase_r <= DDS_start_phase_s;
        --         MainAccumulator_counter <= unsigned(MainAccumulator_counter) + unsigned(DDS_frequency_s);
        --         ShiftedAccumulator_counter <= unsigned(ShiftedAccumulator_counter) + unsigned(DDS_frequency_s);
        --     end if;
        -- end if;

        -- elsif (DDS_en_s = '1') then
        --     if (rising_edge(clk)) then
        --         -- if (DDS_mode_s = SIN_WAVE) then
        --         --     dac_i_r <= SIN_I_s * DDS_amplitude_s;
        --         -- elsif (DDS_mode_s = SAW_WAVE) then
        --         --     dac_i_r <= MainAccumulator_counter(31 downto 31-9);
        --         --     -- dac_q_r <= ShiftedAccumulator_counter(31 downto 31-9);
        --         -- elsif (DDS_mode_s = SQUARE_WAVE) then
        --         --     if (MainAccumulator_counter(31) = '0') then
        --         --         dac_i_r <= (others => '0');
        --         --     elsif (MainAccumulator_counter(31) = '1') then
        --         --         dac_i_r <= (others => '1');
        --         --     end if;
        --         --
        --         --     -- if (ShiftedAccumulator_counter(31) = '0') then
        --         --     --     dac_q_r <= (others => '0');
        --         --     -- elsif (ShiftedAccumulator_counter(31) = '1') then
        --         --     --     dac_q_r <= (others => '1');
        --         --     -- end if;
        --         -- elsif (DDS_mode_s = MODULATED_WAVE) then
        --         --     --
        --         -- end if;
        --
        --
        --
        --     end if;
        -- end if;
    end process;
end architecture;
