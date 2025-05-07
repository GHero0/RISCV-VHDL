touch work-obj08.cf
rm work-obj08.cf

vlib work
vmap work work

vcom -quiet  -93  -work work ../src/riscv_types.vhd

vcom -quiet  -93  -work work ../src/mem_load.vhd

vcom -quiet  -93  -work work ../testbench/mem_load_tb.vhd

vsim mem_load_tb -c -quiet -do "set NumericStdNoWarnings 1; run 1000ms; exit"