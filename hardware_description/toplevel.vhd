library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.proc_types.all;

entity toplevel is
	port(
		MAX10_CLK1_50: in std_logic;
		SW: in std_logic_vector(7 downto 0) := (others => '0');
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(7 downto 0) := (others => 'Z');
		KEY: in std_logic_vector(1 downto 0) := (others => '1')
	);
end entity;

architecture proc of toplevel is
	signal source_50MHz: std_logic;
	signal clk: std_logic := '1';
	signal rst: std_logic := '0';

	signal pc, old_pc: word := x"00"; -- contador de programa
	signal addr: word; -- endereco da ram
	signal result: word; -- sinal para leitura da ram e da ula
	signal ula_a, ula_b, ula_y, ula_reg: word; -- sinais de entrada, saida e saida registrada da ula
	signal instr: word := x"ff"; -- IR, registrador armazenando a instrucao sendo executada
	signal rda, rdb: word; -- sinal para leitura dos registrados
	signal fetch_instr: std_logic; -- sinal que indica leitura da proxima instrucao
	signal read_data, read_data_reg: word; -- sinais de para leitura da ram
	signal is_zero: std_logic; -- utilizado para decidir saltos na intrucao jz

	signal pc_write, mem_write, reg_write: std_logic; -- sinais para habilitacao de escrita
	
	signal result_src: result_src_type;
	signal addr_src: address_src_type;
	signal ula_src_a: ula_src_a_type;
	signal ula_src_b: ula_src_b_type; -- sinais para selecao de multiplexadores
	
	signal ula_control: ula_op; -- controle da operacao sendo realizada na ula
	
	signal disp_hex0, disp_hex1, disp_hex2, -- controle dos displays da placa, formato HEX
			 disp_hex3, disp_hex4, disp_hex5: std_logic_vector(3 downto 0);
			 
	signal state_out_debug: control_state; -- sinal para debug pelo modelsim
begin
	-- Divisor de clock
	source_50MHz <= MAX10_CLK1_50;
	process (source_50MHz) is
		variable counter: natural := 0;
		constant modulo: natural := 50_000_000/(2 * 50_000);
	begin
		if falling_edge(source_50Mhz) then
			if counter = modulo then
				counter := 0;
				clk <= not(clk);
			else
				counter := counter + 1;
			end if;
		end if;
	end process;
	
-- Clock para simulacao pelo modelsim
--	process is
--	begin
--		clk <= '1';
--		wait for 0.05 ns;
--		clk <= '0';
--		wait for 0.05 ns;
--	end process;

	-- Processos modelando registradores
	process(clk, rst) is
	begin
		if rst = '1' then
			pc <= x"00";
		elsif falling_edge(clk) and pc_write = '1' then
			pc <= result;
		end if;
	end process;
	
	process(clk) is
	begin
		if falling_edge(clk) and fetch_instr = '1' then
			old_pc <= pc;
			instr <= read_data;
		end if;
	end process;
	
	process(clk) is
	begin
		if falling_edge(clk) then
			ula_reg <= ula_y;
		end if;
	end process;
	
	process(clk) is
	begin
		if falling_edge(clk) then
			read_data_reg <= read_data;
		end if;
	end process;
	
	-- Multiplexadores
	with addr_src select addr <=
		pc when address_from_pc,
	   result when address_from_result_reg;

	with ula_src_a select ula_a <=
		pc when src_a_from_pc,
		old_pc when src_a_from_old_pc,
		rda when src_a_from_rda_reg,
		x"00" when src_a_from_0;
	
	with ula_src_b select ula_b <=
		rdb when src_b_from_rdb_reg,
		(x"0" & instr(5 downto 4) & instr(1 downto 0)) when src_b_from_imm,
		x"01" when src_b_from_1, -- constante 1 utilizada para incrementar o pc
		x"00" when src_b_from_0;
		
	with result_src select result <=
		ula_y when result_from_ula_y,
		ula_reg when result_from_ula_reg,
		read_data_reg when result_from_read_data_reg;
	
	-- Sinal para decisao de saltos jz
	-- e reset do programa (seta pc = 0 e limpa os registradores, mantem os dados da ram)
	is_zero <= '1' when ula_y = x"00" else '0';
	rst <= not(KEY(0) and KEY(1));
	
	-- Conversores para displays
	disp0: entity work.seg7 
	port map(hex => disp_hex0, segs => HEX0(6 downto 0));
	disp1: entity work.seg7 
	port map(hex => disp_hex1, segs => HEX1(6 downto 0));
	disp2: entity work.seg7 
	port map(hex => disp_hex2, segs => HEX2(6 downto 0));
	disp3: entity work.seg7 
	port map(hex => disp_hex3, segs => HEX3(6 downto 0));
	disp4: entity work.seg7 
	port map(hex => disp_hex4, segs => HEX4(6 downto 0));
	disp5: entity work.seg7 
	port map(hex => disp_hex5, segs => HEX5(6 downto 0));
	
	-- unidade de controle
	control0: entity work.control_unit
	port map(
		state_out_debug => state_out_debug,
		clk => clk,
		rst => rst,
		instr => instr, 
		is_zero => is_zero,
		fetch_instr => fetch_instr,
		pc_write => pc_write,
		mem_write => mem_write,
		reg_write => reg_write,
		result_src => result_src,
		address_src => addr_src,
		ula_src_a => ula_src_a,
		ula_src_b => ula_src_b,
		ula_control => ula_control
	);

	-- memoria ram
	ram0: entity work.ram
	port map(
		disp0 => disp_hex0,
		disp1 => disp_hex1,
		disp2 => disp_hex2,
		disp3 => disp_hex3,
		disp4 => disp_hex4,
		disp5 => disp_hex5,
		sw => SW(7 downto 0),
		addr => addr,
		clk => clk,
		we => mem_write,
		wd => rdb,
		rd => read_data
	);
	
	-- ula
	ula0: entity work.ula
	port map(
		a => ula_a,
		b => ula_b,
		op => ula_control,
		y => ula_y
	);

	-- arquivo de registradores, a0 e a1 sao enderecamentos para leitura
	-- a2 eh enderecamento para escrita
	regfile0: entity work.register_file
	port map(
		a0 => instr(3 downto 2),
		a1 => instr(1 downto 0),
		a2 => instr(3 downto 2),
		clk => clk,
		wen => reg_write,
		rst => rst,
		wd0 => result,
		rd0 => rda,
		rd1 => rdb
	);
end architecture;