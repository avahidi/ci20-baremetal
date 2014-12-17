    .text
    .set noat

boot:

    // set up the GPIO pin as before
    li $1, 0x10010500
    li $2, (1 << 15)    //  PORT F bit 15
    sw $2, 0x18($1)       // PFINTC clear => its not interrupt
    sw $2, 0x24($1)       // PFMSKS set   => its gpio
    sw $2, 0x38($1)       // PFPAT1 clear => its output



    // the loop
loop:
    
    // clear it
    sw $2, 0x48($1)        // write '0'

    // first delay
    li $3, 0x400000
delay1:
    addi $3, $3, -1
    bne $3, $0, delay1



    // set it
    sw $2, 0x44($1)        // write '1'

    // seond delay
    li $3, 0x400000
delay2:
    addi $3, $3, -1
    bne $3, $0, delay2


    // jump back up
    b loop
