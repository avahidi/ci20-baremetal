
NAME = exp1

CROSS_COMPILE ?= mips-sde-elf-

# tell GCC this is bare-metal little-endian code
CFLAGS += -mel
CFLAGS += -nostartfiles

OUT = build/$(NAME)

#

# how needs intelligent building. always build, just do it...
all: build src/*.*
	$(CROSS_COMPILE)gcc $(CFLAGS) src/*.S -T src/memory.ld -o $(OUT).elf
	$(CROSS_COMPILE)objdump -x -r -t -d $(OUT).elf > $(OUT).dis
	$(CROSS_COMPILE)objcopy -O binary $(OUT).elf $(OUT).bin
	$(CROSS_COMPILE)objcopy -O srec $(OUT).elf $(OUT).srec
	hexdump $(OUT).bin > $(OUT).hex
	mkimage -A mips -O linux -T kernel -a 0x80010000 -C none -d $(OUT).bin $(OUT).img

# optional QEMU stuff
qemu: all
	qemu-system-mipsel -M malta -kernel $(OUT).elf -s -S 

gdb: all
	$(CROSS_COMPILE)gdb $(OUT).elf -ex 'target remote :1234'
#

build:
	mkdir build

clean:
	rm -rf build
