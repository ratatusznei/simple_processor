onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /toplevel/instr
add wave -noupdate -radix hexadecimal /toplevel/pc
add wave -noupdate /toplevel/state_out_debug
add wave -noupdate /toplevel/mem_write
add wave -noupdate -radix hexadecimal /toplevel/rdb
add wave -noupdate -radix hexadecimal /toplevel/result
add wave -noupdate /toplevel/result_src
add wave -noupdate -radix hexadecimal /toplevel/read_data
add wave -noupdate -radix hexadecimal /toplevel/addr
add wave -noupdate -radix hexadecimal /toplevel/read_data_reg
add wave -noupdate -radix hexadecimal /toplevel/ula_a
add wave -noupdate -radix hexadecimal /toplevel/ula_b
add wave -noupdate -radix hexadecimal /toplevel/ula_y
add wave -noupdate /toplevel/reg_write
add wave -noupdate /toplevel/is_zero
add wave -noupdate /toplevel/ula_src_a
add wave -noupdate /toplevel/ula_src_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {33049 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 94
configure wave -valuecolwidth 91
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {36563 ps} {37456 ps}
