transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/lab3_121220307_ARM32 {F:/lab3_121220307_ARM32/lab3_121220307_ARM32.v}

vlog -vlog01compat -work work +incdir+F:/lab3_121220307_ARM32/simulation/modelsim {F:/lab3_121220307_ARM32/simulation/modelsim/lab3_121220307_ARM32.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  lab3_121220307_ARM32_vlg_tst

add wave *
view structure
view signals
run -all