library ieee;
use ieee.std_logic_1164.all;

entity seg7 is
port(
	hex: in std_logic_vector(3 downto 0);
	segs: out std_logic_vector(6 downto 0)
);
end;

architecture anode_common of seg7 is
begin
	process(hex)
	begin
		case hex is           -- "gfedcba"
			when x"0" => segs <= "1000000";
			when x"1" => segs <= "1111001";
			when x"2" => segs <= "0100100";
			when x"3" => segs <= "0110000";
			when x"4" => segs <= "0011001";
			when x"5" => segs <= "0010010";
			when x"6" => segs <= "0000010";
			when x"7" => segs <= "1111000";
			when x"8" => segs <= "0000000";
			when x"9" => segs <= "0010000";
			when x"a" => segs <= "0001000";
			when x"b" => segs <= "0000011";
			when x"c" => segs <= "1000110";
			when x"d" => segs <= "0100001";
			when x"e" => segs <= "0000110";
			when x"f" => segs <= "0001110";
			when others => segs <= "-------";
		end case;
	end process;
end;
