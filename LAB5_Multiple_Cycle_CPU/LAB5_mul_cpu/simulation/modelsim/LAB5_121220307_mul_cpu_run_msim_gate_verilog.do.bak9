transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {LAB5_121220307_mul_cpu_7_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+F:/LAB5_121220307_mul_cpu/simulation/modelsim {F:/LAB5_121220307_mul_cpu/simulation/modelsim/LAB5_121220307_mul_cpu.vt}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  LAB5_121220307_mul_cpu_vlg_tst

add wave *
view structure
view signals
run -all
