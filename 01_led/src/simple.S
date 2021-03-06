    .text
    .set noat
    .set noreorder

    // notice that for this very first exercise we have trued
    // off assembler instruction re-ordering.
    //
    // This means you have to manually handle delay slots and such:
    // https://en.wikipedia.org/wiki/Delay_slot

boot:

    // This code toggles the red power LED.
    //
    // From the schematics, we see that the "SYS_POWER_IND" LED is 
    // connected to "PF15" which is wire 15 on PORT F.
    //
    // PORT F can be accessed from a register group starting at 0x10010500
    li $1, 0x10010500
    li $2, (1 << 15)    //  PORT F bit 15

    // the following code configures the PF15 as a GPIO output pin
    sw $2, 0x18($1)       // PFINTC clear => no interurpts for this pin
    sw $2, 0x24($1)       // PFMSKS set   => its a gpio
    sw $2, 0x38($1)       // PFPAT1 clear => its output

    // now we can set/clear PF15 by writing to the corresponding bit
    // in PFPAT0 set and clear

    sw $2, 0x48($1)        // write '0'

    // we are done, loop forever 
    b .
    nop
