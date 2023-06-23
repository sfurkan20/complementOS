// Reads 1 byte of data from given I/O port.
unsigned char port_read_byte(unsigned short port) {
    unsigned char data;
    __asm__("in %%dx, %%al" : "=a" (data) : "d" (port));
    return data;
}

// Reads 2 bytes (a word) of data from given I/O port.
unsigned short port_read_word(unsigned short port) {
    unsigned short data;
    __asm__("in %%dx, %%al" : "=a" (data) : "d" (port));
    return data;
}

// Writes given 1 byte of data to given I/O port.
void port_write_byte(unsigned short port, unsigned char data) {
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

// Writes given 2 bytes (a word) of data to given I/O port.
void port_write_word(unsigned short port, unsigned char data) {
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}