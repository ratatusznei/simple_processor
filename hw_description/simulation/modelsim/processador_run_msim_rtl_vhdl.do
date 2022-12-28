transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/op/Aulas/digital-systems/final_project/hw_description/seg7.vhd}
vcom -93 -work work {/home/op/Aulas/digital-systems/final_project/hw_description/proc_types.vhd}
vcom -93 -work work {/home/op/Aulas/digital-systems/final_project/hw_description/megaram.vhd}
vcom -93 -work work {/home/op/Aulas/digital-systems/final_project/hw_description/ram.vhd}
vcom -93 -work work {/home/op/Aulas/digital-systems/final_project/hw_description/control_unit.vhd}
vcom -93 -work work {/home/op/Aulas/digital-systems/final_project/hw_description/ula.vhd}
vcom -93 -work work {/home/op/Aulas/digital-systems/final_project/hw_description/register_file.vhd}
vcom -93 -work work {/home/op/Aulas/digital-systems/final_project/hw_description/toplevel.vhd}

