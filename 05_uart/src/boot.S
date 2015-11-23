

#include <sys/asm.h>
#include <sys/regdef.h>


    .section .boot
    .set noat
    .set noreorder


// ------------------------------------------------------------
// execution start here:
// ------------------------------------------------------------

__reset:
    // set some sage place of memory as stack top...
    li sp, 0x80020000

    // jump to C code
    la t0, main
    j t0
    nop

    // exit code
    nop
    b .
    nop
