OUTPUT_ARCH(mips)

MEMORY
{
    RAM (rwx)  : ORIGIN = 0x80010000, LENGTH = 16K
}

SECTIONS
{
    .text : {
        * (.text*)
    } > RAM
    
    .rodata : {
        * (.rodata*)
    } > RAM

    /* RAM */
    .data : {
        * (.data*)
    } > RAM

    .bss : {
        * (.bss*)
    } > RAM


    /* crap */
    /DISCARD/ : {
        *(.*)
    } > RAM
}
