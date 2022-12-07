library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;
entity Test is
  port (
    Clk : in std_logic;
    nRst : in std_logic;
    --входная Fifo
    q_output : in std_logic_vector (15 downto 0);
    usedw_input : in std_logic_vector (10 downto 0);
    rdreq_output : out std_logic;
    --входная Fifo
    data_input : out std_logic_vector (15 downto 0);
    wrreq_input : out std_logic;
    --WISHBONE
    WB_Addr : out std_logic_vector (15 downto 0);
    WB_DataOut : out std_logic_vector (15 downto 0);
    WB_DataIn_0 : in std_logic_vector (15 downto 0);
    WB_WE : out std_logic;--Сигнал разрешения записи
    WB_Sel : out std_logic_vector (1 downto 0);--Select
    WB_STB : out std_logic;--корректность данных
    WB_Cyc_0 : out std_logic_vector (1 downto 0);--сигналом выбора ведомого устройства
    WB_Ack : in std_logic;--подтверждения штатного завершения пересылки элемента пакета
    WB_CTI : out std_logic_vector (2 downto 0)-- “000” — обычный цикл;
    -- “001” — пакетный цикл с фиксированным адресом;
    -- “010” — пакетный цикл с инкрементируемым адресом;
    -- “011-110” — зарезервировано;
    -- “111” — последний пакет
  );
end entity;
architecture rtl of Test is
  type current_type is (state_wait, header_read, header_analasis, header_write, error_edit, cmd_state, data_edit);
  --type read_type is (h1, h2, h3, d1);
  signal header_word_left : std_logic_vector(2 downto 1);
  signal current_state : current_type;
  --signal R_typ : read_type;
  signal used_words : std_logic_vector(10 downto 0);
  signal byte_left : std_logic_vector(9 downto 0);
  signal data_s : std_logic_vector (15 downto 0);
  signal Cmd : std_logic_vector(2 downto 0);
  signal FB : std_logic;
  signal R1 : std_logic_vector(1 downto 0);
  signal BCount : std_logic_vector (9 downto 0);
  signal TID : std_logic_vector (7 downto 0);
  signal AddrValid : std_logic_vector (2 downto 0);
  signal R2 : std_logic_vector(4 downto 0);
  signal Addr : std_logic_vector (15 downto 0);
  signal Addr_write : std_logic_vector (15 downto 0);

begin

  process (Clk, nRst) begin
    if (nRst = '1') then
      used_words <= (others => '0');
      byte_left <= (others => '0');
      data_s <= (others => '0');
      Cmd <= (others => '0');
      FB <= '0';
      R1 <= (others => '0');
      BCount <= (others => '0');
      TID <= (others => '0');
      AddrValid <= (others => '0');
      R2 <= (others => '0');
      Addr <= (others => '0');
      current_state <= state_wait;
    elsif (Clk'event and Clk = '1') then
      used_words <= usedw_input;
      if (current_state = state_wait) then
        if (used_words > 2) then
          if (byte_left = 0 or byte_left = 1023) then
          end if;
          current_state <= header_read;
          header_word_left <= B"11";
        end if;

      elsif (current_state = header_read and header_word_left = "00") then
        current_state <= header_analasis;
      end if;

    elsif (current_state = header_write and header_word_left = "00") then
      if (AddrValid = B"000") then
        current_state <= data_edit;
      elsif (Cmd = B"010" or Cmd = B"100" or Cmd = B"110") then
        current_state <= error_edit;
      else
        current_state <= state_wait;
      end if;
    end if;
  end process;

  process (Clk, nRst) begin
    if (nRst = '1') then
      used_words <= (others => '0');
      byte_left <= (others => '0');
      data_s <= (others => '0');
      Cmd <= (others => '0');
      FB <= '0';
      R1 <= (others => '0');
      BCount <= (others => '0');
      TID <= (others => '0');
      AddrValid <= (others => '0');
      R2 <= (others => '0');
      Addr <= (others => '0');
      current_state <= state_wait;
    elsif (Clk'event and Clk = '1') then
      if (current_state = header_read) then
        if (header_word_left = B"11") then
          rdreq_output <= '1';
          data_s <= q_output;
          Cmd <= data_s(2 downto 0);
          FB <= data_s(3);
          R1 <= data_input(5 downto 4);
          BCount <= data_s(15 downto 6);
          byte_left <= BCount;
        elsif (header_word_left = B"10") then
          rdreq_output <= '1';
          data_s <= q_output;
          TID <= data_input(9 downto 0);
          AddrValid <= data_s(10 downto 8);
          R2 <= data_input(15 downto 11);
        elsif (header_word_left = B"01") then
          rdreq_output <= '1';
          data_s <= q_output;
          Addr <= data_s;
        end if;
        header_word_left <= header_word_left - B"01";

      elsif (current_state = header_analasis) then
        if (Addr < X"0100") then--256
          Addr_write <= Addr;
          AddrValid <= B"000";
        elsif (Addr > X"00FF" and Addr < X"0200") then--256
          Addr_write <= Addr - X"0100";
          AddrValid <= B"000";
        elsif (Addr > X"01FF" and Addr < X"0300") then--256
          Addr_write <= Addr - X"0200";
          AddrValid <= B"000";
        elsif (Addr > X"02FF" and Addr < X"0FFF") then--256
          Addr_write <= Addr - X"0300";
          AddrValid <= B"000";
        elsif (Addr > X"03FF" and Addr < X"1000") then--15K
          Addr <= X"3C00";
          AddrValid <= B"110";
        elsif (Addr > X"0FFF" and Addr < X"1800") then--2K
          Addr <= X"0800";
          AddrValid <= B"001";
        else --46K
          Addr <= X"B800";
          AddrValid <= B"110";
        end if;
        if (FB = 0 and AddrValid = B"000") then
          current_state <= data_edit;
        else
          current_state <= header_write;
          header_word_left <= B"11";
        end if;

      elsif (current_state = header_write) then
        if (header_word_left = B"11") then
          wrreq_input <= '1';
          data_s(2 downto 0) <= Cmd;
          data_s(3) <= FB;
          data_s(5 downto 4) <= R1;
          data_s(15 downto 6) <= BCount;
          data_input <= data_s;
        elsif (header_word_left = B"10") then
          wrreq_input <= '1';
          data_s(9 downto 0) <= TID;
          data_s(10 downto 8) <= AddrValid;
          data_s(15 downto 11) <= R2;
          data_input <= data_s;
        elsif (header_word_left = B"01") then
          wrreq_input <= '1';
          data_input <= Addr;
        end if;
        header_word_left <= header_word_left - B"01";

      elsif (current_state = error_edit) then--очистка fifo
        if (used_words > 0) then
          rdreq_output <= '1';
          data_s <= q_output;
          byte_left <= byte_left - 2;
        end if;
        if (byte_left = 0 or byte_left = 1023) then
          current_state <= state_wait;
        end if;
      end if;

    elsif (current_state = data_edit) then
      if (cmd_state = B"001") then --Чтение конфигурационных данных

        if (current_state = header_write) then
          if (header_word_left = B"11") then
            wrreq_input <= '1';
            data_s(2 downto 0) <= Cmd;
            data_s(3) <= FB;
            data_s(5 downto 4) <= R1;
            data_s(15 downto 6) <= BCount;
            data_input <= data_s;

          elsif (header_word_left = B"10") then
            wrreq_input <= '1';
            data_s(9 downto 0) <= TID;
            data_s(10 downto 8) <= AddrValid;
            data_s(15 downto 11) <= R2;
            data_input <= data_s;
          elsif (header_word_left = B"01") then
            wrreq_input <= '1';
            data_input <= Addr;
          end if;
          header_word_left <= header_word_left - B"01";

        elsif (current_state = data_edit) then
          WB_WE <= '0';
          if (WB_Ack = '1') then
            data_s <= WB_DataIn_0;
            data_input <= data_s;
            byte_left <= byte_left - 2;
          end if;
        end if;

      elsif (cmd_state = B"010") then--Запись конфигурационных данных
        if (used_words > 0) then
          rdreq_output <= '1';
          data_s <= q_output;
          WB_Addr <= Addr_write;
          WB_DataOut <= data_s;
          WB_WE <= '1';--Сигнал разрешения записи
          if (byte_left = 1) then
            WB_Sel <= B"10";--Select
          else
            WB_Sel <= B"11";
          end if;
          WB_STB <= '1';--корректность
          WB_CTI <= B"000";
          byte_left <= byte_left - 2;
        end if;

      elsif (cmd_state = B"011") then ---- Чтение данных из порта ввода/вывода (FIFO)
        if (current_state = header_write) then
          if (header_word_left = B"11") then
            wrreq_input <= '1';
            data_s(2 downto 0) <= Cmd;
            data_s(3) <= FB;
            data_s(5 downto 4) <= R1;
            data_s(15 downto 6) <= BCount;
            data_input <= data_s;

          elsif (header_word_left = B"10") then
            wrreq_input <= '1';
            data_s(9 downto 0) <= TID;
            data_s(10 downto 8) <= AddrValid;
            data_s(15 downto 11) <= R2;
            data_input <= data_s;
          elsif (header_word_left = B"01") then
            wrreq_input <= '1';
            data_input <= Addr;
          end if;
          header_word_left <= header_word_left - B"01";
        end if;
      elsif (current_state = data_edit) then
        WB_WE <= '0';
        if (WB_Ack = '1') then
          data_s <= WB_DataIn_0;
          data_input <= data_s;
          byte_left <= byte_left - 2;
        end if;

      elsif (cmd_state = B"100") then--Запись данных в порт ввода/вывода (FIFO)
        if (used_words > 0) then
          rdreq_output <= '1';
          data_s <= q_output;
          WB_Addr <= Addr_write;
          WB_DataOut <= data_s;
          WB_WE <= '1';--Сигнал разрешения записи
          if (byte_left = 1) then
            WB_Sel <= B"10";--Select
          else
            WB_Sel <= B"11";
          end if;
          WB_STB <= '1';--корректность
          WB_CTI <= B"000";
          byte_left <= byte_left - 2;
        end if;

      elsif (cmd_state = B"101") then-- Чтение данных из памяти
        if (current_state = header_write) then
          if (header_word_left = B"11") then
            wrreq_input <= '1';
            data_s(2 downto 0) <= Cmd;
            data_s(3) <= FB;
            data_s(5 downto 4) <= R1;
            data_s(15 downto 6) <= BCount;
            data_input <= data_s;

          elsif (header_word_left = B"10") then
            wrreq_input <= '1';
            data_s(9 downto 0) <= TID;
            data_s(10 downto 8) <= AddrValid;
            data_s(15 downto 11) <= R2;
            data_input <= data_s;
          elsif (header_word_left = B"01") then
            wrreq_input <= '1';
            data_input <= Addr;
          end if;
          header_word_left <= header_word_left - B"01";
        end if;
      elsif (current_state = data_edit) then
        WB_WE <= '0';
        if (WB_Ack = '1') then
          data_s <= WB_DataIn_0;
          data_input <= data_s;
          byte_left <= byte_left - 2;
        end if;

      elsif (cmd_state = B"110") then--Запись данных в память
        if (used_words > 0) then
          rdreq_output <= '1';
          data_s <= q_output;
          WB_Addr <= Addr_write;
          WB_DataOut <= data_s;
          WB_WE <= '1';--Сигнал разрешения записи
          if (byte_left = 1) then
            WB_Sel <= B"10";--Select
          else
            WB_Sel <= B"11";
          end if;
          WB_STB <= '1';--корректность
          WB_CTI <= B"000";
          byte_left <= byte_left - 2;
        end if;
      end if;
    end if;
    end process;
  end architecture;