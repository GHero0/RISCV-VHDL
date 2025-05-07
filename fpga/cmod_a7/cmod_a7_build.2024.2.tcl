# You can then run your build script in the same shell:
# 
# > vivado -mode batch -source build.tcl
# 
# If you’d rather Vivado not generate a journal and log files:
# 
# > vivado -mode batch -nolog -nojournal -source build.tcl
# 
# 
# build settings
# 
set design_name "riscv_soc"
set arch "xc7"
set board_name "arty"
set fpga_part "xc7a35tcpg236-1"

# set reference directories for source files
set lib_dir [file normalize "./../../../../lib"]
set origin_dir [file normalize "./../../"]

# read design sources
read_vhdl -vhdl2008 ../src/riscv/riscv_types.vhd
read_vhdl -vhdl2008 ../src/riscv/riscv_config.vhd

read_vhdl -vhdl2008 ../src/riscv/rom/mem_rom_pkg.vhd
read_vhdl -vhdl2008 ../src/riscv/ram/mem_ram_pkg.vhd
read_vhdl -vhdl2008 ../src/riscv/alu/alu_pkg.vhd
read_vhdl -vhdl2008 ../src/riscv/decode/decoder_pkg.vhd
read_vhdl -vhdl2008 ../src/riscv/regs/registers_pkg.vhd
read_vhdl -vhdl2008 ../src/riscv/imm/immediate_pkg.vhd
read_vhdl -vhdl2008 ../src/riscv/store/mem_store_pkg.vhd
read_vhdl -vhdl2008 ../src/riscv/load/mem_load_pkg.vhd
read_vhdl -vhdl2008 ../src/riscv/csr/csr_registers_pkg.vhd
read_vhdl -vhdl2008 ../src/riscv/fetch/fetch_pkg.vhd

read_vhdl -vhdl2008 ../src/riscv/rom/mem_rom.vhd
read_vhdl -vhdl2008 ../src/riscv/ram/mem_ram.vhd
read_vhdl -vhdl2008 ../src/riscv/alu/alu.vhd
read_vhdl -vhdl2008 ../src/riscv/decode/decoder.vhd
read_vhdl -vhdl2008 ../src/riscv/regs/registers.vhd
read_vhdl -vhdl2008 ../src/riscv/imm/immediate.vhd
read_vhdl -vhdl2008 ../src/riscv/store/mem_store.vhd
read_vhdl -vhdl2008 ../src/riscv/load/mem_load.vhd
read_vhdl -vhdl2008 ../src/riscv/csr/cnt_cycles.vhd
read_vhdl -vhdl2008 ../src/riscv/csr/cnt_instr.vhd
read_vhdl -vhdl2008 ../src/riscv/csr/csr_registers.vhd
read_vhdl -vhdl2008 ../src/riscv/fetch/fetch.vhd

read_vhdl -vhdl2008 ../src/IPs/uart/uart_recv.vhd
read_vhdl -vhdl2008 ../src/IPs/uart/uart_send.vhd

read_vhdl -vhdl2008 ../src/IPs/oled_rgb/pmodoledrgb_bitmap.vhd
read_vhdl -vhdl2008 ../src/IPs/led_rgb/pwm_module.vhd
read_vhdl -vhdl2008 ../src/IPs/led_rgb/led_rgb_ctrl.vhd

read_vhdl -vhdl2008 ../src/IPs/timer/cycle_cnt.vhd
read_vhdl -vhdl2008 ../src/IPs/timer/prog_cnt.vhd
read_vhdl -vhdl2008 ../src/IPs/timer/timer_ctrl.vhd

read_vhdl -vhdl2008 ../src/riscv/riscv.vhd
read_vhdl -vhdl2008 ../src/soc/riscv_soc.vhd

#remove_files
set_part ${fpga_part} 
#import_ip ./xilinx_IPs/cmod_a7/2024.2/clk_wiz_0.xci -name clk_wiz_0  -quiet
#generate_target {instantiation_template synthesis} [get_ips]
#create_ip_run [get_ips]
#synth_ip [get_ips]

read_ip ./cmod_a7/ips/2024.2/clk_wiz_0.xci -quiet
generate_target all [get_ips ip_name]
synth_ip [get_ips ip_name]


# read constraints
#read_xdc "${origin_dir}/${arch}/${board_name}.xdc"
read_xdc "./cmod_a7/xdc/Cmod-A7-Master.xdc"

# synth
#synth_design -top "top_${design_name}" -part ${fpga_part}
synth_design -top "${design_name}" -part ${fpga_part}

# place and route
opt_design
place_design
route_design

# write bitstream
#write_bitstream -force "${origin_dir}/${arch}/${design_name}.bit"
write_bitstream -force "${design_name}.bit"
