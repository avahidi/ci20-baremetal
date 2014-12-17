

#include <mips/asm.h>
#include <mips/regdef.h>


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

