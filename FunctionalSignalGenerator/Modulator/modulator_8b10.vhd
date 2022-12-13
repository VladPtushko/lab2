library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

entity modulator_8b10 is
    port (
        clk   : in std_logic;
        nRst : in std_logic;

        performConvert: in std_logic;

        DataPort: in std_logic_vector(15 downto 0);

        CodedData: out std_logic_vector(9 downto 0)
        
    );
end entity modulator_8b10;

architecture a_modulator_8b10 of modulator_8b10 is
    component enc_8b10b
        port (
        RESET : in std_logic;
        SBYTECLK : in std_logic;
        KI : in std_logic;
        AI : in std_logic;
        BI : in std_logic;
        CI : in std_logic;
        DI : in std_logic;
        EI : in std_logic;
        FI : in std_logic;
        GI : in std_logic;
        HI : in std_logic;
        JO : out std_logic;
        HO : out std_logic;
        GO : out std_logic;
        FO : out std_logic;
        IO : out std_logic;
        EO : out std_logic;
        DO : out std_logic;
        CO : out std_logic;
        BO : out std_logic;
        AO : out std_logic
      );
    end component;
    
    signal DataIn_r : std_logic_vector(7 downto 0);
    signal CurrentByte_r: std_logic;
begin
    enc_8b10b_inst : enc_8b10b
    port map (
        RESET => "not"(nRst),
        SBYTECLK => clk,

        KI => '0', -- Control (K) input(active high)
        AI => DataIn_r(7),
        BI => DataIn_r(6),
        CI => DataIn_r(5),
        DI => DataIn_r(4),
        EI => DataIn_r(3),
        FI => DataIn_r(2),
        GI => DataIn_r(1),
        HI => DataIn_r(0),

        JO => CodedData(9),
        HO => CodedData(8),
        GO => CodedData(7),
        FO => CodedData(6),
        IO => CodedData(5),
        EO => CodedData(4),
        DO => CodedData(3),
        CO => CodedData(2),
        BO => CodedData(1),
        AO => CodedData(0)
    );

    con_p: process (clk, nRst)
    begin
        if nRst = '0' then
            -- CodedData <= (others => '0'); 
            CurrentByte_r <= '0'; -- minor byte first
        elsif rising_edge(clk) then
            if (performConvert = '1') then
                CurrentByte_r <= not CurrentByte_r;
            end if;
        end if;
    end process;

    with CurrentByte_r select DataIn_r <=
        DataPort(15 downto 8) when '1',
        DataPort(7 downto 0) when '0',
        (others => '0') when others;
    

end architecture;
