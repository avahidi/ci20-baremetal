CI20-baremetal
==============

This repository contains a number of bare-metal experiments for the MIPS Creator CI20 development board:

http://elinux.org/MIPS_Creator_CI20

The experiments were inspired by the "Baking Pi - Operating Systems Development" course by Alex Chadwick at University of Cambridge:

http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/index.html



THE EXPERIMENTS
---------------

The experiments are organised in directories numbered by their chronical order in this project.
Some notable experiments are

* 01_led - simplest possible example to access and turn on/off a LED
* 02_delay - code to periodically turn the LED on and off
* 03_function - same as 02, but the code is now organised in a number of functions
* 04_rtc - same as 03, but the code is spread across multiple files. Uses RTC timer for the blinking time
* 05_uart - uses UART to communicate with the board. Also, introduces C...


USAGE
-----

*REQUIREMENTS*

1. A native GCC toolchain and utilities (apt-get install gcc).
2. A GCC cross-compiler for MIPS (https://sourcery.mentor.com/GNUToolchain/subscription3130?lite=MIPS ).
3. QEMU for little endian MIPS (apt-get install qemu-system-mips).
4. The Linux mkimage utility (apt-get install u-boot-tools).
5. A serial client (apt-get install minicom).

*BUILDING AND UPLOADING*

From project root, execute

```
make

```

The generated files are in the "build" sub-directory. You have two options for uploading them to the device:


Temporary (from u-boot console):

1. power the board
2. when you see "Hit any key to stop autoboot", press enter
3. enter "loads"
4. copy-paste contents of build/<name>.srec into the u-boot console
5. enter "go 0x8001000"


Permanent (from SD card):

1. insert a working Linux SD card for CI20
2. backup the boot/vmlinux.img file
3. copy build/<name>.img over boot/vmlinux.img
4. safely eject the SD card and insert it into the CI 20
5. power the board!

