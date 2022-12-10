library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.proc_types.all;

entity register_file is
port(
	a0, a1, a2: in std_logic_vector(1 downto 0);
	clk: in std_logic := '1';
	wen: in std_logic := '0';
	rst: in std_logic := '0';
	wd0: in word := x"00";
	rd0, rd1: out word := x"00"
);
end;

architecture arch of register_file is
	signal q0, q1, q2, q3: word := x"00";
begin
	-- Leitura de a0
	with a0 select rd0 <=
		q0 when "00",
		q1 when "01",
		q2 when "10",
		q3 when others;
	
	-- Leitura de a1
	with a1 select rd1 <=
		q0 when "00",
		q1 when "01",
		q2 when "10",
		q3 when others;

	-- Escrita de a2
	process(clk, rst) is
	begin
		if rst = '1' then
				q0 <= x"00";
				q1 <= x"00";
				q2 <= x"00";
				q3 <= x"00";
		elsif falling_edge(clk) then
			if wen = '1' then
				case a2 is
					when "00" => q0 <= wd0;
					when "01" => q1 <= wd0;
					when "10" => q2 <= wd0;
					when others => q3 <= wd0;
				end case;
			end if;
		end if;
	end process;
end;