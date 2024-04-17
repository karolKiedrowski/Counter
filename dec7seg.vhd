library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity dec7seg is 
    Port ( bcd : in std_logic_vector(3 downto 0);
           seg : out std_logic_vector(6 downto 0) );
end entity dec7seg;

architecture ttable of dec7seg is
begin
    with bcd select
    seg <= "1111001" when x"1",
           "0100100" when x"2",
           "0110000" when x"3",
           "0011001" when x"4",
           "0010010" when x"5",
           "0000010" when x"6",
           "1111000" when x"7",
           "0000000" when x"8",
           "0010000" when x"9",
           "1000000" when x"0",
           "0001000" when x"A",
           "0000000" when x"B",
           "1000110" when x"C",
           "1000000" when x"D",
           "0000110" when x"E",
           "0001110" when x"F",
           "0111111" when others;
end architecture ttable;