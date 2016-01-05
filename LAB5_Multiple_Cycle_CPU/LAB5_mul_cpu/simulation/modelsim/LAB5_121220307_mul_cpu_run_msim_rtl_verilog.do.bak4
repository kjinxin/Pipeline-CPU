transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/LAB5_121220307_mul_cpu {F:/LAB5_121220307_mul_cpu/LAB5_121220307_mul_cpu.v}

vlog -vlog01compat -work work +incdir+F:/LAB5_121220307_mul_cpu/simulation/modelsim {F:/LAB5_121220307_mul_cpu/simulation/modelsim/LAB5_121220307_mul_cpu.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  LAB5_121220307_mul_cpu_vlg_tst

add wave *
view structure
view signals
run -all
