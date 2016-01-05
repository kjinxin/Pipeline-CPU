transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/LAB4_121220307_single_cpu {F:/LAB4_121220307_single_cpu/single_cpu.v}

vlog -vlog01compat -work work +incdir+F:/LAB4_121220307_single_cpu/simulation/modelsim {F:/LAB4_121220307_single_cpu/simulation/modelsim/single_cpu.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  single_cpu_vlg_tst

add wave *
view structure
view signals
run -all
