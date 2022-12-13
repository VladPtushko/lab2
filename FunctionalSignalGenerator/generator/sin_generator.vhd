library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity sin_generator is
    port (
        clk: in std_logic;

        MainPhase_v: in std_logic_vector(9 downto 0);
        ShiftedPhase_v: in std_logic_vector(9 downto 0);
        SIN_I_s: out std_logic_vector(9 downto 0) := (others => '0');
        SIN_Q_s: out std_logic_vector(9 downto 0) := (others => '0');

        address_a: out std_logic_vector (7 downto 0); 
        address_b: out std_logic_vector (7 downto 0);
        q_a: in std_logic_vector (8 downto 0);
        q_b: in std_logic_vector (8 downto 0)
    );
end entity;

architecture a_sin_generator of sin_generator is
    signal phase_r : std_logic_vector(1 downto 0);
begin
    identifier : process(clk)
    begin
        if (rising_edge(clk)) then
            phase_r <= MainPhase_v(9 downto 8);

            if (MainPhase_v(9 downto 8) = "00") then  -- FIRST_QUATER -- так как у нас 1 четверть, здесь мы добавляем еще 3
                address_a <= MainPhase_v(7 downto 0);
                SIN_I_s <= ('0' & q_a);
            elsif (MainPhase_v(9 downto 8) = "01") then -- SECOND_QUATER
                address_a <= 255 - MainPhase_v(7 downto 0);
                SIN_I_s <= ('0' & q_a);
            elsif (MainPhase_v(9 downto 8) = "10") then -- THIRD_QUATER
                address_a <= MainPhase_v(7 downto 0);
                SIN_I_s <= 511 - ('1' & q_a);
            elsif (MainPhase_v(9 downto 8) = "11") then -- FOURTH_QUATER
                address_a <= 255 - MainPhase_v(7 downto 0);
                SIN_I_s <= 511 - ('1' & q_a);
            end if;

            -- phase_r <= ShiftedPhase_v(9 downto 8);

            if (ShiftedPhase_v(9 downto 8) = "00") then  -- FIRST_QUATER
                address_b <= ShiftedPhase_v(7 downto 0);
                SIN_Q_s <= ('0' & q_b);
            elsif (ShiftedPhase_v(9 downto 8) = "01") then -- SECOND_QUATER
                address_b <= 255 - ShiftedPhase_v(7 downto 0);
                SIN_Q_s <= ('0' & q_b);
            elsif (ShiftedPhase_v(9 downto 8) = "10") then -- THIRD_QUATER
                address_b <= ShiftedPhase_v(7 downto 0);
                SIN_Q_s <= 511 - ('1' & q_b);
            elsif (ShiftedPhase_v(9 downto 8) = "11") then -- FOURTH_QUATER
                address_b <= 255 - ShiftedPhase_v(7 downto 0);
                SIN_Q_s <= 511 - ('1' & q_b);
            end if;
        -- elsif (rising_edge(clk)) then
        --     if (MainPhase_v(9 downto 8) = "00") then  -- FIRST_QUATER
        --         -- address_a <= MainPhase_v(7 downto 0);
        --         SIN_I_s <= ('0' & q_a);
        --     elsif (MainPhase_v(9 downto 8) = "01") then -- SECOND_QUATER
        --         -- address_a <= 255 - MainPhase_v(7 downto 0);
        --         SIN_I_s <= ('0' & q_a);
        --     elsif (MainPhase_v(9 downto 8) = "10") then -- THIRD_QUATER
        --         -- address_a <= MainPhase_v(7 downto 0);
        --         SIN_I_s <= 511 - ('1' & q_a);
        --     elsif (MainPhase_v(9 downto 8) = "11") then -- FOURTH_QUATER
        --         -- address_a <= 255 - MainPhase_v(7 downto 0);
        --         SIN_I_s <= 511 - ('1' & q_a);
            -- end if;
        end if;

    end process;
end architecture;
