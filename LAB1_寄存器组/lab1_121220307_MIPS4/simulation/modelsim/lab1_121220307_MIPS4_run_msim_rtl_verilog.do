transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/lab1_121220307_MIPS4 {F:/lab1_121220307_MIPS4/lab1_121220307_MIPS4.v}

vlog -vlog01compat -work work +incdir+F:/lab1_121220307_MIPS4/simulation/modelsim {F:/lab1_121220307_MIPS4/simulation/modelsim/lab1_121220307_MIPS4.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  lab1_121220307_MIPS4_vlg_tst

add wave *
view structure
view signals
run -all
