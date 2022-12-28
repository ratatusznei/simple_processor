library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.proc_types.all;

-- Memoria RAM
-- Uma porta de leitura, rd
-- Uma porta de escrita, wd
-- O enderecamento eh sincrono
-- Sinais para chaves e displays na placa, sw e dispX

entity ram is
	port(
		disp0, disp1, disp2, 
		disp3, disp4, disp5: out std_logic_vector(3 downto 0):= x"0";
		sw: in word := x"00"; 
		addr: in word := x"00";
		clk: std_logic := '1';
		we: std_logic := '0';
		wd: in word := x"00";
		rd: out word := x"00"
	);
end;

architecture arch of ram is
	signal mega_q: word;
	signal rd_from_sw: std_logic := '0';
	signal clock_not: std_logic;
begin
	clock_not <= not(clk);
	rd <= sw when rd_from_sw = '1' else mega_q;

	-- processo para escrita e leitura de enderecos especiais
	process(clk) is
	begin
		if falling_edge(clk) then
			if addr = x"FF" then
				rd_from_sw <= '1';
			else
				rd_from_sw <= '0';
			end if;
		
			if we = '1' then
				if addr = x"02" then
					disp0 <= wd(3 downto 0);
					disp1 <= wd(7 downto 4);
				elsif addr = x"03" then
					disp2 <= wd(3 downto 0);
					disp3 <= wd(7 downto 4);
				elsif addr = x"04" then
					disp4 <= wd(3 downto 0);
					disp5 <= wd(7 downto 4);
				end if;
			end if;
		end if;
	end process;
	
	-- megaram eh a ram do catalogo de IP do quartus
	mega0: entity work.megaram
	port map (
		address => addr,
		clock => clock_not,
		data => wd,
		wren => we,
		q => mega_q
	);
end;
