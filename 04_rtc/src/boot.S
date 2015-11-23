

#include <sys/asm.h>
#include <sys/regdef.h>


    .section .boot
    .set noat
    .set noreorder


// ------------------------------------------------------------
// execution start here:
// ------------------------------------------------------------

__reset:
    la t0, main
    j t0
    nop

