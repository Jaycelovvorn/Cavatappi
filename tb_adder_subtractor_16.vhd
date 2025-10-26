library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- only for printing/verification in testbench

entity tb_adder_subtractor_16 is
end entity tb_adder_subtractor_16;

architecture tb of tb_adder_subtractor_16 is
  signal A_s     : std_logic_vector(15 downto 0) := (others => '0');
  signal B_s     : std_logic_vector(15 downto 0) := (others => '0');
  signal SUB_s   : std_logic := '0';
  signal Result_s: std_logic_vector(15 downto 0);
  signal CarryOut: std_logic;
  signal Overflow: std_logic;
  signal Zero    : std_logic;

  constant clk_period : time := 100 ns;
begin
  uut: entity work.adder_subtractor_16
    port map(
      A => A_s,
      B => B_s,
      SUB => SUB_s,
      Result => Result_s,
      CarryOut => CarryOut,
      Overflow => Overflow,
      Zero => Zero
    );

  stim_proc: process
    variable iA : integer;
    variable iB : integer;
    variable iR : integer;
  begin
    -- Test 1: simple add 0 + 0
    A_s <= (others => '0'); B_s <= (others => '0'); SUB_s <= '0';
    wait for clk_period/4;
    report "Test: 0 + 0 -> Result=" & integer'image(to_integer(unsigned(Result_s))) &
           " CarryOut=" & std_logic'image(CarryOut) & " Overflow=" & std_logic'image(Overflow);

    -- Test 2: 1 + 1
    A_s <= std_logic_vector(to_unsigned(1,16)); B_s <= std_logic_vector(to_unsigned(1,16)); SUB_s <= '0';
    wait for clk_period/4;
    report "Test: 1 + 1 -> Result=" & integer'image(to_integer(unsigned(Result_s))) &
           " CarryOut=" & std_logic'image(CarryOut) & " Overflow=" & std_logic'image(Overflow);

    -- Test 3: max + 1 (overflow)
    A_s <= (others => '1'); B_s <= std_logic_vector(to_unsigned(1,16)); SUB_s <= '0';
    wait for clk_period/4;
    report "Test: 65535 + 1 -> Result=" & integer'image(to_integer(unsigned(Result_s))) &
           " CarryOut=" & std_logic'image(CarryOut) & " Overflow=" & std_logic'image(Overflow);

    -- Test 4: 5 - 3
    A_s <= std_logic_vector(to_unsigned(5,16)); B_s <= std_logic_vector(to_unsigned(3,16)); SUB_s <= '1';
    wait for clk_period/4;
    report "Test: 5 - 3 -> Result=" & integer'image(to_integer(unsigned(Result_s))) &
           " CarryOut=" & std_logic'image(CarryOut) & " Overflow=" & std_logic'image(Overflow);

    -- Test 5: 0 - 1 (underflow / negative in two's complement)
    A_s <= std_logic_vector(to_unsigned(0,16)); B_s <= std_logic_vector(to_unsigned(1,16)); SUB_s <= '1';
    wait for clk_period/4;
    report "Test: 0 - 1 -> Result=" & integer'image(to_integer(unsigned(Result_s))) &
           " CarryOut=" & std_logic'image(CarryOut) & " Overflow=" & std_logic'image(Overflow);

    -- Test 6: negative overflow edge: -32768 - 1 (two's complement overflow)
    -- -32768 as unsigned is 0x8000 (32768)
    A_s <= std_logic_vector(to_unsigned(32768,16)); B_s <= std_logic_vector(to_unsigned(1,16)); SUB_s <= '1';
    wait for clk_period/4;
    report "Test: -32768 - 1 (two's complement) -> Result=" & integer'image(to_integer(unsigned(Result_s))) &
           " CarryOut=" & std_logic'image(CarryOut) & " Overflow=" & std_logic'image(Overflow);

    -- Exhaustive small sweep (optional quick checks)
    for i in 0 to 7 loop
      A_s <= std_logic_vector(to_unsigned(i,16));
      for j in 0 to 7 loop
        B_s <= std_logic_vector(to_unsigned(j,16)); SUB_s <= '0';
        wait for clk_period/20;
        -- not reporting each to avoid too many lines
      end loop;
    end loop;

    wait for clk_period;
    report "Testbench finished.";
    wait;
  end process stim_proc;
end architecture tb;
