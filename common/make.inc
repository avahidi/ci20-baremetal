# -*- Makefile -*-
#
# makefile skeleton
#

DEVICE ?= /dev/ttyUSB0


#CROSS_COMPILE ?= mips-sde-elf-
#CROSS_COMPILE ?= mips-linux-gnu-
CROSS_COMPILE ?= mipsel-linux-gnu-


OUT = build/$(NAME)
DIR += src src/cpu
LDS ?= src/memory.ld


SRC += $(foreach d,$(DIR),$(wildcard $(d)/*.c))
SRC += $(foreach d,$(DIR),$(wildcard $(d)/*.S))

# tell GCC this is bare-metal little-endian code
CFLAGS += -mel
CFLAGS += -nostartfiles -nostdlib -fno-builtin
CFLAGS += -Os -G0
CFLAGS += $(foreach d,$(DIR),-I$(d)$)


#

# who needs intelligent building? always build, just do it...
all: build $(SRC) $(LDS) Makefile
# 1. compile source code
	$(CROSS_COMPILE)gcc $(CFLAGS) $(SRC) -T $(LDS) -o $(OUT).elf
# 2. dissambly
	@$(CROSS_COMPILE)objdump -x -r -t -d $(OUT).elf > $(OUT).dis
# 3. create firmware files
	@$(CROSS_COMPILE)objcopy -O binary $(OUT).elf $(OUT).bin
	@mkimage -A mips -O linux -T kernel -a 0x00000000 -C none -d $(OUT).bin $(OUT).img
	@hexdump $(OUT).bin > $(OUT).hex
# 4. s-record is always nice to have
	@$(CROSS_COMPILE)objcopy -O srec -S $(OUT).elf $(OUT).BIG.srec
# 5. a really ugly hack to remove empty lines :(
	@grep -v 000000000000000000000000000000000.. < $(OUT).BIG.srec > $(OUT).srec

$(LDS):
	@echo $(LDS) not found. where is your linker script??
	@exit 20

# show dissembly
show: all
	@less $(OUT).dis

# optional QEMU stuff, doesn't work on ci20
qemu:
	-reset # QEMU-tmux workaround
	# code loaded as bios, GDB will re-load it to correct location later
	@qemu-system-mipsel -M mips -bios $(OUT).bin -s -S -nographic

gdb:
	# loading the ELF again since QEMU-MIPSEL assumes bios is big-endian :(
	@$(CROSS_COMPILE)gdb $(OUT).elf -ex 'target remote :1234' -ex 'load $(OUT).elf' -ex 'disp/i $$pc'
	killall qemu-system-mipsel



# talk to the board...
console:
	minicom -b 115200 -D $(DEVICE)

#

build:
	mkdir build

clean:
	rm -rf build
