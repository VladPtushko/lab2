library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity Protocol_exchange_module is
  port (
    Clk : in std_logic;
    nRst : in std_logic;
    --??????? Fifo
    q_input : in std_logic_vector (15 downto 0);
    usedw_input_fi : in std_logic_vector (10 downto 0);
    rdreq_output : out std_logic;
    --??????? Fifo
    data_output : out std_logic_vector (15 downto 0);
    usedw_input_fo : in std_logic_vector (10 downto 0);
    wrreq_output : out std_logic;
    --WISHBONE
    WB_Addr : out std_logic_vector (15 downto 0);
    WB_DataOut : out std_logic_vector (15 downto 0);
    WB_DataIn_0 : in std_logic_vector (15 downto 0);
    WB_DataIn_1 : in std_logic_vector (15 downto 0);
    WB_DataIn_2 : in std_logic_vector (15 downto 0);
    WB_DataIn_3 : in std_logic_vector (15 downto 0);
    WB_WE : out std_logic;--?????? ?????????? ??????
    WB_Sel : out std_logic_vector (1 downto 0);--Select
    WB_STB : out std_logic;--???????????? ??????
    WB_Cyc_0 : out std_logic;--???????? ?????? ???????? ??????????
    WB_Cyc_1 : out std_logic;
    WB_Cyc_2 : out std_logic;
    WB_Cyc_3 : out std_logic;
    WB_Ack : in std_logic;--????????????? ???????? ?????????? ????????? ???????? ??????
    WB_CTI : out std_logic_vector (2 downto 0)-- ?000? ? ??????? ????; ??????
    -- ?001? ? ???????? ???? ? ????????????? ???????; ?? ???
    -- ?010? ? ???????? ???? ? ???????????????? ???????; ???
    -- ?011-110? ? ???????????????;
    -- ?111? ? ????????? ?????
  );
end entity;
architecture rtl of Protocol_exchange_module is
  type current_type is (state_wait, header_read, addres_check, header_analysis, header_transfer, data_transfer, error_handling);
  signal header_word_count : std_logic_vector(1 downto 0);
  signal current_state : current_type;
  signal double_write_s : std_logic;
  signal header_transfer_end_s : std_logic;
  signal read_en_r : std_logic_vector(1 downto 0);
  --signal write_en_r : std_logic_vector(1 downto 0);
  signal byte_count : std_logic_vector(10 downto 0);
  --signal data_F_W_r : std_logic_vector (15 downto 0);
  --signal data_W_F_r : std_logic_vector (15 downto 0);
  --signal data_r : std_logic_vector (15 downto 0);
  signal Cmd_r : std_logic_vector(2 downto 0);
  signal FB_r : std_logic;
  signal R1_r : std_logic_vector(1 downto 0);
  signal BCount_r : std_logic_vector (9 downto 0);
  signal TID_r : std_logic_vector (7 downto 0);
  signal AddrValid_r : std_logic_vector (2 downto 0);
  signal R2_r : std_logic_vector(4 downto 0);
  signal Addr_r : std_logic_vector (15 downto 0);
  signal Addr_write_r : std_logic_vector (15 downto 0);

  --signal WB_we_s : std_logic;
  --signal WB_sel_r : std_logic_vector (1 downto 0);
  --signal WB_stb_s : std_logic;
  signal WB_cyc_0_s : std_logic;
  signal WB_cyc_1_s : std_logic;
  signal WB_cyc_2_s : std_logic;
  signal WB_cyc_3_s : std_logic;
  signal WB_ack_check_s : std_logic;
  --signal WB_cti_r : std_logic_vector (2 downto 0);

  signal WB_ready_r : std_logic_vector (1 downto 0);

begin
  process (Clk, nRst) begin
    if (nRst = '0') then
      current_state <= state_wait;

    elsif (rising_edge(Clk)) then
      case current_state is
        when state_wait =>
          if (usedw_input_fi > 2) then
            current_state <= header_read;
          end if;

        when header_read =>
          if (header_word_count = B"01") then
            current_state <= addres_check;
          end if;

        when addres_check =>
          current_state <= header_analysis;

        when header_analysis =>
          if (FB_r = '0' and AddrValid_r = B"000") then
            if (Cmd_r = B"010" or Cmd_r = B"100" or Cmd_r = B"110") then
              current_state <= data_transfer;
            else
              current_state <= header_transfer;
            end if;
          else
            current_state <= header_transfer;
          end if;

        when header_transfer =>
          if (header_transfer_end_s = '1') then
            if (double_write_s = '1') then
              current_state <= header_transfer;
            elsif (AddrValid_r = B"000") then
              current_state <= data_transfer;
            elsif (Cmd_r = B"001" or Cmd_r = B"011" or Cmd_r = B"101") then
              current_state <= error_handling;
            else
              current_state <= state_wait;
            end if;
          end if;

        when data_transfer =>
          if (byte_count = 0 or byte_count = 2047) then
            current_state <= state_wait;
          end if;

        when error_handling =>
          if (byte_count = 0 or byte_count = 2047) then
            current_state <= state_wait;
          end if;
      end case;

    end if;
  end process;
  --#####################################################################################################################################
  Main : process (Clk, nRst) begin
    if (nRst = '0') then
      byte_count <= (others => '0');
      header_word_count <= (others => '0');
      read_en_r <= (others => '0');
      Cmd_r <= (others => '0');
      FB_r <= '0';
      R1_r <= (others => '0');
      BCount_r <= (others => '0');
      TID_r <= (others => '0');
      AddrValid_r <= (others => '0');
      R2_r <= (others => '0');
      Addr_r <= (others => '0');
      Addr_write_r <= (others => '0');
      rdreq_output <= '0';
      wrreq_output <= '0';
      double_write_s <= '0';
      header_transfer_end_s <= '0';

      data_output <= (others => '0');

      WB_DataOut <= (others => '0');
      WB_cyc_0_s <= '0';
      WB_cyc_1_s <= '0';
      WB_cyc_2_s <= '0';
      WB_cyc_3_s <= '0';
      WB_ack_check_s <= '0';
      WB_ready_r <= B"00";
      WB_Addr <= (others => '0');
      WB_WE <= '0';
      WB_Sel <= (others => '0');
      WB_STB <= '0';
      WB_Cyc_0 <= '0';
      WB_Cyc_1 <= '0';
      WB_Cyc_2 <= '0';
      WB_Cyc_3 <= '0';
      WB_CTI <= (others => '0');

    elsif (rising_edge(Clk)) then
      if (current_state = header_read) then
        if (header_word_count = B"00") then
          rdreq_output <= '1';
          read_en_r <= B"01";
          header_word_count <= B"11";
        elsif (read_en_r = B"01") then
          read_en_r <= B"11";
        elsif (read_en_r <= B"11") then
          if (header_word_count = B"11") then
            Cmd_r <= q_input(2 downto 0);
            FB_r <= q_input(3);
            R1_r <= q_input(5 downto 4);
            BCount_r <= q_input(15 downto 6);
            byte_count(9 downto 0) <= q_input(15 downto 6);
            byte_count(10) <= '0';
          elsif (header_word_count = B"10") then
            TID_r <= q_input(7 downto 0);
            AddrValid_r <= q_input(10 downto 8);
            R2_r <= q_input(15 downto 11);
            read_en_r <= B"00";
            rdreq_output <= '0';
          elsif (header_word_count = B"01") then
            Addr_r <= q_input;
          end if;
          header_word_count <= header_word_count - B"01";
        end if;
        --===============================================================================================================================
      elsif (current_state = addres_check) then--????????
        if (Addr_r < X"0100") then--256
          if ((Addr_r + byte_count) < X"0100") then
            Addr_write_r <= Addr_r;
            AddrValid_r <= B"000";
            WB_Cyc_0_s <= '1';
            WB_Cyc_1_s <= '0';
            WB_Cyc_2_s <= '0';
            WB_Cyc_3_s <= '0';
          else
            AddrValid_r <= B"001";
            Addr_r <= X"0100";
          end if;
          ----------------------------------------------------------------------------------------------------------
        elsif (Addr_r > X"00FF" and Addr_r < X"0200") then--256
          if ((Addr_r + byte_count) < X"0200") then
            Addr_write_r <= Addr_r - X"0100";
            AddrValid_r <= B"000";
            WB_Cyc_0_s <= '0';
            WB_Cyc_1_s <= '1';
            WB_Cyc_2_s <= '0';
            WB_Cyc_3_s <= '0';
          else
            AddrValid_r <= B"010";
            Addr_r <= X"0100";
          end if;
          ----------------------------------------------------------------------------------------------------------
        elsif (Addr_r > X"01FF" and Addr_r < X"0300") then--256
          if ((Addr_r + byte_count) < X"0300") then
            Addr_write_r <= Addr_r;-- - X"0200";
            AddrValid_r <= B"000";
            WB_Cyc_0_s <= '1';
            WB_Cyc_1_s <= '0';
            WB_Cyc_2_s <= '0';
            WB_Cyc_3_s <= '0';
          else
            AddrValid_r <= B"001";
            Addr_r <= X"0100";
          end if;
          ----------------------------------------------------------------------------------------------------------
        elsif (Addr_r > X"02FF" and Addr_r < X"0400") then--256
          if ((Addr_r + byte_count) < X"0400") then
            Addr_write_r <= Addr_r - X"0300";
            AddrValid_r <= B"000";
            WB_Cyc_0_s <= '0';
            WB_Cyc_1_s <= '0';
            WB_Cyc_2_s <= '1';
            WB_Cyc_3_s <= '0';
          else
            AddrValid_r <= B"011";
            Addr_r <= X"0100";
          end if;
          ----------------------------------------------------------------------------------------------------------
        elsif (Addr_r > X"03FF" and Addr_r < X"1000") then--15K
          Addr_r <= X"3C00";
          AddrValid_r <= B"110";
          ----------------------------------------------------------------------------------------------------------
        elsif (Addr_r > X"0FFF" and Addr_r < X"1800") then--2K
          Addr_r <= X"0800";
          AddrValid_r <= B"001";
          ----------------------------------------------------------------------------------------------------------
        else --46K
          Addr_r <= X"B800";
          AddrValid_r <= B"111";
        end if;
        --===============================================================================================================================
      elsif (current_state = header_transfer) then
        if (header_word_count = B"00") then
          header_transfer_end_s <= '0';
          if (double_write_s = '1') then
            double_write_s <= '0';
          elsif (FB_r = '1' and AddrValid_r = B"000") then
            if (Cmd_r = B"001" or Cmd_r = B"011" or Cmd_r = B"101") then
              double_write_s <= '1';
            end if;
          end if;
          header_word_count <= B"11";
        else
          if (usedw_input_fo < 1022) then
            wrreq_output <= '1';
            if (header_word_count = B"11") then
              data_output(2 downto 0) <= Cmd_r;
              data_output(3) <= FB_r;
              data_output(5 downto 4) <= R1_r;
              data_output(15 downto 6) <= BCount_r;
              header_word_count <= header_word_count - B"01";
            elsif (header_word_count = B"10") then
              data_output(7 downto 0) <= TID_r;
              data_output(10 downto 8) <= AddrValid_r;
              data_output(15 downto 11) <= R2_r;
              header_word_count <= header_word_count - B"01";
            elsif (header_word_count = B"01") then
              data_output <= Addr_r;
              header_transfer_end_s <= '1';
            end if;

            if (header_transfer_end_s = '1') then
              wrreq_output <= '0';
              header_transfer_end_s <= '0';
              header_word_count <= B"00";
            end if;
          end if;
        end if;
        --===============================================================================================================================
      elsif (current_state = error_handling) then
        if (usedw_input_fi > 0) then
          if (byte_count = 0 or byte_count = 2047) then
            rdreq_output <= '0';
          else
            rdreq_output <= '1';
          end if;
          byte_count <= byte_count - B"10";
        else
          rdreq_output <= '0';
        end if;
        --===============================================================================================================================
      elsif (current_state = data_transfer) then
        ---------------------------------------------------------------------------------------------------------------------------------
        if (Cmd_r = B"001") then--?????? ???????????????? ??????
          if (WB_ack_check_s = '0') then
            WB_ack_check_s <= WB_Ack;
          end if;
          if (byte_count = 0 or byte_count = 2047) then
            wrreq_output <= '0';
            WB_ready_r <= B"00";
          elsif (usedw_input_fo < 1022) then
            if (WB_ready_r = B"00") then
              WB_Addr <= Addr_write_r;
              WB_WE <= '0';
              WB_STB <= '1';
              WB_Cyc_0 <= WB_cyc_0_s;
              WB_Cyc_1 <= WB_cyc_1_s;
              WB_Cyc_2 <= WB_cyc_2_s;
              WB_Cyc_3 <= WB_cyc_3_s;
              wrreq_output <= '0';
              WB_ready_r <= B"01";
              if (byte_count = 2) then
                WB_Sel <= B"11";
                WB_CTI <= B"111";
              elsif (byte_count = 1) then
                WB_Sel <= B"01";
                WB_CTI <= B"111";
              else
                WB_Sel <= B"11";
                WB_CTI <= B"000";
              end if;
            elsif (WB_ready_r = B"01") then
              if (WB_Ack = '1' or WB_ack_check_s = '1') then
                WB_ack_check_s <= '0';
                if (byte_count = 1 or byte_count = 2) then
                  WB_Cyc_0 <= '0';
                  WB_Cyc_1 <= '0';
                  WB_Cyc_2 <= '0';
                  WB_Cyc_3 <= '0';
                  WB_STB <= '0';
                end if;
                byte_count <= byte_count - B"10";
                WB_ready_r <= B"00";
                wrreq_output <= '1';
                if (WB_ready_r = B"11") then
                  WB_ready_r <= B"00";
                  wrreq_output <= '1';
                elsif (WB_Cyc_0_s = '1') then
                  data_output <= WB_DataIn_0;
                elsif (WB_Cyc_1_s = '1') then
                  data_output <= WB_DataIn_1;
                elsif (WB_Cyc_2_s = '1') then
                  data_output <= WB_DataIn_2;
                elsif (WB_Cyc_3_s = '1') then
                  data_output <= WB_DataIn_3;
                end if;
              end if;
            end if;
          else
            wrreq_output <= '0';
            WB_STB <= '0';
          end if;
          -------------------------------------------------------------------------------------------------------------------------------------
        elsif (Cmd_r = B"010") then--?????? ???????????????? ??????
          if (WB_ack_check_s = '0') then
            WB_ack_check_s <= WB_Ack;
          end if;
          if (WB_ready_r = B"00" and usedw_input_fi > 0) then
            rdreq_output <= '1';
            WB_ready_r <= B"10";
            WB_STB <= '0';
            ------------------------------------------------
          elsif (WB_ready_r = B"01") then
            if (WB_Ack = '1' or WB_ack_check_s = '1') then
              WB_STB <= '0';
              if (usedw_input_fi > 0) then
                WB_ack_check_s <= '0';
                if (byte_count = 2 or byte_count = 1) then
                  rdreq_output <= '0';
                  WB_Cyc_0 <= '0';
                  WB_Cyc_1 <= '0';
                  WB_Cyc_2 <= '0';
                  WB_Cyc_3 <= '0';
                else
                  rdreq_output <= '1';
                end if;
                WB_ready_r <= B"10";
                byte_count <= byte_count - B"10";
              end if;
            end if;
          elsif (WB_ready_r = B"10") then
            if (byte_count = 0 or byte_count = 2047) then
              WB_ready_r <= B"00";
            else
              WB_ready_r <= B"11";
            end if;
            WB_STB <= '0';
            rdreq_output <= '0';
          elsif (WB_ready_r = B"11") then
            WB_Addr <= Addr_write_r;
            WB_WE <= '1';
            WB_STB <= '1';
            WB_Cyc_0 <= WB_cyc_0_s;
            WB_Cyc_1 <= WB_cyc_1_s;
            WB_Cyc_2 <= WB_cyc_2_s;
            WB_Cyc_3 <= WB_cyc_3_s;
            WB_DataOut <= q_input;
            if (byte_count = 2) then
              WB_Sel <= B"11";
              WB_CTI <= B"111";
            elsif (byte_count = 1) then
              WB_Sel <= B"01";
              WB_CTI <= B"111";
            else
              WB_Sel <= B"11";
              WB_CTI <= B"000";
            end if;
            WB_ready_r <= B"01";
            rdreq_output <= '0';
          end if;
        elsif (Cmd_r = B"011") then--?????? ???????????????? ??????
          if (WB_ack_check_s = '0') then
            WB_ack_check_s <= WB_Ack;
          end if;
          if (byte_count = 0 or byte_count = 2047) then
            wrreq_output <= '0';
            WB_ready_r <= B"00";
          elsif (usedw_input_fo < 1022) then
            if (WB_ready_r = B"00") then
              WB_Addr <= Addr_write_r;
              WB_WE <= '0';
              WB_STB <= '1';
              WB_Cyc_0 <= WB_cyc_0_s;
              WB_Cyc_1 <= WB_cyc_1_s;
              WB_Cyc_2 <= WB_cyc_2_s;
              WB_Cyc_3 <= WB_cyc_3_s;
              wrreq_output <= '0';
              WB_ready_r <= B"01";
              if (byte_count = 2) then
                WB_Sel <= B"11";
                WB_CTI <= B"111";
              elsif (byte_count = 1) then
                WB_Sel <= B"01";
                WB_CTI <= B"111";
              else
                WB_Sel <= B"11";
                WB_CTI <= B"001";
              end if;
            elsif (WB_ready_r = B"01") then
              if (WB_Ack = '1' or WB_ack_check_s = '1') then
                WB_ack_check_s <= '0';
                if (byte_count = 1 or byte_count = 2) then
                  WB_Cyc_0 <= '0';
                  WB_Cyc_1 <= '0';
                  WB_Cyc_2 <= '0';
                  WB_Cyc_3 <= '0';
                  WB_STB <= '0';
                end if;
                byte_count <= byte_count - B"10";
                WB_ready_r <= B"00";
                wrreq_output <= '1';
                if (WB_ready_r = B"11") then
                  WB_ready_r <= B"00";
                  wrreq_output <= '1';
                elsif (WB_Cyc_0_s = '1') then
                  data_output <= WB_DataIn_0;
                elsif (WB_Cyc_1_s = '1') then
                  data_output <= WB_DataIn_1;
                elsif (WB_Cyc_2_s = '1') then
                  data_output <= WB_DataIn_2;
                elsif (WB_Cyc_3_s = '1') then
                  data_output <= WB_DataIn_3;
                end if;
              end if;
            end if;
          else
            wrreq_output <= '0';
            WB_STB <= '0';
          end if;
          -------------------------------------------------------------------------------------------------------------------------------------
        elsif (Cmd_r = B"100") then--?????? ???????????????? ??????
          if (WB_ack_check_s = '0') then
            WB_ack_check_s <= WB_Ack;
          end if;
          if (WB_ready_r = B"00" and usedw_input_fi > 0) then
            rdreq_output <= '1';
            WB_ready_r <= B"10";
            WB_STB <= '0';
            ------------------------------------------------
          elsif (WB_ready_r = B"01") then
            if (WB_Ack = '1' or WB_ack_check_s = '1') then
              WB_STB <= '0';
              if (usedw_input_fi > 0) then
                WB_ack_check_s <= '0';
                if (byte_count = 2 or byte_count = 1) then
                  rdreq_output <= '0';
                  WB_Cyc_0 <= '0';
                  WB_Cyc_1 <= '0';
                  WB_Cyc_2 <= '0';
                  WB_Cyc_3 <= '0';
                else
                  rdreq_output <= '1';
                end if;
                WB_ready_r <= B"10";
                byte_count <= byte_count - B"10";
              end if;
            end if;
          elsif (WB_ready_r = B"10") then
            if (byte_count = 0 or byte_count = 2047) then
              WB_ready_r <= B"00";
            else
              WB_ready_r <= B"11";
            end if;
            WB_STB <= '0';
            rdreq_output <= '0';
          elsif (WB_ready_r = B"11") then
            WB_Addr <= Addr_write_r;
            WB_WE <= '1';
            WB_STB <= '1';
            WB_Cyc_0 <= WB_cyc_0_s;
            WB_Cyc_1 <= WB_cyc_1_s;
            WB_Cyc_2 <= WB_cyc_2_s;
            WB_Cyc_3 <= WB_cyc_3_s;
            WB_DataOut <= q_input;
            if (byte_count = 2) then
              WB_Sel <= B"11";
              WB_CTI <= B"111";
            elsif (byte_count = 1) then
              WB_Sel <= B"01";
              WB_CTI <= B"111";
            else
              WB_Sel <= B"11";
              WB_CTI <= B"001";
            end if;
            WB_ready_r <= B"01";
            rdreq_output <= '0';
          end if;

        elsif (Cmd_r = B"101") then--?????? ???????????????? ??????
          if (WB_ack_check_s = '0') then
            WB_ack_check_s <= WB_Ack;
          end if;
          if (byte_count = 0 or byte_count = 2047) then
            wrreq_output <= '0';
            WB_ready_r <= B"00";
          elsif (usedw_input_fo < 1022) then
            if (WB_ready_r = B"00") then
              WB_Addr <= Addr_write_r;
              Addr_write_r <= Addr_write_r + B"10";
              WB_WE <= '0';
              WB_STB <= '1';
              WB_Cyc_0 <= WB_cyc_0_s;
              WB_Cyc_1 <= WB_cyc_1_s;
              WB_Cyc_2 <= WB_cyc_2_s;
              WB_Cyc_3 <= WB_cyc_3_s;
              wrreq_output <= '0';
              WB_ready_r <= B"01";
              if (byte_count = 2) then
                WB_Sel <= B"11";
                WB_CTI <= B"111";
              elsif (byte_count = 1) then
                WB_Sel <= B"01";
                WB_CTI <= B"111";
              else
                WB_Sel <= B"11";
                WB_CTI <= B"010";
              end if;
            elsif (WB_ready_r = B"01") then
              if (WB_Ack = '1' or WB_ack_check_s = '1') then
                WB_ack_check_s <= '0';
                if (byte_count = 1 or byte_count = 2) then
                  WB_Cyc_0 <= '0';
                  WB_Cyc_1 <= '0';
                  WB_Cyc_2 <= '0';
                  WB_Cyc_3 <= '0';
                  WB_STB <= '0';
                end if;
                byte_count <= byte_count - B"10";
                WB_ready_r <= B"00";
                wrreq_output <= '1';
                if (WB_ready_r = B"11") then
                  WB_ready_r <= B"00";
                  wrreq_output <= '1';
                elsif (WB_Cyc_0_s = '1') then
                  data_output <= WB_DataIn_0;
                elsif (WB_Cyc_1_s = '1') then
                  data_output <= WB_DataIn_1;
                elsif (WB_Cyc_2_s = '1') then
                  data_output <= WB_DataIn_2;
                elsif (WB_Cyc_3_s = '1') then
                  data_output <= WB_DataIn_3;
                end if;
              end if;
            end if;
          else
            wrreq_output <= '0';
            WB_STB <= '0';
          end if;
          -------------------------------------------------------------------------------------------------------------------------------------
        elsif (Cmd_r = B"110") then--?????? ???????????????? ??????
          if (WB_ack_check_s = '0') then
            WB_ack_check_s <= WB_Ack;
          end if;
          if (WB_ready_r = B"00" and usedw_input_fi > 0) then
            rdreq_output <= '1';
            WB_ready_r <= B"10";
            WB_STB <= '0';
            ------------------------------------------------
          elsif (WB_ready_r = B"01") then
            if (WB_Ack = '1' or WB_ack_check_s = '1') then
              WB_STB <= '0';
              if (usedw_input_fi > 0) then
                WB_ack_check_s <= '0';
                if (byte_count = 2 or byte_count = 1) then
                  rdreq_output <= '0';
                  WB_Cyc_0 <= '0';
                  WB_Cyc_1 <= '0';
                  WB_Cyc_2 <= '0';
                  WB_Cyc_3 <= '0';
                else
                  rdreq_output <= '1';
                end if;
                WB_ready_r <= B"10";
                byte_count <= byte_count - B"10";
              end if;
            end if;
          elsif (WB_ready_r = B"10") then
            if (byte_count = 0 or byte_count = 2047) then
              WB_ready_r <= B"00";
            else
              WB_ready_r <= B"11";
            end if;
            WB_STB <= '0';
            rdreq_output <= '0';
          elsif (WB_ready_r = B"11") then
            WB_Addr <= Addr_write_r;
            Addr_write_r <= Addr_write_r + B"10";
            WB_WE <= '1';
            WB_STB <= '1';
            WB_Cyc_0 <= WB_cyc_0_s;
            WB_Cyc_1 <= WB_cyc_1_s;
            WB_Cyc_2 <= WB_cyc_2_s;
            WB_Cyc_3 <= WB_cyc_3_s;
            WB_DataOut <= q_input;
            if (byte_count = 2) then
              WB_Sel <= B"11";
              WB_CTI <= B"111";
            elsif (byte_count = 1) then
              WB_Sel <= B"01";
              WB_CTI <= B"111";
            else
              WB_Sel <= B"11";
              WB_CTI <= B"010";
            end if;
            WB_ready_r <= B"01";
            rdreq_output <= '0';
          end if;
        end if;
      end if;
      ------------------------------------------------------------------------------------------------------------------------------------------------
    end if;
  end process Main;
  --##################################################################################################################################
end architecture;