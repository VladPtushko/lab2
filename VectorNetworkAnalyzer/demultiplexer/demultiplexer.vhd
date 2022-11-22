library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity demultiplexer is
    port (
        Clk_ADC   : in std_logic;
        Clk_DataFlow : in std_logic;
        nRst: in std_logic;
        ReceiveDataMode: in std_logic;

        ADC_SigIn: in std_logic_vector(9 downto 0);

        ISigOut: out std_logic_vector(9 downto 0);
        QSigOut: out std_logic_vector(9 downto 0);

        DataStrobe: out std_logic
    );
end entity;


architecture a_demultiplexer of demultiplexer is
    signal DataStrobe_r: std_logic;
    signal I_v : std_logic_vector(9 downto 0);
    signal Q_v : std_logic_vector(9 downto 0);
    signal ConversionStarted_r: std_logic;
    signal IReceived_r: std_logic;
begin
    ISigOut <= I_v;
    QSigOut <= Q_v;

    DataStrobe <= DataStrobe_r;

    ADC_coversion_start_p: process (nRst, Clk_ADC)
    begin
        if (nRst = '0') then
            ConversionStarted_r <= '0';
        elsif falling_edge(Clk_ADC) then
            ConversionStarted_r <= '1';        
        end if;    
    end process;

    Dataflow_p: process (nRst, Clk_DataFlow)
    begin
        if (nRst = '0') then
            I_v <= (others => '-');
            Q_v <= (others => '-');

            DataStrobe_r <= '0';
            IReceived_r <= '0';
        elsif rising_edge(Clk_DataFlow) then
            if (ConversionStarted_r = '0') then
                DataStrobe_r <= '0';                
                IReceived_r <= '0';  
            elsif (ReceiveDataMode = '0') then
                I_v <= ADC_SigIn;
                Q_v <= (others => '0');
                DataStrobe_r <= '1';
            elsif (IReceived_r = '0') then
                I_v <= ADC_SigIn;
                DataStrobe_r <= '0';
                IReceived_r <= '1';
            else 
                Q_v <= ADC_SigIn;
                DataStrobe_r <= '1';
                IReceived_r <= '0';
            end if;
        end if;
    end process;

end architecture;