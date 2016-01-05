transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {lab1_121220307_MIPS32_7_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+F:/lab1_121220307_MIPS32/simulation/modelsim {F:/lab1_121220307_MIPS32/simulation/modelsim/lab1_121220307_MIPS32.vt}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  lab1_121220307_MIPS32_vlg_tst

add wave *
view structure
view signals
run -all
