library ieee;
use ieee.std_logic_1164.all;
use work.proc_types.all;

entity control_unit is
	port(
		clk: in std_logic := '1';
		rst: in std_logic := '0';
		instr: in word := x"FF";
		is_zero: in std_logic := '0';
		
		fetch_instr: out std_logic := '0';
		pc_write: out std_logic := '0';
		mem_write: out std_logic := '0';
		reg_write: out std_logic := '0';
		
		result_src: out result_src_type := result_from_ula_y;
		address_src: out address_src_type := address_from_pc;
		ula_src_a: out ula_src_a_type := src_a_from_0;
		ula_src_b: out ula_src_b_type := src_b_from_0;
		
		state_out_debug: out control_state;

		ula_control: out ula_op := SOMA
	);
end;

architecture arch of control_unit is
	signal state: control_state := state_fetch;
begin
	state_out_debug <= state;
	
	-- Logica combinacinal para saidas
	with state select pc_write <=
		'1' when state_fetch_wait,
		is_zero when state_branch_zero_wait,
		'0' when others;
	
	with state select reg_write <=
		'1' when state_ula_wb,
		'1' when state_mem_wb,
		'0' when others;
		
	with state select mem_write <=
		'1' when state_mem_write_wait,
		'0' when others;
	
	with state select fetch_instr <=
		'1' when state_fetch_wait,
		'0' when others;
	
	with state select address_src <=
		address_from_pc when state_fetch,
		address_from_result_reg when state_mem_write_wait,
		address_from_result_reg when state_mem_read,
		address_from_result_reg when state_mem_read_wait,
		address_from_pc when others;
		
	with state select result_src <=
		result_from_ula_y when state_fetch,
		result_from_ula_reg when state_ula_wb,
		result_from_ula_reg when state_mem_read,
		result_from_read_data_reg when state_mem_wb,
		result_from_ula_reg when state_mem_write,
		result_from_ula_reg when state_branch_zero_wait,
		result_from_ula_reg when others;

	-- Process para saidas de controle da ula
	process(state) is
	begin
		case state is
			when state_fetch =>
				ula_src_a <= src_a_from_pc;
				ula_src_b <= src_b_from_1;
				ula_control <= SOMA;
			when state_decode =>
				ula_src_a <= src_a_from_0;
				ula_src_b <= src_b_from_rdb_reg;
				ula_control <= SOMA;
			when state_execute_ula =>
				ula_src_a <= src_a_from_rda_reg;
				ula_src_b <= src_b_from_rdb_reg;
				case instr(5 downto 4) is
					when "00" => ula_control <= ZERO;
					when "01" => ula_control <= SOMA;
					when "10" => ula_control <= NE;
					when others => ula_control <= LESS;
				end case;
			when state_execute_imm =>
				ula_src_a <= src_a_from_0;
				ula_src_b <= src_b_from_imm;
				ula_control <= SOMA;
			when state_mem_addr =>
				ula_src_a <= src_a_from_0;
				ula_src_b <= src_b_from_rdb_reg;
				ula_control <= SOMA;
			when state_mem_read =>
				ula_src_a <= src_a_from_0;
				ula_src_b <= src_b_from_rdb_reg;
				ula_control <= SOMA;
			when state_mem_write =>
				ula_src_a <= src_a_from_rda_reg;
				ula_src_b <= src_b_from_0;
				ula_control <= SOMA;
			when state_branch_zero =>
				ula_src_a <= src_a_from_0;
				ula_src_b <= src_b_from_rdb_reg;
				ula_control <= SOMA;
			when state_branch_zero_wait =>
				ula_src_a <= src_a_from_rda_reg;
				ula_src_b <= src_b_from_0;
				ula_control <= SOMA;
			when others =>
				ula_src_a <= src_a_from_0;
				ula_src_b <= src_b_from_0;
				ula_control <= SOMA;
		end case;
	end process;
	
	-- Process para transicoes de estado
	process(clk, rst) is
	begin
		if rst = '1' then
			state <= state_fetch;
		elsif falling_edge(clk) then
			if state = state_fetch then			
				state <= state_fetch_wait;
				
			elsif state = state_fetch_wait then
				state <= state_decode;

			elsif state = state_decode then
				case instr(7 downto 5) is
					when "000"|"001" => state <= state_execute_ula;
					when "010"|"011" => state <= state_mem_addr;
					when "100"|"101" => state <= state_execute_imm;
					when "110" => state <= state_branch_zero;
					when others => state <= state_fetch;
				end case;

			elsif state = state_execute_ula then
				state <= state_ula_wb;
			
			elsif state = state_execute_imm then
				state <= state_ula_wb;
			
			elsif state = state_ula_wb then
				state <= state_fetch;

			elsif state = state_mem_addr then
				case instr(4) is
					when '0' => state <= state_mem_read;
					when '1' => state <= state_mem_write;
					when others => state <= state_fetch;
				end case;

			elsif state = state_mem_read then
				state <= state_mem_read_wait;

			elsif state = state_mem_read_wait then
				state <= state_mem_wb;
			
			elsif state = state_mem_wb then
				state <= state_fetch;

			elsif state = state_mem_write then
				state <= state_mem_write_wait;
				
			elsif state = state_mem_write_wait then
				state <= state_fetch;
				
			elsif state = state_branch_zero then
				state <= state_branch_zero_wait;
				
			elsif state = state_branch_zero_wait then
				state <= state_fetch;
			end if;
		end if;
	end process;
end;
