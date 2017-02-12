CI20-baremetal
==============

This project is result of my attempt to learn low-level MIPS programming using the `MIPS Creator CI20`_.
It contains a number of bare-metal experiments inspired by the "`Baking Pi - Operating Systems Development`_ " course by Alex Chadwick at University of Cambridge:

.. _MIPS Creator CI20: http://elinux.org/MIPS_Creator_CI20
.. _Baking Pi - Operating Systems Development: http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/index.html


THE EXPERIMENTS
---------------

The experiments are organized in directories numbered in chronological order:

* 01_led - simplest possible example to access and turn on/off a LED
* 02_delay - code to periodically turn the LED on and off
* 03_function - same as 02, but the code is now organized in a number of functions
* 04_rtc - same as 03, but the code is spread across multiple files. Uses RTC timer for the blinking time
* 05_uart - uses UART to communicate with the board. Also, introduces C...



USAGE
-----


REQUIREMENTS
~~~~~~~~~~~~

You need the following components:

1. A native GCC toolchain and utilities
2. A GCC cross-compiler for MIPS
3. The Linux mkimage utility
4. A client for serial communication


On Ubuntu (and probably also debian) this means::

    sudo apt-get install gcc gcc-mipsel-linux-gnu u-boot-tools minicom


You can also use a third party compiler such as `this one`_, but then you must set the CROSS_COMPILE variable accordingly


.. _this one: https://sourcery.mentor.com/GNUToolchain/subscription3130?lite=MIPS



BUILDING
~~~~~~~~

From project root, execute::

    make

The generated files are in the "build" directory. To look at the generated code enter a directory and run::

    make show


CONNECT TO THE DEVICE
~~~~~~~~~~~~~~~~~~~~~

To connect to the device enter a directory and run::

    make console

This assumes the device is on /dev/ttyUSB0. If not you can set it manually, for example::

    make console DEVICE=dev/ttyACM0


UPLOADING
~~~~~~~~~

You have two options for getting your code into the device:

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



SIMULATING
~~~~~~~~~~

There are currently no simulators for CI20, but you can always use QEMU for MIPS for general testing::

    sudo apt-get install qemu-system-mips

To start qemu and gdb, run these two in separate terminals::

    make qemu
    make gdb

Note that the latter requires GDB for MIPS which is currently not available as an Ubuntu package...
