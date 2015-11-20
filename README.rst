CI20-baremetal
==============

This repository contains a number of bare-metal experiments for the `MIPS Creator  CI20`_ development board, inspired by the "`Baking Pi - Operating Systems Development`_ " course by Alex Chadwick at University of Cambridge:

.. _MIPS Creator CI20: http://elinux.org/MIPS_Creator_CI20
.. _Baking Pi - Operating Systems Development: http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/index.html



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

REQUIREMENTS
~~~~~~~~~~~~
1. A native GCC toolchain and utilities (apt-get install gcc).
2. A GCC cross-compiler for MIPS (I use `this one`_).
3. QEMU for little endian MIPS (apt-get install qemu-system-mips).
4. The Linux mkimage utility (apt-get install u-boot-tools).
5. A serial client (apt-get install minicom).

.. _this one: https://sourcery.mentor.com/GNUToolchain/subscription3130?lite=MIPS

BUILDING AND UPLOADING
~~~~~~~~~~~~~~~~~~~~~~

From project root, execute
::

    make

The generated files are in the "build" sub-directory. You have two options for getting your code into the device:

Temporary (from u-boot console):

#. connect to the CI20 serial port and power up the board
#. when you see "Hit any key to stop autoboot", press enter
#. enter "loads"
#. copy-paste contents of build/<name>.srec into the u-boot console
#. enter "go 0x8001000"


Permanent (from SD card):

1. insert a working Linux SD card for CI20
2. backup the boot/vmlinux.img file
3. copy build/<name>.img over boot/vmlinux.img
4. safely eject the SD card and insert it into the CI 20
5. power the board!

