# -*- Makefile -*-
#
# makefile skeleton
#

TARGET ?=CI20
#CROSS_COMPILE ?= mips-sde-elf-
CROSS_COMPILE = mips-linux-gnu-

# tell GCC this is bare-metal little-endian code
CFLAGS += -mel
CFLAGS += -nostartfiles -nostdlib -fno-builtin
CFLAGS += -Os -G0
CFLAGS += -DTARGET_$(TARGET)=1

OUT = build/$(TARGET)_$(NAME)

DIR += src src/cpu src/board/$(TARGET)

SRC += $(foreach d,$(DIR),$(wildcard $(d)/*.c))
SRC += $(foreach d,$(DIR),$(wildcard $(d)/*.S))
CFLAGS += $(foreach d,$(DIR),-I$(d)$)

# this should work for experiments with single and multiple boards
ifeq (,$(wildcard src/board))
LD = src/memory.ld
else
LD = src/board/$(TARGET)/memory.ld
endif

COMM = minicom -b 115200 -D /dev/ttyUSB0

#

# who needs intelligent building? always build, just do it...
all: build $(SRC) $(LD) Makefile
# 1. compile source code	
	$(CROSS_COMPILE)gcc $(CFLAGS) $(SRC) -T $(LD) -o $(OUT).elf
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

$(LD):
	@echo $(LD) not found. where is your linker script??
	@exit 20
# show dissembly
show: all
	@less $(OUT).dis

# optional QEMU stuff, doesn't work on ci20
qemu: all
ifeq ($(TARGET),CI20)
	@echo "Cannot simulate this target"
	@exit 20
else	
	-reset # QEMU-tmux workaround
	# code loaded as bios, GDB will re-load it to correct location later
	@qemu-system-mipsel -M $(TARGET) -bios $(OUT).bin -s -S -serial stdio -nographic
endif

gdb:
ifeq ($(TARGET),CI20)
	@echo "Cannot debug this target"
	@exit 20
else	
	# loading the ELF again since QEMU-MIPSEL assumes bios is big-endian :(
	@$(CROSS_COMPILE)gdb $(OUT).elf -ex 'target remote :1234' -ex 'load $(OUT).elf' -ex 'disp/i $$pc'
	killall qemu-system-mipsel
endif


# talk to the board...
comm:
	$(COMM)	

#

build:
	mkdir build

clean:
	rm -rf build
