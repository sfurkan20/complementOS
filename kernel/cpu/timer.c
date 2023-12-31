#include "timer.h"
#include <cpu/io.h>

void timer_init() {
    u32 divisor = HARDWARE_CLOCK_HZ / TIMER_TICKS_PER_SECOND;
    port_write_byte(TIMER_COMMAND_PORT, TIMER_MODE);
    port_write_byte(TIMER_CHANNEL0_DATA_PORT, low_8(divisor));
    port_write_byte(TIMER_CHANNEL0_DATA_PORT, high_8(divisor));
}

void timer_interrupt() {
    static int ticks = 0;
    ticks++;
    if (ticks % TIMER_TICKS_PER_SECOND == 0) {
        //printf("One second!\n");
    }
}