library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

-- ADC_OS  '1' parallel '0' multiplexed at I

-- ADC_GAIN = '0'
    -- This pin sets the internal signal gain at the inputs to the ADCs. 
        -- With this pin low the full scale differential input peak-to-peak signal is  GAIN equal to VREF. 
        -- With this pin high the full scale differential input peak to-peak signal is equal to 2 x VREF.

-- ADC_STBY = 1 reset, then 800 ns, then 0 at normal OR '0'
    -- Standby pin. The device operates normally with a logic low on this and the PD (Power Down) pin. 
        -- With this pin at a logic high and the PD pin at a logic low, the device is in the standby mode where it consumes just 30 mW of power. 
        -- It takes just 800 ns to come out of this mode after the STBY pin is brought low.

-- ADC_PD = '0'
    -- Power Down pin that, when high, puts the converter into the Power Down mode where it consumes just 1 mW of power. 
        -- It takes less than 1 ms to recover from this mode after the PD pin is brought low.
        -- If both the STBY and PD pins are high simultaneously, the PD pin dominates.

-- ADC_OF = '0'
        -- When this pin is 0 the output format is Offset Binary. 
        -- When this pin is 1 the output format is 2's complement.

-- ADC_OC = '0' reset, '1' in normal for calibration on 0V for 34 clocks. But without - 0.
        -- A low-to-high transition on this pin initiates an independent offset correction sequence for each converter, which
        -- takes 34 clock cycles to complete. 
        -- During this time 32 conversions are taken and averaged. The result is subtracted from subsequent conversions.
        -- Each input pair should have 0V differential value during this entire 34 clock period.

-- ADC_IQ_OUT (OUT, no change)
    -- Output data valid signal. 
        -- In the multiplexed mode, this pin transitions from low to high when the data bus transitions from Q-data to I-data,
        -- and from high to low when the data bus transitions from I-data to Q data. 
        -- In the Parallel mode, this pin transitions from low to high as the output data changes.


        -- pio1 f13 gain
        -- pio2 f15 os
        -- pio3 f16 stdb
        -- pio4 D16 pd
        -- d11 k2  clk      d11_r k1
        -- d12 L2  of       d11_r L1
        -- d13 p1  oc
        -- d14 r1  iq_out

entity adc_control is
    port (
        Clk_ADC   : in std_logic;  -- K2
        Clk_DataFlow : in std_logic;
        nRst: in std_logic;
        ReceiveDataMode: in std_logic; 

        Gain_s: out std_logic; -- F13
        OutputBusSelect_s: out std_logic; -- F15
        Standby_s: out std_logic; -- F16
        PowerDown_s: out std_logic; -- D16
        OffsetCorrect_s: out std_logic; -- P1
        OutputFormat_s: out std_logic -- L2
    );
end entity;

architecture a_adc_control of adc_control is
begin
    Dataflow_p: process (nRst, Clk_DataFlow)
    begin
--        if (nRst = '0') then
            Gain_s <= '0';
            OutputBusSelect_s <= '0';
            Standby_s  <= '0';
            PowerDown_s  <= '0';
            OffsetCorrect_s  <= '0';
            OutputFormat_s  <= '0';
        -- elsif rising_edge(Clk_DataFlow) then
            -- OutputBusSelect_s <= ReceiveDataMode;

            -- now we just ignore Q, not reconfigure ADC to parallel mode
--        end if;
    end process;
end architecture;