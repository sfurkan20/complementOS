#include "io.h"

// Reads 1 byte of data from given I/O port.
u8 port_read_byte(u16 port) {
    u8 data;
    __asm__("in %%dx, %%al" : "=a" (data) : "d" (port));
    return data;
}

// Reads 2 bytes (a word) of data from given I/O port.
u16 port_read_word(u16 port) {
    u16 data;
    __asm__("in %%dx, %%al" : "=a" (data) : "d" (port));
    return data;
}

// Writes given 1 byte of data to given I/O port.
void port_write_byte(u16 port, u8 data) {
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

// Writes given 2 bytes (a word) of data to given I/O port.
void port_write_word(u16 port, u16 data) {
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}