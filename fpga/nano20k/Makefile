
all: bitstream

analysis:
	@echo "Analyse des codes RTL (ghdl)..."
	find . -name "work-obj08.*" -delete
	ghdl -a --std=08 -fsynopsys ../src/riscv/riscv_types.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/riscv_config_20k.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/alu/alu.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/rom/mem_rom_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/ram/mem_ram_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/alu/alu_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/decode/decoder_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/regs/registers_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/imm/immediate_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/store/mem_store_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/load/mem_load_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/csr/csr_registers_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/fetch/fetch_pkg.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/rom/mem_rom.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/ram/mem_ram.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/alu/alu.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/decode/decoder.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/regs/registers.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/imm/immediate.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/store/mem_store.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/load/mem_load.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/csr/cnt_cycles.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/csr/cnt_instr.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/csr/csr_registers.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/fetch/fetch.vhd
	ghdl -a --std=08 -fsynopsys ../src/IPs/uart_nano20k/uart_recv.vhd
	ghdl -a --std=08 -fsynopsys ../src/IPs/uart_nano20k/uart_send.vhd
#	ghdl -a --std=08 -fsynopsys ../src/IPs/uart/uart_recv.vhd
#	ghdl -a --std=08 -fsynopsys ../src/IPs/uart/uart_send.vhd
	ghdl -a --std=08 -fsynopsys ../src/IPs/oled_rgb/pmodoledrgb_bitmap.vhd
	ghdl -a --std=08 -fsynopsys ../src/IPs/led_rgb/pwm_module.vhd
	ghdl -a --std=08 -fsynopsys ../src/IPs/led_rgb/led_rgb_ctrl.vhd
	ghdl -a --std=08 -fsynopsys ../src/IPs/timer/cycle_cnt.vhd
	ghdl -a --std=08 -fsynopsys ../src/IPs/timer/prog_cnt.vhd
	ghdl -a --std=08 -fsynopsys ../src/IPs/timer/timer_ctrl.vhd
	ghdl -a --std=08 -fsynopsys ../src/riscv/riscv_no_mem.vhd
	ghdl -a --std=08 -fsynopsys ../src/IPs/clock/fake/clk_wiz_0.vhd
	ghdl -a --std=08 -fsynopsys ../src/soc/riscv_soc_20k.vhd

#
# Synthese logique du design
#
synthesis: analysis
	@echo "Logical syntesis (yosys)..."
	yosys -m ghdl -p 'ghdl --std=08 -fsynopsys riscv_soc_20k; delete t:$$assert; synth_gowin -json ./top.json'
#	yosys -m ghdl -p 'ghdl --std=08 -fsynopsys riscv_soc_20k; delete t:$aassert; synth_gowin -json ./top.json'
	@find . -name "*.o" -delete


# yosys -m ghdl 
# > ghdl --std=08 -fsynopsys riscv_soc_20k
# > delete t:$assert
# > synth_gowin -json ./yosys/top.json

#
# Placement et routage du design
#
par: synthesis
	@echo "[START] Place and Route (nextpnr)..."
	nextpnr-himbaechel 	\
			--json  ./top.json \
            --write ./pnr.json             \
        	--device GW2AR-LV18QN88C8/I7   \
           	--vopt   family=GW2A-18C       \
			--top    riscv_soc_20k         \
			--freq   27                    \
       		--vopt   cst=./nano20k/tangnano20k.cst  \
			--pre-pack ./nano20k/tangnano20k.py
	@echo "[STOP] Place and Route (nextpnr)..."
	find . -name "top.json" -delete

#
# Generation du bitstream
#
bitstream: par
	@echo "Generation du bitstream (gowin_pack)..."
	gowin_pack -d GW2A-18C -o ./pack.fs ./pnr.json
	find . -name "pnr.json" -delete

#
# Chargement du circuit
#
load_fpga:
	openFPGALoader -b tangnano20k ./pack.fs

clean:
	@echo "Cleaning the project"
	@find . -name "*.v"    -delete
	@find . -name "*.json" -delete
	@find . -name "*.fs"   -delete
	@find . -name "*.o"    -delete
