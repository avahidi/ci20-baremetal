

#include <sys/asm.h>
#include <sys/regdef.h>


    .text
    .set noat
  
// ------------------------------------------------------------
// definitions
// ------------------------------------------------------------

#define GPIO_INTC_CLR 0x18
#define GPIO_MSKS_SET 0x24
#define GPIO_PAT1_CLR 0x38
#define GPIO_PAT0_SET 0x44
#define GPIO_PAT0_CLR 0x48


// GPIO setup
LEAF(gpio_setup)
    li t0, 1
    sllv t0, t0, a1

    sw t0, GPIO_INTC_CLR(a0) // its not interrupt
    sw t0, GPIO_MSKS_SET(a0) // its gpio
    sw t0, GPIO_PAT1_CLR(a0) // its output
    j ra
END(gpio_setup)


// turn LED off
LEAF(gpio_off)
    li t0, 1
    sllv t0, t0, a1

    sw t0, GPIO_PAT0_CLR(a0) // write '0'
    j ra
END(gpio_off)


// turn led on
LEAF(gpio_on)
    li t0, 1
    sllv t0, t0, a1

    sw t0, GPIO_PAT0_SET(a0) // write '1'
    j ra
END(gpio_on)
