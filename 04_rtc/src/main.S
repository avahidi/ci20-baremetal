
#include <mips/asm.h>
#include <mips/regdef.h>
#include <mips/cpu.h>

    .text
    .set noat

#define DELAY_TIME 2
#define GPIO_PORTF_BASE 0x10010500
#define LED_PIN 15

    .global main
LEAF(main)    
    li s0, GPIO_PORTF_BASE
    li s1, LED_PIN
    li s2, DELAY_TIME


    move a0, s0
    move a1, s1
    jal gpio_setup

    jal timer_setup

loop:    

    move a0, s0
    move a1, s1
    jal gpio_off

    li a0, DELAY_TIME
    jal timer_delay

    li a0, GPIO_PORTF_BASE
    li a1, LED_PIN
    jal gpio_on

    li a0, DELAY_TIME
    jal timer_delay

    b loop

END(main)
