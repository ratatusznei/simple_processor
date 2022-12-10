library ieee;
use ieee.std_logic_1164.all;

-- Tipo utilizados no projeto
package proc_types is
	type ula_op is (SOMA, NE, LESS, ZERO);
	
	subtype word is std_logic_vector(7 downto 0);
	type reg_array is array(0 to 3) of word;

	type control_state is (
		state_fetch,
		state_fetch_wait,
		state_decode,
		
		state_mem_addr,
		state_mem_read,
		state_mem_read_wait,
		state_mem_write,
		state_mem_write_wait,
		state_mem_wb,

		state_execute_imm,
		state_execute_ula,
		state_ula_wb,

		state_branch_zero,
		state_branch_zero_wait
	);

	type address_src_type is (
		address_from_pc,
		address_from_result_reg
	);
	
	type result_src_type is (
		result_from_ula_y,
		result_from_ula_reg,
		result_from_read_data_reg
	);

	type ula_src_a_type is (
		src_a_from_pc, 
		src_a_from_old_pc,
		src_a_from_rda_reg, 
		src_a_from_0
	);
	
	type ula_src_b_type is (
		src_b_from_rdb_reg,
		src_b_from_imm, 
		src_b_from_1,
		src_b_from_0
	);
end;
