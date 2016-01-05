transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/lab2_121220307_MIPS8 {F:/lab2_121220307_MIPS8/lab2_121220307_MIPS8.v}

vlog -vlog01compat -work work +incdir+F:/lab2_121220307_MIPS8/simulation/modelsim {F:/lab2_121220307_MIPS8/simulation/modelsim/lab2_121220307_MIPS8.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  lab2_121220307_MIPS8_vlg_tst

add wave *
view structure
view signals
run -all
