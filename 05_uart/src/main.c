

void puts(char *s)
{
    while(*s)
        uart_write(*s++);
    uart_write('\n');
    uart_write('\r');
}

int main() {
    gpio_setup();
    uart_setup();
    
    puts("");
    puts("Enter 0 to turn off and 1 to turn the LED on");
    
    for(;;) {
        unsigned char c = uart_read();
        if(c == '0') {
            gpio_off();            
            puts("LED off");
        } else if(c == '1') {
            gpio_on();            
            puts("LED on");
        }
    }
}
