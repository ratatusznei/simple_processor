library ieee;
use ieee.std_logic_1164.all;

entity seg7 is
port(
	hex: in std_ulogic_vector(3 downto 0);
	segs: out std_ulogic_vector(0 to 6)
);
end;

architecture anode_common of seg7 is
begin
	process(hex)
	begin
		case hex is             -- "abcdefg"
			when "0000" => segs <= "0000001";
			when "0001" => segs <= "1001111";
			when "0010" => segs <= "0010010";
			when "0011" => segs <= "0000110";
			when "0100" => segs <= "1001100";
			when "0101" => segs <= "0100100";
			when "0110" => segs <= "0100000";
			when "0111" => segs <= "0001111";
			when "1000" => segs <= "0000000";
			when "1001" => segs <= "0000100";
			when "1010" => segs <= "0001000";
			when "1011" => segs <= "1100000";
			when "1100" => segs <= "0110001";
			when "1101" => segs <= "1000010";
			when "1110" => segs <= "0110000";
			when "1111" => segs <= "0111000";
			when others => segs <= "0000000";
		end case;
	end process;
end;

architecture cathode_common of seg7 is
begin
	process(hex)
	begin
		case hex is             -- "abcdefg"
			when "0000" => segs <= "1111110";
			when "0001" => segs <= "0110000";
			when "0010" => segs <= "1101101";
			when "0011" => segs <= "1111001";
			when "0100" => segs <= "0110011";
			when "0101" => segs <= "1011011";
			when "0110" => segs <= "1011111";
			when "0111" => segs <= "1110000";
			when "1000" => segs <= "1111111";
			when "1001" => segs <= "1111011";
			when "1010" => segs <= "1110111";
			when "1011" => segs <= "0011111";
			when "1100" => segs <= "1001110";
			when "1101" => segs <= "0111101";
			when "1110" => segs <= "1001111";
			when "1111" => segs <= "1000111";
			when others => segs <= "1111111";
		end case;
	end process;
end;
