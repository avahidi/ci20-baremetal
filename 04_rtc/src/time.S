

#include <mips/asm.h>
#include <mips/regdef.h>
#include <mips/cpu.h>

    .text
    .set noat
  
// ------------------------------------------------------------
// definitions
// ------------------------------------------------------------

#define RTC_BASE 0x10003000
#define RTC_CONTROL 0
#define RTC_SAR 4

#define RTC_CONTROL_E   0

LEAF(timer_setup)
    li t0, RTC_BASE
    li t1, (1 << RTC_CONTROL_E)
    sw t1, RTC_CONTROL(t0)    
    j ra
END(timer_setup)


// delay
LEAF(timer_delay)
    li t0, RTC_BASE
    lw t1, RTC_SAR(t0)    
    add t1, t1, a0

1:
    lw t2, RTC_SAR(t0)    

    bne t2, t1, 1b

    j ra
END(timer_delay)
