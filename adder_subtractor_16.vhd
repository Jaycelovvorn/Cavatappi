library ieee;
use ieee.std_logic_1164.all;

-- 16-bit adder/subtractor using only logic gates (XOR, AND, OR, NOT)
-- SUB = '0' -> add (A + B)
-- SUB = '1' -> subtract (A - B) implemented as A + (not B) + 1 (two's complement)
entity adder_subtractor_16 is
  port(
    A       : in  std_logic_vector(15 downto 0);
    B       : in  std_logic_vector(15 downto 0);
    SUB     : in  std_logic; -- '0' = add, '1' = subtract
    Result  : out std_logic_vector(15 downto 0);
    CarryOut: out std_logic;
    Overflow: out std_logic;
    Zero    : out std_logic
  );
end entity adder_subtractor_16;

architecture rtl of adder_subtractor_16 is
  -- Bx is either B (when SUB='0') or bitwise NOT B (when SUB='1')
  signal Bx : std_logic_vector(15 downto 0);

  -- c(i) is carry into bit i. c(0) = SUB (if subtract we add initial carry 1)
  signal c : std_logic_vector(0 to 16);
begin
  -- conditional invert of B using only XOR with a vector of SUB bits
  Bx <= B xor ( (15 downto 0 => SUB) );

  -- initial carry in: if SUB='1' then carry-in = '1' (for two's complement)
  c(0) <= SUB;

  -- ripple-carry full adder implemented with logic gates per bit
  gen_bits: for i in 0 to 15 generate
  begin
    -- Sum = A xor Bx xor Cin
    Result(i) <= A(i) xor Bx(i) xor c(i);

    -- Cout = (A and Bx) or (Bx and Cin) or (A and Cin)
    c(i+1) <= (A(i) and Bx(i)) or (Bx(i) and c(i)) or (A(i) and c(i));
  end generate gen_bits;

  CarryOut <= c(16);

  -- For two's complement overflow, XOR of carry into MSB and carry out of MSB
  Overflow <= c(15) xor c(16);

  -- Zero flag: high when result is all zeros
  Zero <= '1' when Result = (others => '0') else '0';
end architecture rtl;
