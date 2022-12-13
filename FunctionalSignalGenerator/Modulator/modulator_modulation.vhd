library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_signed.all;

use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- CONTROL

-- Mode — режим работы: 0 – обычный режим; 1 – режим PSK.
-- Modulation mode — «00» – QPSK; «01» – 8-PSK; «10» – 16-QAM; «11» – модуляция не используется.
-- Signal mode — «00» – гармонический сигнал; «01» – пилообразный сигнал; «10» – меандр; «11» – зарезервировано.
-- nRstDDS — сигнал сброса схемы прямого цифрового синтеза.
-- Sync — сигнал синхронизации, ‘1’ — разрешение использования внешней синхронизации для модуля организации пересылки данных средствами квадратурной модуляции.


-- 4.2.3.	АДРЕСА МОДУЛЯ ОРГАНИЗАЦИИ ПЕРЕСЫЛКИ ДАННЫХ СРЕДСТВАМИ КВАДРАТУРНОЙ МОДУЛЯЦИИ
-- Смещение	Размер, байт	Назначение	Описание
-- 0x0000	2	Amplitude	Амплитуда сигнала
-- 0x0002	2	Start Phase	Начальная фаза
-- 0x0004	4	Carrier Frequency	Частота несущей
-- 0x0008	4	Symbol Frequency	Частота следования символов
-- 0x000C	2	DataPort	Порт записи данных

entity modulator_modulation is
    port (
        clk   : in std_logic;
        nRst : in std_logic;
        -- Amplitude: out std_logic_vector(15 downto 0); -- FROM LUT
        -- StartPhase: out std_logic_vector(15 downto 0);
        -- CarrierFrequency: in std_logic_vector(31 downto 0); -- PASSTHROW
        -- SignalMode: out std_logic_vector; -- PASSTHROW
        -- nRstDDS  -- PASSTHROW

        SymbolFrequency: in std_logic_vector(31 downto 0);
        DataPort: in std_logic_vector(9 downto 0); -- 10 bits current data

        lut_address: out std_logic_vector(5 downto 0);

        ModulationMode: in std_logic_vector(1 downto 0);
        Mode: in std_logic; -- 0 - no modulation, 1 - modulation on

        -- Sync -- NOT USED

        performConvert: out std_logic
    );
end entity modulator_modulation;

architecture a_modulator_modulation of modulator_modulation is
    signal Symbol_clock: std_logic;
    signal SymbolAccumulator_counter: std_logic_vector(31 downto 0);

    signal data_r: std_logic_vector(13 downto 0); -- shift register, when 10 bits shifted, new major bits are set (4 bits always correct)
    signal shift_counter: std_logic_vector(2 downto 0); -- from 0 to 3 bits
    signal shifted_10bit_counter: std_logic_vector(3 downto 0); -- for renewing shift register with data


    signal need_shifted_r: std_logic_vector(2 downto 0);

    signal performConvert_r: std_logic;
begin
    performConvert <= performConvert_r;

    Symbol_accumulator: process (clk, nRst)
    begin
        if nRst = '0' then
            SymbolAccumulator_counter <= (others => '0'); 
        elsif rising_edge(clk) then
            -- Symbol_clock <= SymbolAccumulator_counter(31);

            -- TODO: simplify it
            if (SymbolAccumulator_counter(31) = '1') then
                SymbolAccumulator_counter <= '0' & (SymbolAccumulator_counter(30 downto 0) + SymbolFrequency(30 downto 0));
            else
                SymbolAccumulator_counter <= SymbolAccumulator_counter + SymbolFrequency;
            end if;
        end if;
    end process;


    shift_p: process (clk, nRst)
    begin
        if nRst = '0' then
            data_r <= (others => '0');
            shift_counter <= (others => '0') ;
            shifted_10bit_counter <= (others => '0'); 

            performConvert_r <= '0';
        elsif rising_edge(clk) then
            if (shifted_10bit_counter = 0) then
                data_r(data_r'high downto data_r'high - 9) <= DataPort(9 downto 0);
                shifted_10bit_counter <= CONV_STD_LOGIC_VECTOR(10, shifted_10bit_counter'length);

                performConvert_r <= '1';
            elsif (shift_counter > 0) then
                shift_counter <= shift_counter - 1;
                shifted_10bit_counter <= shifted_10bit_counter - 1;

                data_r <= '0' & data_r(data_r'high downto data_r'low + 1);
                
                performConvert_r <= '0';

                -- TODO: write shifted bit to ring buffer!
                -- or write current data to it
                -- sr_out <= data_r(data_r'low);
            else
                shift_counter <= need_shifted_r;
                performConvert_r <= '0';
            end if;
        end if;
    end process;

    Symbol_new: process(clk, nRst)
    begin
        if nRst = '0' then
            lut_address <= (others => '0');

            need_shifted_r <= CONV_STD_LOGIC_VECTOR(4, need_shifted_r'length);  -- need perform initial shift for filling buffer
        elsif rising_edge(clk) then
            if (Mode = '1' and SymbolAccumulator_counter(31) = '1') then -- modulation and new symbol arrived
                -- TODO: I need to start calibration after modulation mode change
                if (ModulationMode = "00") then -- QPSK
                    -- 0000 00 - 0000 11
                    lut_address(5 downto 2) <= B"0000";
                    lut_address(1 downto 0) <= data_r(1 downto 0);

                    need_shifted_r <= CONV_STD_LOGIC_VECTOR(2, need_shifted_r'length);
                elsif (ModulationMode = "01") then -- 8PSK
                    -- 010 000 - 010 111
                    lut_address(5 downto 3) <= B"010";
                    lut_address(2 downto 0) <= data_r(2 downto 0);

                    need_shifted_r <= CONV_STD_LOGIC_VECTOR(3, need_shifted_r'length);
                elsif (ModulationMode = "10") then -- 16QAM
                    -- 10 0000 - 10 1111
                    lut_address(5 downto 4) <= B"10";
                    lut_address(3 downto 0) <= data_r(3 downto 0);

                    need_shifted_r <= CONV_STD_LOGIC_VECTOR(4, need_shifted_r'length);
                end if;
            end if;
        end if;
    end process;
end architecture;