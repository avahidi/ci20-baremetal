

#include <mips/asm.h>
#include <mips/regdef.h>


    .text
    .set noat
  
// ------------------------------------------------------------
// definitions
// ------------------------------------------------------------
#define GPIO_PORTF_BASE 0x10010500
#define LED_PIN 15

#define GPIO_INTC_CLR 0x18
#define GPIO_MSKS_SET 0x24
#define GPIO_PAT1_CLR 0x38
#define GPIO_PAT0_SET 0x44
#define GPIO_PAT0_CLR 0x48


// GPIO setup
LEAF(gpio_setup)
    li t0, GPIO_PORTF_BASE
    li t1, 1 << LED_PIN

    sw t1, GPIO_INTC_CLR(t0) // its not interrupt
    sw t1, GPIO_MSKS_SET(t0) // its gpio
    sw t1, GPIO_PAT1_CLR(t0) // its output
    j ra
END(gpio_setup)


// turn led off
LEAF(gpio_off)
    li t0, GPIO_PORTF_BASE
    li t1, 1 << LED_PIN
    sw t1, GPIO_PAT0_CLR(t0) // write '0'
    j ra
END(gpio_off)


// turn led on
LEAF(gpio_on)
    li t0, GPIO_PORTF_BASE
    li t1, 1 << LED_PIN
    sw t1, GPIO_PAT0_SET(t0) // write '1'
    j ra
END(gpio_on)
