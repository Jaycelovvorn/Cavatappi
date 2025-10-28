library ieee;
use ieee.std_logic_1164.all;

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
  signal Bx : std_logic_vector(15 downto 0);


  signal c : std_logic_vector(0 to 16);
begin
  
  Bx <= B xor ( (15 downto 0 => SUB) );


  c(0) <= SUB;


  gen_bits: for i in 0 to 15 generate
  begin

    Result(i) <= A(i) xor Bx(i) xor c(i);


    c(i+1) <= (A(i) and Bx(i)) or (Bx(i) and c(i)) or (A(i) and c(i));
  end generate gen_bits;

  CarryOut <= c(16);


  Overflow <= c(15) xor c(16);


  Zero <= '1' when Result = (others => '0') else '0';
end architecture rtl;

