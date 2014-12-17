

#include <mips/asm.h>
#include <mips/regdef.h>


    .text
    .set noat
  
// ------------------------------------------------------------
// definitions
// ------------------------------------------------------------

#define GPIO_PORTF_BASE 0x10010500
#define GPIO_INTC_CLR 0x18
#define GPIO_MSKS_SET 0x24
#define GPIO_PAT1_CLR 0x38
#define GPIO_PAT0_SET 0x44
#define GPIO_PAT0_CLR 0x48

#define LED_PIN 15

// ------------------------------------------------------------
// execution start here:
// ------------------------------------------------------------

boot:
    jal gpio_setup

loop:    
    jal led_off
    jal delay
    jal led_on
    jal delay
    b loop


// ------------------------------------------------------------
// subroutines
// ------------------------------------------------------------

// GPIO setup
LEAF(gpio_setup)
    li t0, GPIO_PORTF_BASE
    li t1, (1 << LED_PIN)
    sw t1, GPIO_INTC_CLR(t0) // its not interrupt
    sw t1, GPIO_MSKS_SET(t0) // its gpio
    sw t1, GPIO_PAT1_CLR(t0) // its output

    j ra
END(gpio_setup)


// turn LED off
LEAF(led_off)
    li t0, GPIO_PORTF_BASE
    li t1, (1 << LED_PIN)
    sw t1, GPIO_PAT0_CLR(t0) // write '0'

    j ra
END(led_off)


// turn led on
LEAF(led_on)
    li t0, GPIO_PORTF_BASE
    li t1, (1 << LED_PIN)
    sw t1, GPIO_PAT0_SET(t0) // write '1'

    j ra
END(led_on)

// delay
LEAF(delay)
    li $3, 0x400000
1:
    addi $3, $3, -1
    bne $3, $0, 1b

    j ra
END(delay)
