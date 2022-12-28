library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.proc_types.all;

-- ULA de quatro operacoes, SOMA, NE, LESS e ZERO

entity ula is
	port(
		a, b: in word := x"00";
		op: in ula_op := SOMA;
		y: out word := x"00"
	);
end entity;

architecture comb of ula is
	signal sum, ne_res, lt: word;
begin
	sum <= std_logic_vector(unsigned(a) + unsigned(b));
	ne_res <= not(a and b);
	lt <= x"FF" when unsigned(a) < unsigned(b) else x"00";

	y <= sum when op = SOMA else
		  ne_res when op = NE else
		  lt when op = LESS else
		  x"00" when op = ZERO;
end architecture;
