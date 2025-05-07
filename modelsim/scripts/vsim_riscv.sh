touch work-obj08.cf
rm work-obj08.cf

vlib work
vmap work work

vcom -quiet  -93  -work work ../src/tools/strings_h.vhdl
vcom -quiet  -93  -work work ../src/tools/regexp_h.vhdl
vcom -quiet  -93  -work work ../src/tools/ctype_h.vhdl
vcom -quiet  -93  -work work ../src/tools/stdlib_h.vhdl
vcom -quiet  -93  -work work ../src/tools/stdio_h.vhdl

vcom -quiet  -93  -work work ../src/riscv_types.vhd
vcom -quiet  -93  -work work ../src/riscv.vhd
vcom -quiet  -93  -work work ../src/riscv_soc.vhd
vcom -quiet  -93  -work work ../testbench/riscv_soc_tb.vhd
vcom -quiet  -93  -work work ../src/observer.vhd

vcom -quiet  -93  -work work ../src/mem_rom.vhd
vcom -quiet  -93  -work work ../src/mem_ram.vhd
vcom -quiet  -93  -work work ../src/alu.vhd
vcom -quiet  -93  -work work ../src/decoder.vhd
vcom -quiet  -93  -work work ../src/registers.vhd
vcom -quiet  -93  -work work ../src/immediate.vhd
vcom -quiet  -93  -work work ../src/mem_store.vhd
vcom -quiet  -93  -work work ../src/mem_load.vhd

vcom -quiet  -93  -work work ../src/cnt_cycles.vhd
vcom -quiet  -93  -work work ../src/cnt_instr.vhd
vcom -quiet  -93  -work work ../src/csr_registers.vhd

vcom -quiet  -93  -work work ../src/fetch.vhd

vcom -quiet  -2008  -work work ../src/uart_recv.vhd
vcom -quiet  -2008  -work work ../src/uart_send.vhd

vcom -quiet  -93  -work work ../testbench/riscv_soc_tb.vhd

vsim riscv_soc_tb -c -quiet -do "set NumericStdNoWarnings 1; run 1000ms; exit"