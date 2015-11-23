

#include <sys/asm.h>
#include <sys/regdef.h>

    .text
    .set noat
  
// ------------------------------------------------------------
// definitions
// ------------------------------------------------------------

#define UART0_BASE 0x10030000

#define UART_RBR_R 0
#define UART_THR_W 0
#define UART_IER   4
#define UART_IIR_R 8
#define UART_FCR_W 8
#define UART_LCR   12
#define UART_MCR   16
#define UART_LSR_R 20
#define UART_USR   32

#define UART_DLLR_DLAB 0
#define UART_DLHR_DLAB 4

//
// Initialize the 16550-ish UART
//
LEAF(uart_setup)
    li t0, UART0_BASE

    // disable uart and interrupts
    sb zero, UART_IER(t0)
    sb zero, UART_FCR_W(t0)

    // set UART mode
    sb zero, UART_LSR_R(t0)

    // 8N1, DLAB=1
    li t1, 0x83
    sb t1, UART_LCR(t0)

    // set baud rate to 115200
    li t1, 26
    sb t1, UART_DLLR_DLAB(t0)
    sb zero, UART_DLHR_DLAB(t0)

    // 8N1, DLAB=0
    li t1, 0x03
    sb t1, UART_LCR(t0)

    // enable uart
    li t1, 0x17
    sb t1, UART_FCR_W(t0)

    j ra
END(uart_setup)



LEAF(uart_write)
    li t0, UART0_BASE

    // wait until write queue is ready
1:
    lbu t1, UART_LSR_R(t0)
    andi t1, t1, 0x20 // UART_LSR_TDRQ
    beqz t1, 1b

    // write it!
    sb a0, UART_THR_W(t0)
    j ra
END(uart_write)


LEAF(uart_read)
    li t0, UART0_BASE

    // wait until we have something to read
1:
    lbu t1, UART_LSR_R(t0)
    andi t1, t1, 0x01 // UART_LSR_DRY
    beqz t1, 1b

    // read it!
    lbu v0, UART_RBR_R(t0)
    j ra
END(uart_read)
